local filesystem = require("themery.filesystem")
local constants = require("themery.constants")

local state_folder_path = vim.fn.stdpath("data") .. "/themery"
local state_file_path = state_folder_path .. "/state.json"

-- Configuration settings for Themery plugin
local configSettings = {}

-- Validates the configuration settings for correctness and completeness
-- @return boolean indicating if the configuration is valid
local function isConfigValid()
	if next(configSettings) == nil then
		print(constants.MSG_INFO.NO_SETUP)
		return false
	end

	local themeList = configSettings.themes
	local errors = {}

	for _, theme in pairs(themeList) do
		if theme.before then
			if type(theme.before) ~= "string" then
				local message = 'Before in "' .. theme.name .. '" should be a text.'
				table.insert(errors, message)
			end
		end

		if theme.after then
			if type(theme.after) ~= "string" then
				local message = 'After in "' .. theme.name .. '" should be a text.'
				table.insert(errors, message)
			end
		end
	end

	if type(configSettings.globalBefore) ~= "string" then
		local message = 'Global before should be a text.'
		table.insert(errors, message)
	end

  if type(configSettings.globalAfter) ~= "string" then
		local message = 'Global after should be a text.'
		table.insert(errors, message)
	end

	if #errors > 0 then
		print("Themery config has some errors in their config:")
		for _, error in ipairs(errors) do
			print("  - " .. error)
		end
		print('\nCheck "help" and fix them.')
		return false
	end
	return true
end

-- Normalizes the theme list to ensure consistency in structure
local function normalizeThemeList()
	for i, v in ipairs(configSettings.themes) do
		if type(v) == "string" then
			configSettings.themes[i] = {
				name = v,
				colorscheme = v,
			}
		end
	end
end

-- Normalizes file paths to absolute paths
local function normalizePaths()
	local path = configSettings.themeConfigFile
	local normalizedPath = vim.fn.fnamemodify(path, ":p") -- Get Full path
	configSettings.themeConfigFile = normalizedPath
end

local function checkDeprecatedConfig()
	local configFilePath = configSettings.themeConfigFile
	if configFilePath and not configFilePath:match("v:null") then
		print(constants.MSG_INFO.THEME_CONFIG_FILE_DEPRECATED)
	end
end

-- Sets up the Themery configuration with user-defined settings
-- @param userConfig table containing user-defined settings
-- @return table containing the merged settings
local function setup(userConfig)
	configSettings = vim.tbl_deep_extend("keep", userConfig or {}, constants.DEFAULT_SETTINGS)

	normalizeThemeList()
	normalizePaths()
	checkDeprecatedConfig()

  -- Check if globalAfter and globalAfter is changed.

  local status, json_data = pcall(function()
    return filesystem.readFromFile(state_file_path)
  end)

  if status then
    local data = vim.json.decode(json_data)

    if configSettings.globalBefore ~= data.globalBeforeCode or configSettings.globalAfter ~= data.globalAfterCode then
      -- If globalAfter and globalAfter did changed, update the state file.

      data.globalBeforeCode = configSettings.globalBefore
      data.globalAfterCode = configSettings.globalAfter

      filesystem.writeToFile(state_file_path, vim.json.encode(data))

      print(constants.MSG_INFO.GLOBAL_SETTINGS_CHANGED)
    end
  end

	return configSettings
end

-- Retrieves the current configuration settings
-- @return table containing the current settings
local getSettings = function()
	return configSettings
end

return {
	setup = setup,
	getSettings = getSettings,
	isConfigValid = isConfigValid,
}

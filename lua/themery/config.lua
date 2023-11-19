local constants = require("themery.constants")
local settings = {}

local function isConfigValid()
	if next(settings) == nil then
		print(constants.MSG_INFO.NO_SETUP)
		return
	end

	local themeList = settings.themes
	local errors = {}

	for i, theme in pairs(themeList) do
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

	if #errors > 0 then
		print("Themery config have some errors in their config:")
		for _, error in ipairs(errors) do
			print("  - " .. error)
		end
		print('\nCheck "help" and fix then.')
		return false
	end
	return true
end

local function normalizeThemeList()
	for i, v in ipairs(settings.themes) do
		if type(v) == "string" then
			settings.themes[i] = {
				name = v,
				colorscheme = v,
			}
		end
	end
end

local function normalizePaths()
	local path = settings.themeConfigFile
	local normalizedPath = vim.fn.fnamemodify(path, ":p") -- Get Full path
	settings.themeConfigFile = normalizedPath
end

local function setup(userConfig)
	settings = vim.tbl_deep_extend("keep", userConfig or {}, constants.DEFAULT_SETTINGS)
	normalizeThemeList()
	normalizePaths()
	return settings
end

local getSettings = function()
	return settings
end

return {
	setup = setup,
	getSettings = getSettings,
	isConfigValid = isConfigValid,
}

local constants = require("themery.constants")
local config = require("themery.config")
local utils = require("themery.utils")

-- Constants for identifying the start and end of the Themery configuration block in the user's config file.
local START_MARKET = "-- Themery block"
local END_MARKET = "-- end themery block"

-- Saves the selected theme configuration to the user's config file.
-- @param theme table containing the theme data
-- @param theme_id number representing the theme's ID
local function saveTheme(theme, theme_id)
	local configFilePath = config.getSettings().themeConfigFile
	local file = io.open(configFilePath, "r")

	if file == nil then
		print(constants.MSG_ERROR.READ_FILE .. ": " .. configFilePath)
		return
	end

	local content = file:read("*all")
	file:close()

	local start_pos, end_pos = content:find(START_MARKET .. "\n(.+)\n" .. END_MARKET)

	if not start_pos or not end_pos then
		print(constants.MSG_ERROR.NO_MARKETS)
		return
	end

	local beforeCode = theme.before and utils.trimStartSpaces(theme.before) .. "\n" or ""
	local afterCode = theme.after and "\n" .. utils.trimStartSpaces(theme.after) or ""

	local configToWrite = START_MARKET
	configToWrite = configToWrite .. "\n-- This block will be replaced by Themery.\n"
	configToWrite = configToWrite .. beforeCode
	configToWrite = configToWrite .. 'vim.cmd("colorscheme ' .. theme.colorscheme .. '")\n'
	configToWrite = configToWrite .. afterCode
	configToWrite = configToWrite .. "vim.g.theme_id = " .. theme_id
	configToWrite = configToWrite .. "\n" .. END_MARKET

	local replaced_content = content:sub(1, start_pos - 1) .. configToWrite .. content:sub(end_pos + 1)

	local outfile = io.open(configFilePath, "w")

	if outfile == nil then
		print(constants.MSG_ERROR.WRITE_FILE .. ": " .. configFilePath)
		return
	end

	outfile:write(replaced_content)
	outfile:close()
	print(constants.MSG_INFO.THEME_SAVED)
end

-- Checks if the user's config file is valid for Themery's persistence feature.
-- @return boolean indicating if the file is valid
local function isFileValid()
	local configFilePath = config.getSettings().themeConfigFile
	local file = io.open(configFilePath, "r")

	if not file then
		error("Persistence file no exist: " .. configFilePath)
	end

	local fileContent = file:read("*a")
	file:close()

	local start_pos, end_pos = fileContent:find(START_MARKET .. "\n(.+)\n" .. END_MARKET)

	if not start_pos or not end_pos then
		error("No valid marks in persistence file (no themery start and end block found)")
	end

	return true
end

return {
	saveTheme = saveTheme,
	isFileValid = isFileValid,
}

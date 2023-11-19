local constants = require("themery.constants")
local config = require("themery.config")
local utils = require("themery.utils")

local START_MARKET = "-- Themery block"
local END_MARKET = "-- end themery block"

local function saveTheme(theme, theme_id)
	local configFilePath = config.getSettings().themeConfigFile
	local file = io.open(configFilePath, "r")

	if file == nil then
		print(constants.MSG_ERROR.READ_FILE .. ": " .. configFilePath)
		return
	end

	local content = file:read("*all")

	local start_pos, end_pos = content:find(START_MARKET .. "\n(.+)\n" .. END_MARKET)

	if not start_pos or not end_pos then
		print(constants.MSG_ERROR.NO_MARKETS)
		return
	end

	local beforeCode = ""
	local afterCode = ""

	if theme.before then
		beforeCode = utils.trimStartSpaces(theme.before) .. "\n"
	end

	if theme.after then
		afterCode = "\n" .. utils.trimStartSpaces(theme.after)
	end

	local configToWrite = "-- This block will be replaced by Themery.\n"
	configToWrite = configToWrite .. beforeCode
	configToWrite = configToWrite .. 'vim.cmd("colorscheme '
	configToWrite = configToWrite .. theme.colorscheme .. '")\n'
	configToWrite = configToWrite .. afterCode
	configToWrite = configToWrite .. "vim.g.theme_id = " .. theme_id

	local replaced_content = content:sub(1, start_pos - 1)
		.. START_MARKET
		.. "\n"
		.. configToWrite
		.. "\n"
		.. END_MARKET
		.. content:sub(end_pos + 1)

	local outfile = io.open(configFilePath, "w")

	if outfile == nil then
		print(constants.MSG_ERROR.WRITE_FILE .. ": " .. configFilePath)
		return
	end

	outfile:write(replaced_content)
	outfile:close()
	print(constants.MSG_INFO.THEME_SAVED)
end

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

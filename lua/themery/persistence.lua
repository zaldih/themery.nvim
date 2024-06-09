local constants = require("themery.constants")
local config = require("themery.config")
local utils = require("themery.utils")
local state_path = vim.fn.stdpath("data") .. "/themery/state.json"

-- Saves the selected theme configuration to the user's config file.
-- @param theme table containing the theme data
-- @param theme_id number representing the theme's ID
local function saveTheme(theme, theme_id)
    local data = {
        version = 0,
        beforeCode = theme.before and utils.trimStartSpaces(theme.before) or "",
        colorscheme = theme.colorscheme,
        afterCode = theme.after and utils.trimStartSpaces(theme.after) or "",
		theme_id = theme_id
    }

    local json_data = vim.json.encode(data)

	-- Create plugin folder if not exist. :h remove the last part of the path
	os.execute("mkdir -p " .. vim.fn.fnamemodify(state_path, ":h"))
    local file = io.open(state_path, "w")

    if file == nil then
        print(constants.MSG_ERROR.WRITE_FILE .. ": " .. state_path)
        return
    end

    file:write(json_data)
    file:close()
    print(constants.MSG_INFO.THEME_SAVED)
end

local function loadState()
    local file = io.open(state_path, "r")

    if file == nil then
        -- No config file found
        return
    end

    local json_data = file:read("*all")
    file:close()

    local data = vim.json.decode(json_data)

	-- Set a global variable in vim
	vim.g.theme_id = data.theme_id
	local fn, err = load(data.beforeCode)
	if fn then
		fn()
	end
    vim.cmd("colorscheme " .. data.colorscheme)
	local fn, err = load(data.afterCode)
	if fn then
		fn()
	end
end

return {
	saveTheme = saveTheme,
	loadState = loadState,
}

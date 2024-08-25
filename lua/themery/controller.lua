local constants = require("themery.constants")
local config = require("themery.config")
local persistence = require("themery.persistence")
local window = require("themery.window")
local api = vim.api

local position = 0
local selectedThemeId = 0
local resultsStart = constants.RESULTS_TOP_MARGIN

local function loadActualThemeConfig()
	local themeList = config.getSettings().themes
	selectedThemeId = vim.g.theme_id

	-- if currentThemeId isn't set, it's because it's the first time it has been run
	if not selectedThemeId then
		position = resultsStart
		return
	end

	for k in pairs(themeList) do
		if selectedThemeId == k then
			position = k + resultsStart - 1
			return
		end
	end
end

local function setColorscheme(theme)
	if theme.before then
		local fn, err = load(theme.before)
		if err then
			print("Themery error: " .. err)
			return false
		end
		if fn then
			fn()
		end
	end

	local ok, _ = pcall(vim.cmd, "colorscheme " .. theme.colorscheme)

	-- check if the colorscheme was loaded successfully
	if not ok then
		print(constants.MSG_ERROR.THEME_NOT_LOADED .. ": " .. theme.colorscheme)
		-- Restore previus
		vim.cmd("colorscheme " .. config.getSettings().themes[selectedThemeId])
		return false
	end

	if theme.after then
		local fn, err = load(theme.after)
		if err then
			print(constants.MSG_ERROR.GENERIC .. ": " .. err)
			return false
		end
		if fn then
			fn()
		end
	end

	return true
end

local function updateView(direction)
	local themeList = config.getSettings().themes
	position = position + direction
	api.nvim_set_option_value("modifiable", true, {buf=window.getBuf()})

	-- cycle to the last result if cursor is at the top of the results list and moved up
	if position < resultsStart then
		position = #themeList + resultsStart - 1
	end

	-- cycle to the first result if cursor is at the bottom of the results list and moved down
	if position > #themeList + 1 then
		position = resultsStart
	end

	if #themeList == 0 then
		window.printNoThemesLoaded()
		api.nvim_set_option_value("modifiable", false, {buf=window.getBuf()})
		return
	end

	local resultToPrint = {}
	for i in ipairs(themeList) do
		local prefix = "  "

		if selectedThemeId == i then
			prefix = "> "
		end

		resultToPrint[i] = prefix .. themeList[i].name
	end

	api.nvim_buf_set_lines(window.getBuf(), 1, -1, false, resultToPrint)
	api.nvim_win_set_cursor(window.getWin(), { position, 0 })

	if config.getSettings().livePreview then
		setColorscheme(themeList[position - 1])
	end

	api.nvim_set_option_value("modifiable", false, {buf=window.getBuf()})
end

local function revertTheme()
	local colorschemeToSet

	-- If there is no previous theme to revert to, use the default.
	if selectedThemeId then
		colorschemeToSet = config.getSettings().themes[selectedThemeId]
	else
		colorschemeToSet = { colorscheme = "default" }
	end
	setColorscheme(colorschemeToSet)
end

local function open()
	loadActualThemeConfig()
	window.openWindow()
	updateView(0)
end

local function close()
	window.closeWindow()
end

local function setPosition (value)
  position = value
end

local function closeAndRevert()
	revertTheme()
	window.closeWindow()
end

local function save()
	local theme = config.getSettings().themes[position - 1]
	persistence.saveTheme(theme, position - 1)
	selectedThemeId = position - 1
	vim.g.theme_id = selectedThemeId
end

local function closeAndSave()
	save()
	window.closeWindow()
end

--- Sets the colorscheme based on the specified name.
-- This function retrieves the list of available themes from the config,
-- searches for the theme with the specified name, and applies the colorscheme.
--
-- @param name string The name of the theme to apply.
-- @param makePersistent boolean Whether to save the current state after applying the colorscheme.
-- @usage
-- 	 setThemeByName("monokai") -- Applies the monokai theme
--
-- @error Prints an error message if the theme is not found.
local function setThemeByName(name, makePersistent)
	makePersistent = makePersistent or false
	local themes = config.getSettings().themes
	for index, theme in ipairs(themes) do
		if theme.name == name or theme.colorscheme == name then
			position = index + 1
			selectedThemeId = index + 1
			setColorscheme(themes[index])
			if makePersistent then
				save()
			end
			return
		end
	end
	print("Themery: Theme \"" .. name .. "\" not found.")
end

--- Sets the colorscheme based on the specified index.
-- This function retrieves the list of available themes from the config,
-- validates the provided index, and applies the colorscheme at that index.
-- If the index is out of range, an error message is printed. After setting the
-- colorscheme, the current state is saved.
--
-- @param index number The index of the theme to apply. Must be between 1 and the total number of available themes.
-- @param makePersistent boolean Whether to save the current state after applying the colorscheme.
-- @usage
--   setThemeByIndex(2)  -- Applies the theme at index 2
--
-- @error Prints an error message if the index is invalid.
local function setThemeByIndex(index, makePersistent)
	makePersistent = makePersistent or false
	local themes = config.getSettings().themes
	if index < 1 or index > #themes then
		print("Themery: Invalid index. Should be between 1 and " .. #themes .. ".")
		return
	end
	position = index + 1
	selectedThemeId = index
	setColorscheme(themes[index])
	if makePersistent then
		save()
	end
end

--- Retrieves the current theme..
--
-- @return table|nil A table containing the name and index of the current theme if it exists, or nil if not.
local function getCurrentTheme()
	loadActualThemeConfig()
	local themes = config.getSettings().themes
	if themes[selectedThemeId] then
		return {
			name = themes[selectedThemeId].name,
			index = position
		}
	else
		return nil
	end
end

--- Retrieves the available themes.
--
-- @return table A table containing the available themes.
local function getAvailableThemes()
	loadActualThemeConfig()
	return config.getSettings().themes
end

local function bootstrap()
	loadActualThemeConfig()
	persistence.loadState() 
end

return {
	open = open,
	close = close,
  setPosition = setPosition,
	closeAndRevert = closeAndRevert,
	closeAndSave = closeAndSave,
	updateView = updateView,
	loadActualThemeConfig = loadActualThemeConfig,
	setColorscheme = setColorscheme,
	bootstrap = bootstrap,
	setThemeByName = setThemeByName,
	setThemeByIndex = setThemeByIndex,
	getCurrentTheme = getCurrentTheme,
	getAvailableThemes = getAvailableThemes
}

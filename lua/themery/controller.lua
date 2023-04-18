local constants = require("themery.constants")
local config = require("themery.config")
local utils = require("themery.utils")
local persistence = require("themery.persistence")
local window = require("themery.window")
local api = vim.api

local position = 0
local currentThemeIndex = -1
local currentThemeName = ""
local resultsStart = constants.RESULTS_TOP_MARGIN

local function loadActualThemeConfig()
  local themeList = config.settings.themes;
  currentThemeName = vim.g.colors_name

  for k in pairs(themeList) do
    if currentThemeName == themeList[k].colorscheme then
      currentThemeIndex = k
      position = k + resultsStart - 1
      return
    end
  end
end

local function setColorscheme(theme)
  if theme.before then
    local fn, err = load(theme.before)
    if err then
      print("Themery error: "..err)
      return false
    end
    if fn then fn() end
  end

  local ok, _ = pcall(
    vim.cmd,
    "colorscheme "..theme.colorscheme
  )

  -- check if the colorscheme was loaded successfully
  if not ok then
    print(constants.MSG_ERROR.THEME_NOT_LOADED..": "..theme)
    -- Restore previus
    vim.cmd('colorscheme '..currentThemeName)
    return false
  end

  if theme.after then
    local fn, err = load(theme.after)
    if err then
      print(constants.MSG_ERROR.GENERIC..": "..err)
      return false
    end
    if fn then fn() end
  end

  return true
end

local function updateView(direction)
  local themeList = config.settings.themes;
  position = position + direction
  vim.api.nvim_buf_set_option(window.getBuf(), 'modifiable', true)
  if position < resultsStart then position = resultsStart end
  if position > #themeList + 1 then position = #themeList + 1 end

  if #themeList == 0 then
    window.printNoThemesLoaded()
    vim.api.nvim_buf_set_option(window.getBuf(), 'modifiable', false)
    return
  end

  local resultToPrint = {}
  for i in ipairs(themeList) do
    local prefix = '  '

    if currentThemeIndex == i then
      prefix = '> '
    end

    resultToPrint[i] = prefix..themeList[i].name
  end

  api.nvim_buf_set_lines(window.getBuf(), 1, -1, false, resultToPrint)
  api.nvim_win_set_cursor(window.getWin(), {position, 0})

  if config.settings.livePreview then
    setColorscheme(themeList[position-1])
  end

  vim.api.nvim_buf_set_option(window.getBuf(), 'modifiable', false)
end

local function revertTheme()
  setColorscheme(config.settings.themes[currentThemeIndex])
end

local function open()
  window.openWindow()
  loadActualThemeConfig()
  updateView(0)
end

local function close()
  window.closeWindow()
end

local function closeAndRevert()
  revertTheme()
  window.closeWindow()
end

local function closeAndSave()
  local theme = config.settings.themes[position-1]
  persistence.saveTheme(theme)
  window.closeWindow()
  print(constants.MSG_INFO.THEME_SAVED)
end

return {
  open = open,
  close = close,
  closeAndRevert = closeAndRevert,
  closeAndSave = closeAndSave,
  updateView = updateView,
  loadActualThemeConfig = loadActualThemeConfig,
  setColorscheme = setColorscheme,
}

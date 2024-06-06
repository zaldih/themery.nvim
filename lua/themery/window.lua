local constants = require("themery.constants")
local utils = require("themery.utils")
local api = vim.api
local buf, win

-- Calculates the window transformation for centering the Themery window
local function getWinTransform()
  local totalWidth = api.nvim_get_option("columns")
  local totalHeight = api.nvim_get_option("lines")
  local height = math.ceil(totalHeight * 0.4 - 4)
  local width = math.ceil(totalWidth * 0.3)

  return {
    row = math.ceil((totalHeight - height) / 2 - 1),
    col = math.ceil((totalWidth - width) / 2),
    height = height,
    width = width,
  }
end

-- Opens the Themery window with minimal style and centered positioning
local function openWindow()
  buf = api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'themery')
  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')

  local winTransform = getWinTransform()

  local opts = {
    style = "minimal",
    relative = "editor",
    border="rounded",
    width = winTransform.width,
    height = winTransform.height,
    row = winTransform.row,
    col = winTransform.col,
  }

  win = api.nvim_open_win(buf, true, opts)
  vim.api.nvim_win_set_option(win, 'cursorline', true)

  local title = utils.centerHorizontal(constants.TITLE)
  api.nvim_buf_set_lines(buf, 0, -1, false, { title })
end

-- Closes the Themery window
local function closeWindow()
  api.nvim_win_close(win, true)
end

-- Prints a message when no themes are loaded
local function printNoThemesLoaded()
  local text = constants.MSG_INFO.NO_THEMES_CONFIGURED
  api.nvim_buf_set_lines(buf, 1, -1, false, { text })
end

-- Retrieves the buffer ID of the Themery window
local getBuf = function()
  return buf
end

-- Retrieves the window ID of the Themery window
local getWin = function()
  return win
end

return {
  openWindow = openWindow,
  closeWindow = closeWindow,
  printNoThemesLoaded = printNoThemesLoaded,
  getBuf = getBuf,
  getWin = getWin,
}

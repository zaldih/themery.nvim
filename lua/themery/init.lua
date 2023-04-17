local greet = require("themery.module")
local utils = require("themery.utils")

local api = vim.api
local buf, win
local resultsStart = 2
local position = 0
local themes = {"gruvbox", "tokyonight", "kanagawa", "kanagawa-dragon"}
local currentThemeIndex = -1

local function loadActualConfig()
  local currentThemeName = vim.g.colors_name
  for k in pairs(themes) do
    if currentThemeName == themes[k] then
      currentThemeIndex = k
      position = k + resultsStart - 1
      return
    end
  end
end

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

  local title = utils.centerHorizontal('Themery - Theme Selector')
  api.nvim_buf_set_lines(buf, 0, -1, false, { title })
end

local function updateView(direction)
  vim.api.nvim_buf_set_option(buf, 'modifiable', true)
  position = position + direction
  if position < resultsStart then position = resultsStart end

  local resultToPrint = {}

  if #themes == 0 then table.insert(themes, '') end
  for k in pairs(themes) do
    local prefix = '  '

    if currentThemeIndex == k then
      prefix = '> '
    end

    resultToPrint[k] = prefix..themes[k]
  end

  if position > #themes + 1 then position = #themes + 1 end

  api.nvim_buf_set_lines(buf, 1, -1, false, resultToPrint)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  api.nvim_win_set_cursor(win, {position, 0})

  print("Selected: "..themes[position-1])
  vim.cmd('colorscheme '..themes[position-1])
end

local function closeWindow()
  api.nvim_win_close(win, true)
end

local function setMappings()
  local mappings = {
    k = 'updateView(-1)',
    j = 'updateView(1)',
    q = 'closeWindow()',
    ['<Esc>'] = 'closeWindow()',
    ['<cr>'] = 'closeWindow()',
  }

  for k,v in pairs(mappings) do
    api.nvim_buf_set_keymap(buf, 'n', k, ':lua require("themery").'..v..'<cr>', {
        nowait = true, noremap = true, silent = true
      })
  end
end

local function pop()
  loadActualConfig()
  openWindow()
  setMappings()
  updateView(0)
end

return {
  greet = greet,
  pop = pop,
  updateView = updateView,
  closeWindow = closeWindow
}

local controller = require("themery.controller")
local window = require("themery.window")
local config = require("themery.config")
local api = vim.api

local function setMappings()
  local mappings = {
    k = 'updateView(-1)',
    j = 'updateView(1)',
    q = 'closeAndRevert()',
    ['<Esc>'] = 'closeAndRevert()',
    ['<cr>'] = 'closeAndSave()',
  }

  for k,v in pairs(mappings) do
    api.nvim_buf_set_keymap(window.getBuf(), 'n', k, ':lua require("themery").'..v..'<cr>', {
        nowait = true, noremap = true, silent = true
      })
  end
end

local function pop()
  config.setup({
    themes = {"tokyonight", {
      name = "gruvbox dark",
      colorscheme = "gruvbox",
      before = [[
        vim.opt.background="dark"
      ]]
    }, {
      name = "gruvbox light",
      colorscheme = "gruvbox",
      after = [[
        vim.opt.background="light"
      ]]
      }, "kanagawa", "kanagawa-dragon", "kanagawa-lotus"},
    themesConfigFile = "~/.config/nvim/lua/settings/theme.lua",
  }) -- TEMP

  controller.open()
  setMappings()
end

return {
  pop = pop,
  open = controller.open,
  closeAndRevert = controller.closeAndRevert,
  closeAndSave = controller.closeAndSave,
  updateView = controller.updateView,
}

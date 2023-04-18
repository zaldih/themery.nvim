local controller = require("themery.controller")
local window = require("themery.window")
local config = require("themery.config")
local constants = require("themery.constants")
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
  if not config.isConfigured() then
    print(constants.MSG_INFO.NO_SETUP)
    return
  end

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

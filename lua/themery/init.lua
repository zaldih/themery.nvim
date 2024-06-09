local controller = require("themery.controller")
local window = require("themery.window")
local config = require("themery.config")
local constants = require("themery.constants")
local api = vim.api

controller.bootstrap()

local function setMappings()
	local mappings = {
		k = "updateView(-1)",
		j = "updateView(1)",
		["<Up>"] = "updateView(-1)",
		["<Down>"] = "updateView(1)",
		q = "closeAndRevert()",
		["<Esc>"] = "closeAndRevert()",
		["<cr>"] = "closeAndSave()",
	}

	for k, v in pairs(mappings) do
		api.nvim_buf_set_keymap(window.getBuf(), "n", k, ':lua require("themery").' .. v .. "<cr>", {
			nowait = true,
			noremap = true,
			silent = true,
		})
	end
end

local function themery()
	if not config.isConfigValid() then
		return
	end

	controller.open()
	setMappings()
end

return {
	themery = themery,
	setup = config.setup,
	closeAndRevert = controller.closeAndRevert,
	closeAndSave = controller.closeAndSave,
	updateView = controller.updateView,
}

local persistence = require("themery.persistence")
local controller = require("themery.controller")
local window = require("themery.window")
local config = require("themery.config")
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

local function setup(userConfig)
  local configSettings = config.setup(userConfig)

  -- Fall back to
  if persistence.getIfNeedFallback() then
    for i = 1, #configSettings.themes do
      local status = pcall(function () vim.cmd.colorscheme(configSettings.themes[i].colorscheme) end)

      if status then
        persistence.saveTheme(configSettings.themes[i], i)
        controller.setPosition(i)

        break
      end
    end
  end
end

return {
	themery = themery,
	setup = setup,
	closeAndRevert = controller.closeAndRevert,
	closeAndSave = controller.closeAndSave,
	updateView = controller.updateView,
}

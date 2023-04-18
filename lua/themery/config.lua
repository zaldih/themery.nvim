local constants = require("themery.constants")
local utils = require("themery.utils")
local settings = {}

local function normalizeThemeList()
  for i,v in ipairs(settings.themes) do
    if(type(v) == "string") then
      settings.themes[i] = {
        name = v,
        colorscheme = v
      }
    end
  end
end

local function setup(userConfig)
  settings = vim.tbl_deep_extend("keep", userConfig or {}, constants.DEFAULT_SETTINGS)
  normalizeThemeList()
  return settings
end

local function isConfigured()
  return next(settings) == not nil
end

local getSettings = function()
  return settings
end

return {
  setup = setup,
  isConfigured = isConfigured,
  getSettings = getSettings,
}

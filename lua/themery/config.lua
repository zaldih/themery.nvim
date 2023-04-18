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

local function normalizePaths()
  local path = settings.themeConfigFile
  local normalizedPath = vim.fn.fnamemodify(path, ":p") -- Get Full path
  settings.themeConfigFile = normalizedPath
end

local function setup(userConfig)
  settings = vim.tbl_deep_extend("keep", userConfig or {}, constants.DEFAULT_SETTINGS)
  normalizeThemeList()
  normalizePaths()
  return settings
end

local function isConfigured()
  return next(settings) ~= nil
end

local getSettings = function()
  return settings
end

return {
  setup = setup,
  isConfigured = isConfigured,
  getSettings = getSettings,
}

local TITLE = "Themery - Theme Selector"

local DEFAULT_SETTINGS = {
    themes = {},
    themesConfigFile = "",
    livePreview = true,
}

local RESULTS_TOP_MARGIN = 2

local MSG_INFO = {
  NO_SETUP = "Themery is not configured. See installation guide.",
  NO_THEMES_CONFIGURED = "No themes configured. See :help Themery",
  THEME_SAVED = "Theme saved",
  THEME_CONFIG_FILE_DEPRECATED = "Themery: The ‘themeConfigFile’ property is deprecated. Delete it from config and use normally. More info in the project page.",
}

local MSG_ERROR = {
    THEME_NOT_LOADED = "Themery error: Could not load theme",
    GENERIC = "Themery error",
    NO_MARKETS = "Themery error: Could not find markets in config file. See \"Persistence\"",
    READ_FILE = "Themery error: Could not open file for read",
    WRITE_FILE = "Themery error: Could not open file for writing",
}

return {
  TITLE = TITLE,
  DEFAULT_SETTINGS = DEFAULT_SETTINGS,
  RESULTS_TOP_MARGIN = RESULTS_TOP_MARGIN,
  MSG_INFO = MSG_INFO,
  MSG_ERROR = MSG_ERROR,
}

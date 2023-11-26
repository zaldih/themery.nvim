local Installed_Themes = {}

local all_installed_themes = vim.fn.getcompletion("", "color")

local default_vim_themes = { "blue", "darkblue", "default", "delek", "desert", "elflord", "evening", "habamax", "industry", "koehler", "lunaperche", "morning", "murphy", "pablo", "peachpuff", "quiet", "ron", "shine", "slate", "torte", "zellner", }

Installed_Themes.all_installed_themes = all_installed_themes

Installed_Themes.default_vim_themes = default_vim_themes

return Installed_Themes

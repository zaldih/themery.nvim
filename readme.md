<p align="center">
<img src="docs/title-logo.svg" width="420">
</p>

#

Themery is a plugin for Neovim written in Lua which allows you to quickly switch between your installed themes through a menu. Very convenient.

## Motivation

In most text editors there is usually an option to change the subject quickly. This is very useful for adapting if you work in daylight or at night, if you have to make a presentation on a projector or simply because you like to change often.

In vim there is no "efficient" way to change them;

1. You can change it in the configuration file but that involves opening and editing it.
2. You can use `:colorscheme <theme>` but it is temporary and sometimes you need to run some more command to apply the theme to other plugins or set some variables.

Themery adds to your neovim a menu from which you can switch between all of them simply and quickly.

## WIP

**Project under development.**
Many things can change at any time and the plugin may not be stable.

**Let me know if you have any suggestions, comments or bugs!**

## Features

- Sort and name as you wish.
- Apply themes in real time.
- Persistently saves the theme (or not).
- Executes instructions before and/or after applying a theme.

### To-do

- Add categories (Light/Dark).
- Expose the API to be able to switch between themes without opening the menu.

In the future I would like the plugin to become a complete theme manager so that themes can be tested on the fly before installing them or browsing through a community repertoire.

## Installation

Choose one of these options and continue with "Configuration".

### vim-plug

```
Plug 'zaldih/themery.nvim'
```

### Packer

```
use 'zaldih/themery.nvim'
```

## Configuration

Configuration is simple and intuitive. It consists of 2 steps which are described below:

1. Setup
2. Persistence

### Setup

#### Minimal config

Let's get down to the nitty-gritty first. Anywhere in your configuration put this:

```lua
-- Minimal config
require("themery").setup({
  themes = {"gruvbox", "ayu", ...}, -- Your list of installed colorschemes
  themeConfigFile = "~/.config/nvim/lua/settings/theme.lua", -- Described below
  livePreview = true, -- Apply theme while browsing. Default to true.
})
```

Thats is all! When you open Themery you will see the above list.

#### Customizing names

Let's see how we can customise the list a bit...

```lua
-- Set custom name to the list
require("themery").setup({
  themes = {{
    name = "Day",
    colorscheme = "kanagawa-lotus",
  },
  {
    name = "Night",
    colorscheme = "kanagawa-dragon",
  }},
  [...]
})
```

#### Executing code on theme apply

Let's go one step further.

Sometimes it is necessary to add additional instructions to make your favourite theme work.

Themery includes a before and after option that will be executed respectively before applying the theme.

For example, gruvbox uses a variable to switch between light and dark mode.

```lua
-- Using before and after.
require("themery").setup({
  themes = {{
    name = "Gruvbox dark",
    colorscheme = "gruvbox",
    before = [[
      -- All this block will be executed before apply "set colorscheme"
      vim.opt.background = "dark"
    ]],
  },
  {
    name = "Gruvbox light",
    colorscheme = "gruvbox",
    before = [[
      vim.opt.background = "light"
    ]],
    after = [[-- Same as before, but after if you need it]]
  }},
  [...]
})
```

That is, everything inside those variables will be executed as Lua code.

_Due to technical limitations, for now "functions" can only be declared as text instead of functions._

### Persistence

Changes made to the plugin are written directly to your configuration file. This way themes can be loaded even without the plugin being loaded.

To do this you have to put this code snippet wherever you see fit (i recommend in a dedicated file). I will use `~/.config/nvim/lua/theme.lua`

```lua
-- Themery block
  -- This block will be replaced by Themery.
-- end themery block
```

Remember the themeConfigFile option? You will have to put the path to the file where you have written the above.
This way Themery will write the configuration there.

#### Using .vim config?

Persistence also works fine if you don't have the configuration in a Lua file. You can do this instead and it will still work.

```vim
lua << EOF
-- Themery block
-- end themery block
EOF
```

## Usage

Open with `:Themery` and navigate and move between the results with `j` and `k`.

Press `<cr>` for apply theme and save. `q` or `<Esc>` for exit.

## License

GPL

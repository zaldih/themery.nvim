package.loaded['dev'] = nil
package.loaded['themery'] = nil
package.loaded['themery.module'] = nil

vim.api.nvim_set_keymap('n', ',r', '<cmd>luafile dev/init.lua<cr><cmd>lua require("themery").pop()<cr>', {})


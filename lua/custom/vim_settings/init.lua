-- This file sets all vim-related settings
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)

local settings = require 'custom.vim_settings.settings'
local keymaps = require 'custom.vim_settings.keymaps'
local autocommands = require 'custom.vim_settings.autocommands'

return {
  set_vim_settings = function(leader, breakindent)
    settings.set(leader, breakindent)
  end,

  set_vim_keymaps = function()
    keymaps.set()
  end,

  set_autocommands = function()
    autocommands.set()
  end,
}

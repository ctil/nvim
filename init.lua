--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'lazy-bootstrap'
require 'lazy-plugins'
require 'options'
require 'keymaps'
require 'telescope-setup'
require 'treesitter-setup'
require 'lsp-setup'
require 'cmp-setup'

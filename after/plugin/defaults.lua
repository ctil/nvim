-- Vim options
vim.o.relativenumber = true
vim.o.hlsearch = true
vim.o.cursorline = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.tabstop = 4
vim.cmd 'colorscheme tokyonight'

-- Whickkey prefixes
local wk = require 'which-key'
local mappings = {
	f = { name = 'find' },
	g = { name = 'git' },
	l = { name = 'lsp' },
	o = { name = 'open' },
	t = { name = 'toggle' },
	w = { name = 'workspace' },
}
wk.register(mappings, { prefix = '<leader>' })

-- Volar takeover mode
require('lspconfig').volar.setup {
	filetypes = { 'typescript', 'javascript', 'vue', 'json' },
}

-- Keymaps
vim.keymap.set('i', 'jk', '<esc>')
vim.keymap.set('i', 'kj', '<esc>')
vim.keymap.set('n', '<leader><space>', ':w<cr>', { desc = 'Save' })
vim.keymap.set('n', '<leader>F', vim.cmd.Format, { desc = 'Format current file' })

vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Find existing Buffers' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = 'Find Diagnostics' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = 'Find by Grep' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Find Help' })
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').resume, { desc = 'Find Resume' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = 'Find current Word' })
vim.keymap.set('n', '<leader>fl', require('telescope').extensions.live_grep_args.live_grep_args, { desc = 'Live grep' })

-- To map cmd-p to ctrl-p: https://www.dfurnes.com/notes/binding-command-in-iterm
vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files)

vim.keymap.set('n', ']h', require('gitsigns').next_hunk, { desc = 'Git Next Hunk' })
vim.keymap.set('n', '[h', require('gitsigns').prev_hunk, { desc = 'Git Previous Hunk' })
vim.keymap.set('n', '<leader>gh', require('gitsigns').preview_hunk, { desc = 'Git Preview Hunk' })
vim.keymap.set('n', '<leader>gr', require('gitsigns').reset_hunk, { desc = 'Git Reset Hunk' })
vim.keymap.set('n', '<leader>gb', require('gitsigns').blame_line, { desc = 'Git Blame' })
vim.keymap.set('n', '<leader>gg', ':0Git ', { desc = 'Open Git Command' })
vim.keymap.set('n', '<leader>gs', ':0Git<CR>', { desc = 'Open Git Status' })

vim.keymap.set('n', 'gh', vim.lsp.buf.signature_help, { desc = 'Signature Documentation' })

vim.keymap.set('n', '<leader>tt', ':ToggleTerm<cr>', { desc = 'Toggle Terminal' })
vim.keymap.set('n', '<leader>tl', ':set relativenumber!<cr>', { desc = 'Toggle relative line numbers' })
-- vim.keymap.set('n', '<leader>tf', ':Neotree toggle<CR>', { desc = 'Toggle File Browser' })

vim.keymap.set('n', '<leader>on', ':Ex ~/notes<CR>', { desc = 'Open Notes' })
vim.keymap.set('n', '<leader>oc', ':Ex ~/.config/nvim<CR>', { desc = 'Open vim Config' })
vim.keymap.set('n', '<leader>ob', vim.cmd.Ex, { desc = 'Open Browser' })

vim.keymap.set('n', '<leader>x', vim.cmd.bd, { desc = 'Delete Buffer' })
vim.keymap.set('n', '<leader>p', vim.cmd.BufferLinePick, { desc = 'Pick buffer' })

vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'Lsp Rename' })
vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'Lsp Code Action' })
vim.keymap.set('n', '<leader>lf', vim.cmd.Format, { desc = 'Lsp Format' })
vim.keymap.set('n', '<leader>ls', require('telescope.builtin').lsp_document_symbols, { desc = 'Lsp Document Symbols' })

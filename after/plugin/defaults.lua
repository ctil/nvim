-- Vim options
vim.o.relativenumber = true
vim.o.hlsearch = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.tabstop = 4
vim.g.material_style = 'palenight'
vim.cmd('colorscheme material')

-- Whickkey prefixes
local wk = require("which-key")
local mappings = {
	f = { name = "find" },
	g = { name = "git" },
	l = { name = "lsp" },
	t = { name = "toggle" },
	w = { name = "workspace" }
}
wk.register(mappings, { prefix = "<leader>" })

-- Keymaps
vim.keymap.set('i', 'jk', '<esc>')
vim.keymap.set('i', 'kj', '<esc>')
vim.keymap.set('n', '<leader><space>', ':w<cr>', { desc = 'Save' })
vim.keymap.set('n', '<leader>F', vim.cmd.Format, { desc = 'Format current file' })

vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = '[F]ind existing [B]uffers' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[F]ind [D]iagnostics' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').resume, { desc = '[F]ind [R]esume' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[F]ind current [W]ord' })

-- To map cmd-p to ctrl-p: https://www.dfurnes.com/notes/binding-command-in-iterm
vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files)

vim.keymap.set('n', '<leader>gh', require('gitsigns').preview_hunk, { desc = '[G]it Preview [H]unk' })
vim.keymap.set('n', '<leader>gb', require('gitsigns').blame_line, { desc = '[G]it [B]lame' })
vim.keymap.set('n', '<leader>gg', ':G ', { desc = 'Open Git Command' })
vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'Open Git Status' })

vim.keymap.set('n', 'gh', vim.lsp.buf.signature_help, { desc = 'Signature Documentation' })

-- vim.keymap.set('n', '<leader>tt', require('FTerm').open, { desc = '[T]oggle [T]erminal' })
vim.keymap.set('n', '<leader>tl', ':set relativenumber!<cr>', { desc = '[T]oggle relative line numbers' })
vim.keymap.set('n', '<leader>tf', ':Neotree toggle<CR>', { desc = '[T]oggle [F]ile Browser' })

vim.keymap.set('n', '<leader>x', vim.cmd.bd, { desc = 'Delete Buffer' })
vim.keymap.set('n', '<leader>p', vim.cmd.BufferLinePick, { desc = '[P]ick buffer' })

vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { desc = '[L]sp [R]ename' })
vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = '[L]sp Code [A]ction' })
vim.keymap.set('n', '<leader>ls', require('telescope.builtin').lsp_document_symbols, { desc = '[L]sp Document [S]ymbols' })

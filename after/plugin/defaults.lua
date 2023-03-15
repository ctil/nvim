-- Vim options
vim.o.relativenumber = true
vim.o.hlsearch = true
vim.g.material_style = 'palenight'
vim.cmd('colorscheme material')


-- Keymaps
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = '[F]ind current [W]ord' })
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = '[F]ind [D]iagnostics' })

-- To map cmd-p to ctrl-p: https://www.dfurnes.com/notes/binding-command-in-iterm
vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files)

vim.keymap.set('n', '<leader>gh', require('gitsigns').preview_hunk, { desc = '[G]it Preview [H]unk' })
vim.keymap.set('n', '<leader>gb', require('gitsigns').blame_line, { desc = '[G]it [B]lame' })
vim.keymap.set('n', '<leader>gg', ':G ', { desc = 'Open Git Command' })
vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'Open Git Status' })
vim.keymap.set('n', '<leader>t', require('FTerm').open, { desc = 'Open Floating Terminal' })
vim.keymap.set('n', '<leader>cf', vim.cmd.Format, { desc = 'Format current file' })
vim.keymap.set('n', '<leader>ob', vim.cmd.Ex, { desc = '[O]pen [B]rowser' })
vim.keymap.set('n', 'gh', vim.lsp.buf.signature_help, { desc = 'Signature Documentation' })

-- Vim options
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.relativenumber = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.splitright = false
vim.o.tabstop = 4
vim.cmd 'colorscheme onedark'

-- Whickkey prefixes
local wk = require 'which-key'
local mappings = {
    b = { name = 'buffer' },
    c = { name = 'copy' },
    f = { name = 'find' },
    g = { name = 'git' },
    h = { name = 'harpoon' },
    l = { name = 'lsp' },
    o = { name = 'open' },
    s = { name = 'session' },
    t = { name = 'toggle' },
    w = { name = 'workspace' },
}
wk.register(mappings, { prefix = '<leader>' })

-- Make nvim-cmp and autopairs play well together
local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
local cmp = require 'cmp'
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

-- Volar takeover mode
require('lspconfig').volar.setup {
    filetypes = { 'typescript', 'javascript', 'vue', 'json' },
}

-- Misc keymaps
vim.keymap.set('i', 'jk', '<esc>')
vim.keymap.set('i', 'kj', '<esc>')
vim.keymap.set('n', '<leader>v', vim.cmd.vsplit, { desc = 'Open a vertical split' })
vim.keymap.set('n', '<leader><space>', ':w<cr>', { desc = 'Save' })
vim.keymap.set('n', '<leader>p', '<C-^>', { desc = 'Goto previous buffer' })
vim.keymap.set('n', '<leader>cf', ':let @+ = expand("%")<CR>', { desc = 'Copy filename' })
vim.keymap.set('n', '<leader>ca', 'ggyG', { desc = 'Copy All File Contents' })
vim.keymap.set('n', 'gh', vim.lsp.buf.signature_help, { desc = 'Signature Documentation' })
-- When in visual mode, use this mapping to keep what is in your paste buffer
vim.keymap.set('x', '<leader>p', '"_dP')

vim.keymap.set('n', '<leader>ob', ':Ex<CR>', { desc = 'Open File Browser' })

-- Center screen after CTRL-D/U
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Center search terms
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Keep cursor in same place while using J
vim.keymap.set('n', 'J', 'mzJ`z')

-- Move selected text up and down with J/K in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Move between splits (commented out because it's managed by tmux-navigator)
-- vim.keymap.set('n', '<C-h>', '<C-w>h')
-- vim.keymap.set('n', '<C-l>', '<C-w>l')
-- vim.keymap.set('n', '<C-j>', '<C-w>j')
-- vim.keymap.set('n', '<C-k>', '<C-w>k')

-- Harpoon
vim.keymap.set('n', '<leader>hh', require('harpoon.ui').toggle_quick_menu, { desc = 'Open harpoon menu' })
vim.keymap.set('n', '<leader>ha', require('harpoon.mark').add_file, { desc = 'Add harpoon mark' })
vim.keymap.set('n', '<leader>hj', ':lua require("harpoon.ui").nav_file(1)<CR>', { desc = 'Navigate to harpoon file 1' })
vim.keymap.set('n', '<leader>hk', ':lua require("harpoon.ui").nav_file(2)<CR>', { desc = 'Navigate to harpoon file 2' })
vim.keymap.set('n', '<leader>hl', ':lua require("harpoon.ui").nav_file(3)<CR>', { desc = 'Navigate to harpoon file 3' })
vim.keymap.set('n', '<leader>h;', ':lua require("harpoon.ui").nav_file(4)<CR>', { desc = 'Navigate to harpoon file 4' })
vim.keymap.set('n', '<leader>hn', require('harpoon.ui').nav_next, { desc = 'Navigate to next harpoon file' })
vim.keymap.set('n', '<leader>hp', require('harpoon.ui').nav_prev, { desc = 'Navigate to previous harpoon file' })

-- Search/Find keymaps
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Find existing Buffers' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = 'Find Diagnostics' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').git_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', require('telescope').extensions.live_grep_args.live_grep_args,
{ desc = 'Find by Grep' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Find Help' })
vim.keymap.set('n', '<leader>fj', ':Easypick just<CR>', { desc = 'Find Just Targets' })
vim.keymap.set('n', '<leader>fn', ':Telescope find_files cwd=~/notes<CR>', { desc = 'Find Notes' })
vim.keymap.set('n', '<leader>fq', require('telescope.builtin').quickfix, { desc = 'Find Quickfix List' })
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').resume, { desc = 'Find Resume' })
vim.keymap.set('n', '<leader>fs', require('telescope.builtin').lsp_document_symbols, { desc = 'Find Document Symbols' })
vim.keymap.set('n', '<leader>fv', ':Telescope git_files cwd=~/.config/nvim<CR>', { desc = 'Find Vim Config Files' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = 'Find current Word' })
-- To map cmd-p to ctrl-p: https://www.dfurnes.com/notes/binding-command-in-iterm
vim.keymap.set('n', '<C-p>', require('telescope.builtin').git_files)
vim.keymap.set('n', '<D-p>', require('telescope.builtin').git_files)

-- Unimpaired style keymaps
vim.keymap.set('n', ']h', require('gitsigns').next_hunk, { desc = 'Git Next Hunk' })
vim.keymap.set('n', '[h', require('gitsigns').prev_hunk, { desc = 'Git Previous Hunk' })
vim.keymap.set('n', ']e', ':BaconLoad<CR>:w<CR>:BaconNext<CR>', { desc = 'Next bacon error' })
vim.keymap.set('n', '[e', '::BaconPrevious<CR>', { desc = 'Previous bacon error' })

-- Git keymaps
vim.keymap.set('n', '<leader>gb', require('gitsigns').blame_line, { desc = 'Git Blame' })
vim.keymap.set('n', '<leader>gc', require('telescope.builtin').git_branches, { desc = 'Git Checkout' })
vim.keymap.set('n', '<leader>gd', ':Easypick changed_files<CR>', { desc = 'Diff all files against master' })
vim.keymap.set('n', '<leader>gg', ':0Git ', { desc = 'Open Git Command' })
vim.keymap.set('n', '<leader>gh', require('gitsigns').preview_hunk, { desc = 'Git Preview Hunk' })
vim.keymap.set('n', '<leader>go', vim.cmd.GBrowse, { desc = 'Open in GitHub' })
vim.keymap.set('n', '<leader>gr', require('gitsigns').reset_hunk, { desc = 'Git Reset Hunk' })
vim.keymap.set('n', '<leader>gs', ':0Git<CR>', { desc = 'Open Git Status' })
vim.keymap.set('n', '<leader>gv', ':Gvdiffsplit master<CR>', { desc = 'Open vertical diff' })

-- Toggles
vim.keymap.set('n', '<leader>tt', ':ToggleTerm<cr>', { desc = 'Toggle Terminal' })
vim.keymap.set('n', '<leader>tf', ':Neotree toggle<CR>', { desc = 'Toggle Filetree' })
vim.keymap.set('n', '<leader>tp', vim.cmd.BufferLineTogglePin, { desc = 'Toggle Buffer Pin' })
vim.keymap.set('n', '<leader>tl', ':set relativenumber!<CR>', { desc = 'Toggle relative line numbers' })
vim.keymap.set('n', '<leader>te', ':Lex 30<CR>', { desc = 'Toggle Netrw Explore' })
vim.keymap.set('n', '<leader>ts', ':set hlsearch!<CR>', { desc = 'Toggle Search Highlight' })
vim.keymap.set('n', '<leader>tb', ':BaconList<CR>', { desc = 'Toggle Bacon List' })

vim.keymap.set('n', '<leader>x', vim.cmd.bd, { desc = 'Delete Buffer' })
vim.keymap.set('n', '<leader>q', vim.cmd.q, { desc = 'Quit' })
vim.keymap.set('n', '<leader>bp', vim.cmd.BufferLinePick, { desc = 'Pick buffer' })
vim.keymap.set('n', '<leader>br', vim.cmd.BufferLineCloseRight, { desc = 'Close buffers to the right' })
vim.keymap.set('n', '<leader>bl', vim.cmd.BufferLineCloseLeft, { desc = 'Close buffers to the left' })

vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'Lsp Rename' })
vim.keymap.set('n', '<leader>ls', ':LspRestart<CR>', { desc = 'Lsp Sync/Restart' })
vim.keymap.set('n', '<leader>R', vim.lsp.buf.rename, { desc = 'Rename' })
vim.keymap.set('n', '<leader>F', vim.cmd.Format, { desc = 'Format' })
vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'Lsp Code Action' })
vim.keymap.set('n', '<leader>lf', vim.cmd.Format, { desc = 'Lsp Format' })

-- Session management
vim.keymap.set('n', '<leader>sl', vim.cmd.SearchSession, { desc = 'Search Sessions' })
vim.keymap.set('n', '<leader>sd', ':Autosession delete<CR>', { desc = 'Delete Sessions' })

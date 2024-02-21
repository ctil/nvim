-- Vim options
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.hlsearch = false
vim.o.incsearch = true
vim.o.relativenumber = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.splitright = true
vim.o.tabstop = 4
vim.cmd 'colorscheme catppuccin-frappe'

-- Whickkey prefixes
local wk = require 'which-key'
local mappings = {
  b = { name = 'buffer' },
  c = { name = 'copy' },
  f = { name = 'find' },
  g = { name = 'git' },
  h = { name = 'harpoon' },
  j = { name = 'jump' },
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

local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local builtin = require 'telescope.builtin'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local previewers = require 'telescope.previewers'
local putils = require 'telescope.previewers.utils'
local sorters = require 'telescope.sorters'

function _G.pick_branch()
  builtin.git_branches {
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<CR>', function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        -- Save session
        vim.cmd 'SessionSave'

        -- Checkout the selected branch
        local command = string.format('git checkout %s', selection.value)
        vim.fn.system(command)

        -- Close all buffers
        vim.cmd '%bd!'

        -- Restore session
        vim.cmd 'SessionRestore'
      end)
      return true
    end,
  }
end

local run_just_show = previewers.new_buffer_previewer {
  title = 'Justfile Target',
  get_buffer_by_name = function(_, entry)
    return entry.value
  end,

  define_preview = function(self, entry, _)
    local target = string.gmatch(entry.value, '%S+')()
    putils.job_maker({ 'just', '--show', target }, self.state.bufnr, {
      value = target,
      bufname = self.state.bufname,
    })
  end,
}

function _G.just_picker()
  pickers
    .new({}, {
      prompt_title = 'Justfile Targets',
      finder = finders.new_oneshot_job({ 'just', 'targets' }, {}),
      previewer = run_just_show,
      sorter = sorters.get_generic_fuzzy_sorter(),
      attach_mappings = function(prompt_bufnr, map)
        map('i', '<CR>', function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          local target = string.gmatch(selection.value, '%S+')()
          local command = string.format('!just %s', target)
          vim.cmd(command)
        end)
        return true
      end,
    })
    :find()
end

-- Misc keymaps
vim.keymap.set('i', 'jk', '<esc>')
vim.keymap.set('i', 'kj', '<esc>')
vim.keymap.set('n', '<leader>d', ":lua vim.diagnostic.open_float({ border = 'rounded' })<CR>", { desc = 'Show diagnostic' })
vim.keymap.set('n', '<leader>v', vim.cmd.vsplit, { desc = 'Open a vertical split' })
vim.keymap.set('n', '<leader><space>', ':wall<CR>:SessionSave<CR>', { desc = 'Save' })
vim.keymap.set('n', '<leader>p', '<C-^>', { desc = 'Goto previous buffer' })
vim.keymap.set('n', '<leader>cf', ':let @+ = expand("%")<CR>', { desc = 'Copy filename' })
vim.keymap.set('n', '<leader>ca', 'ggyG', { desc = 'Copy All File Contents' })
vim.keymap.set('n', 'gh', vim.lsp.buf.signature_help, { desc = 'Signature Documentation' })
-- When in visual mode, use this mapping to keep what is in your paste buffer
vim.keymap.set('x', '<leader>p', '"_dP')

vim.keymap.set('n', '<leader>ob', ':Ex<CR>', { desc = 'Open File Browser' })
vim.keymap.set('n', '<leader>og', ':GBrowse master:%<CR>', { desc = 'Open in GitHub' })

-- Center screen after CTRL-D/U
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- Center search terms
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Keep cursor in same place while using J
vim.keymap.set('n', 'J', 'mzJ`z')

-- Move selected text up and down with J/K in visual mode
-- vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
-- vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Move between splits (commented out because it's managed by tmux-navigator)
-- vim.keymap.set('n', '<C-h>', '<C-w>h')
-- vim.keymap.set('n', '<C-l>', '<C-w>l')
-- vim.keymap.set('n', '<C-j>', '<C-w>j')
-- vim.keymap.set('n', '<C-k>', '<C-w>k')

-- Harpoon
vim.keymap.set('n', '<leader>hh', require('harpoon.ui').toggle_quick_menu, { desc = 'Open harpoon menu' })
vim.keymap.set('n', '<Tab>h', require('harpoon.ui').toggle_quick_menu, { desc = 'Open harpoon menu' })
vim.keymap.set('n', '<leader>ha', require('harpoon.mark').add_file, { desc = 'Add harpoon mark' })
vim.keymap.set('n', '<leader>hj', ':lua require("harpoon.ui").nav_file(1)<CR>', { desc = 'Navigate to harpoon file 1' })
vim.keymap.set('n', '<Tab>j', ':lua require("harpoon.ui").nav_file(1)<CR>', { desc = 'Navigate to harpoon file 1' })
vim.keymap.set('n', '<leader>hk', ':lua require("harpoon.ui").nav_file(2)<CR>', { desc = 'Navigate to harpoon file 2' })
vim.keymap.set('n', '<Tab>k', ':lua require("harpoon.ui").nav_file(2)<CR>', { desc = 'Navigate to harpoon file 2' })
vim.keymap.set('n', '<leader>hl', ':lua require("harpoon.ui").nav_file(3)<CR>', { desc = 'Navigate to harpoon file 3' })
vim.keymap.set('n', '<Tab>l', ':lua require("harpoon.ui").nav_file(3)<CR>', { desc = 'Navigate to harpoon file 3' })
vim.keymap.set('n', '<leader>h;', ':lua require("harpoon.ui").nav_file(4)<CR>', { desc = 'Navigate to harpoon file 4' })
vim.keymap.set('n', '<Tab>;', ':lua require("harpoon.ui").nav_file(4)<CR>', { desc = 'Navigate to harpoon file 4' })
vim.keymap.set('n', '<leader>hn', require('harpoon.ui').nav_next, { desc = 'Navigate to next harpoon file' })
vim.keymap.set('n', '<leader>hp', require('harpoon.ui').nav_prev, { desc = 'Navigate to previous harpoon file' })

-- Search/Find keymaps
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Find existing Buffers' })
vim.keymap.set('n', '<leader>fc', require('telescope.builtin').colorscheme, { desc = 'Find colorschemes' })
vim.keymap.set('n', '<leader>fd', require('telescope.builtin').diagnostics, { desc = 'Find Diagnostics' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').git_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fm', require('telescope.builtin').marks, { desc = 'Find marks' })
vim.keymap.set('n', '<leader>fg', require('telescope').extensions.live_grep_args.live_grep_args, { desc = 'Find by Grep' })
vim.keymap.set('n', '<leader>/', require('telescope').extensions.live_grep_args.live_grep_args, { desc = 'Find by Grep' })
vim.keymap.set('n', '<leader>fh', require('telescope.builtin').help_tags, { desc = 'Find Help' })
vim.keymap.set('n', '<leader>fo', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader>fj', just_picker, { desc = 'Find Just Targets' })
vim.keymap.set('n', '<leader>fn', ':Telescope find_files cwd=~/notes<CR>', { desc = 'Find Notes' })
vim.keymap.set('n', '<leader>fq', require('telescope.builtin').quickfix, { desc = 'Find Quickfix List' })
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').resume, { desc = 'Find Resume' })
vim.keymap.set('n', '<leader>fu', require('telescope.builtin').lsp_references, { desc = 'Find Usages/References' })
vim.keymap.set('n', '<leader>fs', require('telescope.builtin').lsp_document_symbols, { desc = 'Find Document Symbols' })
vim.keymap.set('n', '<leader>fv', ':Telescope git_files cwd=~/.config/nvim<CR>', { desc = 'Find Vim Config Files' })
vim.keymap.set('n', '<leader>fw', require('telescope.builtin').grep_string, { desc = 'Find current Word' })
-- To map cmd-p to ctrl-p: https://www.dfurnes.com/notes/binding-command-in-iterm
vim.keymap.set('n', '<C-p>', require('telescope.builtin').git_files)
vim.keymap.set('n', '<D-p>', require('telescope.builtin').git_files)

-- Unimpaired style keymaps
vim.keymap.set('n', ']h', require('gitsigns').next_hunk, { desc = 'Git Next Hunk' })
vim.keymap.set('n', '[h', require('gitsigns').prev_hunk, { desc = 'Git Previous Hunk' })
-- vim.keymap.set('n', ']e', ':BaconLoad<CR>:w<CR>:BaconNext<CR>', { desc = 'Next bacon error' })
-- vim.keymap.set('n', '[e', '::BaconPrevious<CR>', { desc = 'Previous bacon error' })
vim.keymap.set('n', ']t', function()
  require('trouble').next { skip_groups = true, jump = true }
end, { desc = 'Next Trouble Item' })
vim.keymap.set('n', '[t', function()
  require('trouble').previous { skip_groups = true, jump = true }
end, { desc = 'Previous Trouble Item' })

-- Git keymaps
vim.keymap.set('n', '<leader>ga', ':0Git commit -a --amend --no-edit<CR>', { desc = 'Amend current commit' })
vim.keymap.set('n', '<leader>gb', require('gitsigns').blame_line, { desc = 'Git Blame' })
vim.keymap.set('n', '<leader>gc', pick_branch, { desc = 'Git Checkout' })
vim.keymap.set('n', '<leader>gd', ':DiffviewOpen master<CR>', { desc = 'Diff all files against master' })
vim.keymap.set('n', '<leader>gx', vim.cmd.DiffviewClose, { desc = 'Close diff view' })
vim.keymap.set('n', '<leader>gg', ':0Git ', { desc = 'Open Git Command' })
vim.keymap.set('n', '<leader>gh', require('gitsigns').preview_hunk, { desc = 'Git Preview Hunk' })
vim.keymap.set('n', '<leader>gr', require('gitsigns').reset_hunk, { desc = 'Git Reset Hunk' })
vim.keymap.set('n', '<leader>gs', ':0Git<CR>', { desc = 'Open Git Status' })
vim.keymap.set('n', '<leader>gv', ':DiffviewOpen master -- %<CR>', { desc = 'Open vertical diff of current file' })

-- Toggles
vim.keymap.set('n', '<leader>tt', ':Neotree toggle<CR>', { desc = 'Toggle Filetree' })
vim.keymap.set('n', '<leader>n', ':Neotree focus<CR>', { desc = 'Focus Neotree' })
vim.keymap.set('n', '<leader>tp', vim.cmd.BufferLineTogglePin, { desc = 'Toggle Buffer Pin' })
vim.keymap.set('n', '<leader>tl', ':set relativenumber!<CR>', { desc = 'Toggle relative line numbers' })
vim.keymap.set('n', '<leader>te', ':Lex 30<CR>', { desc = 'Toggle Netrw Explore' })
vim.keymap.set('n', '<leader>th', ':set hlsearch!<CR>', { desc = 'Toggle Search Highlight' })
-- vim.keymap.set('n', '<leader>tb', ':BaconList<CR>', { desc = 'Toggle Bacon List' })
vim.keymap.set('n', '<leader>td', ':Trouble workspace_diagnostics<CR>', { desc = 'Toggle diagnostics' })
vim.keymap.set('n', '<leader>tq', ':Trouble quickfix<CR>', { desc = 'Toggle quickfix' })
vim.keymap.set('n', '<leader>tr', ':TroubleToggle<CR>', { desc = 'Toggle trouble' })

vim.keymap.set('n', '<leader>x', ':bp | sp | bn | bd<CR>', { desc = 'Delete Buffer' })
vim.keymap.set('n', '<leader>q', vim.cmd.q, { desc = 'Quit' })
vim.keymap.set('n', '<leader>bp', vim.cmd.BufferLinePick, { desc = 'Pick buffer' })
vim.keymap.set('n', '<leader>br', vim.cmd.BufferLineCloseRight, { desc = 'Close buffers to the right' })
vim.keymap.set('n', '<leader>bl', vim.cmd.BufferLineCloseLeft, { desc = 'Close buffers to the left' })

vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'Lsp Rename' })
vim.keymap.set('n', '<leader>ls', ':LspRestart<CR>', { desc = 'Lsp Sync/Restart' })
vim.keymap.set('n', '<leader>lx', ':LspStop<CR>', { desc = 'Lsp Stop' })
vim.keymap.set('n', '<leader>R', vim.lsp.buf.rename, { desc = 'Rename' })
vim.keymap.set('n', '<leader>F', vim.cmd.Format, { desc = 'Format' })
vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'Lsp Code Action' })
vim.keymap.set('n', '<leader>lf', vim.cmd.Format, { desc = 'Lsp Format' })

-- Jump
vim.keymap.set('n', '<leader>jt', '/<template<CR>zz', { desc = 'Jump to template' })
vim.keymap.set('n', '<leader>js', '/<script<CR>zz', { desc = 'Jump to script' })
vim.keymap.set('n', '<leader>jc', '/<style<CR>zz', { desc = 'Jump to css/style' })

-- Session management
vim.keymap.set('n', '<leader>sd', '<cmd>!rm ~/.local/share/nvim/sessions/* && rm ~/.local/share/nvim/harpoon.json<CR>', { desc = 'Delete All Sessions' })
vim.keymap.set('n', '<leader>sr', ':%bd!<CR>:SessionRestore<CR>', { desc = 'Restore Session' })
vim.keymap.set('n', '<leader>ss', vim.cmd.SessionSave, { desc = 'Save Session' })

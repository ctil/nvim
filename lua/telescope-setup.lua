-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local lga_actions = require 'telescope-live-grep-args.actions'
local trouble = require 'trouble.providers.telescope'
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        -- ['<C-u>'] = false,
        -- ['<C-d>'] = false,
        -- Use C-j and C-k to navigate between selections
        -- ['<C-j>'] = require('telescope.actions').move_selection_next,
        -- ['<C-k>'] = require('telescope.actions').move_selection_previous,
        ['<C-q>'] = require('telescope.actions').smart_send_to_qflist,
        ['<C-r>'] = trouble.open_with_trouble,
      },
    },
  },
  extensions = {
    live_grep_args = {
      auto_quoting = true, -- enable/disable auto-quoting
      mappings = {
        i = {
          ['<C-l>'] = lga_actions.quote_prompt(),
          ['<C-i>'] = lga_actions.quote_prompt { postfix = ' -i ' },
          ['<C-t>'] = lga_actions.quote_prompt { postfix = ' -t ' },
          ['<C-g>'] = lga_actions.quote_prompt { postfix = ' services/graph' },
          ['<C-r>'] = trouble.open_with_trouble,
        },
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'live_grep_args')
-- pcall(require('telescope').load_extension, 'session-lens')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

vim.keymap.set('n', '<leader>?', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end
vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })

-- [[ Custom Pickers ]]
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

-- Keymaps for custom pickers
vim.keymap.set('n', '<leader>fj', just_picker, { desc = 'Find Just Targets' })
vim.keymap.set('n', '<leader>gc', pick_branch, { desc = 'Git Checkout' })

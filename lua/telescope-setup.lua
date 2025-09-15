-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
local lga_actions = require 'telescope-live-grep-args.actions'
require('telescope').setup {
  event = 'VeryLazy',
  defaults = {
    mappings = {
      i = {
        -- ['<C-u>'] = false,
        -- ['<C-d>'] = false,
        -- ['<C-q>'] = require('telescope.actions').smart_send_to_qflist,
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
        },
      },
    },
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
  },
}

-- Filter files that are in the quickfix list
local search_qflist = function(mode)
  local qflist = vim.fn.getqflist()
  local filetable = {}
  local hashlist = {}

  for _, value in pairs(qflist) do
    local name = vim.api.nvim_buf_get_name(value.bufnr)

    if not hashlist[name] then
      hashlist[name] = true
      table.insert(filetable, name)
    end
  end

  local args = { search_dirs = filetable }
  local builtin = require 'telescope.builtin'

  if mode == 'live_grep' then
    builtin.live_grep(args)
  elseif mode == 'inverse_live_grep' then
    args.additional_args = { '--files-without-match' }
    builtin.live_grep(args)
  elseif mode == 'find_files' then
    builtin.find_files(args)
  else
    print 'Invalid mode specified'
  end
end
_G.Search_qflist = search_qflist

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'live_grep_args')
pcall(require('telescope').load_extension, 'ui-select')

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

local function pick_branch()
  builtin.git_branches {
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<CR>', function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        -- Save session
        vim.cmd 'AutoSession save'

        -- Checkout the selected branch
        local command = string.format('git checkout %s', selection.value)
        vim.fn.system(command)

        -- Close all buffers
        vim.cmd '%bd!'

        -- Restore session
        vim.cmd 'AutoSession restore'
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

local function just_picker()
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

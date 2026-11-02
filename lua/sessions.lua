-- [[ Branch-aware sessions ]]
-- Minimal replacement for auto-session built on :mksession. Sessions are keyed
-- by `<cwd>|<git branch>` and stored with the same percent-encoded file names
-- auto-session used, so existing session files keep working.
local M = {}

local session_dir = vim.fn.stdpath 'data' .. '/sessions/'

local function git_branch(cwd)
  -- Call git directly rather than through 'shell': fish startup output (e.g.
  -- "Using Node v24...") otherwise ends up in the branch name.
  local ok, result = pcall(function()
    return vim.system({ 'git', 'rev-parse', '--abbrev-ref', 'HEAD' }, { cwd = cwd, text = true }):wait()
  end)
  if not ok or result.code ~= 0 then
    return nil
  end
  return vim.trim(result.stdout)
end

local function encode(str)
  return (str:gsub('([/\\:*?"\'<>+ |%.%%])', function(c)
    return string.format('%%%02X', string.byte(c))
  end))
end

function M.path()
  local cwd = vim.fn.getcwd(-1, -1)
  local branch = git_branch(cwd)
  local name = branch and (cwd .. '|' .. branch) or cwd
  return session_dir .. encode(name) .. '.vim'
end

function M.save()
  vim.fn.mkdir(session_dir, 'p')
  local path = M.path()
  vim.cmd('mksession! ' .. vim.fn.fnameescape(path))
  vim.notify('Session saved: ' .. vim.fn.fnamemodify(path, ':t'))
end

---@return boolean restored
function M.restore()
  local path = M.path()
  if vim.fn.filereadable(path) == 0 then
    return false
  end
  vim.cmd('silent source ' .. vim.fn.fnameescape(path))
  return true
end

function M.delete()
  local path = M.path()
  if vim.fn.delete(path) == 0 then
    vim.notify('Session deleted: ' .. vim.fn.fnamemodify(path, ':t'))
  end
end

vim.api.nvim_create_user_command('SessionSave', M.save, { desc = 'Save session for cwd + branch' })
vim.api.nvim_create_user_command('SessionRestore', M.restore, { desc = 'Restore session for cwd + branch' })
vim.api.nvim_create_user_command('SessionDelete', M.delete, { desc = 'Delete session for cwd + branch' })

-- Auto-restore when started with no file arguments (and not reading stdin)
local group = vim.api.nvim_create_augroup('branch_sessions', {})
vim.api.nvim_create_autocmd('StdinReadPre', {
  group = group,
  callback = function()
    vim.g.reading_stdin = true
  end,
})
vim.api.nvim_create_autocmd('VimEnter', {
  group = group,
  nested = true, -- so FileType/LSP/treesitter autocmds fire for restored buffers
  callback = function()
    if vim.fn.argc() == 0 and not vim.g.reading_stdin then
      M.restore()
    end
  end,
})

return M

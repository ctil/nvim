local M = {}

local function git(dir, ...)
  local out = vim.fn.system { 'git', '-C', dir, ... }
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return vim.trim(out)
end

-- github.com web base URL for a git remote URL, or nil if it isn't recognized
local function web_base(remote)
  local host, path = remote:match '^git@([^:]+):(.+)$'
  if not host then
    host, path = remote:match '^ssh://git@([^/]+)/(.+)$'
  end
  if not host then
    host, path = remote:match '^https?://[^/@]+@([^/]+)/(.+)$'
  end
  if not host then
    host, path = remote:match '^https?://([^/]+)/(.+)$'
  end
  if not host then
    return nil
  end
  return 'https://' .. host .. '/' .. path:gsub('%.git$', '')
end

local function default_branch(dir)
  local head = git(dir, 'symbolic-ref', '--short', 'refs/remotes/origin/HEAD')
  if head and head ~= '' then
    return head:gsub('^origin/', '')
  end
  if git(dir, 'rev-parse', '--verify', '--quiet', 'origin/main') then
    return 'main'
  end
  return 'master'
end

-- Open the current file on the repo's default branch, anchored at the current line
function M.open_file_in_default_branch()
  local file = vim.fn.expand '%:p'
  if file == '' then
    vim.notify('Current buffer has no file', vim.log.levels.WARN)
    return
  end
  local dir = vim.fn.expand '%:p:h'
  local root = git(dir, 'rev-parse', '--show-toplevel')
  if not root then
    vim.notify('Not inside a git repository', vim.log.levels.WARN)
    return
  end
  local remote = git(dir, 'remote', 'get-url', 'origin')
  if not remote then
    local remotes = git(dir, 'remote')
    remote = remotes and remotes ~= '' and git(dir, 'remote', 'get-url', vim.split(remotes, '\n')[1])
  end
  local base = remote and web_base(remote)
  if not base then
    vim.notify('Could not determine remote URL', vim.log.levels.WARN)
    return
  end
  local relpath = file:sub(#root + 2):gsub(' ', '%%20')
  local url = string.format('%s/blob/%s/%s#L%d', base, default_branch(dir), relpath, vim.fn.line '.')
  vim.ui.open(url)
end

return M

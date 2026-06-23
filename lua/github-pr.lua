local M = {}

-- Open the GitHub PR associated with the current line (via git blame + gh)
function M.open_pr_for_line()
  local file = vim.fn.expand '%:p'
  if file == '' then
    vim.notify('Current buffer has no file', vim.log.levels.WARN)
    return
  end
  local line = vim.fn.line '.'
  local blame = vim.fn.systemlist { 'git', 'blame', '-L', line .. ',' .. line, '--porcelain', '--', file }
  if vim.v.shell_error ~= 0 then
    vim.notify('git blame failed: ' .. table.concat(blame, '\n'), vim.log.levels.ERROR)
    return
  end
  local sha = blame[1] and blame[1]:match '^(%x+)'
  if not sha then
    vim.notify('Could not determine commit for current line', vim.log.levels.WARN)
    return
  end
  if sha:match '^0+$' then
    vim.notify('Line is not yet committed', vim.log.levels.INFO)
    return
  end
  local url = vim.trim(vim.fn.system { 'gh', 'api', 'repos/{owner}/{repo}/commits/' .. sha .. '/pulls', '--jq', '.[0].html_url' })
  if vim.v.shell_error ~= 0 then
    vim.notify('gh api failed: ' .. url, vim.log.levels.ERROR)
    return
  end
  if url == '' or url == 'null' then
    vim.notify('No PR found for commit ' .. sha:sub(1, 8), vim.log.levels.INFO)
    return
  end
  vim.ui.open(url)
end

return M

return {
  "rmagatti/auto-session",
  version = "*",
  config = function ()
    require('auto-session').setup {
      auto_session_use_git_branch = true
    }
  end,
}

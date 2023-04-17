return {
  'ThePrimeagen/harpoon',
  version = '*',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = { mark_branch = true },
  config = function()
    require('harpoon').setup {
      mark_branch = true,
      global_settings = {
        mark_branch = true,
      }
    }
  end,
}

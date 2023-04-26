return {
  'akinsho/bufferline.nvim',
  name = 'bufferline',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      diagnostics = 'nvim_lsp',
      -- separator_style = 'slant',
    },
  },
}

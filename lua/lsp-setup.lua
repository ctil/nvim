-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
  -- nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format {
      filter = function(client)
        -- Skip vue_ls's formatting
        return client.name ~= 'vue_ls'
      end,
    }
  end, { desc = 'Format current buffer with LSP' })
end

-- document existing key chains
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require('which-key').add {
  { '<leader>', group = 'VISUAL <leader>', mode = 'v' },
  { '<leader>h', desc = 'Git [H]unk', mode = 'v' },
}

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

local vue_language_server_path = vim.fn.expand '$MASON/packages/vue-language-server/node_modules/@vue/language-server'
local typescript_sdk_path = vim.fn.getcwd() .. '/portals/management/node_modules/typescript/lib'

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- gopls = {},
  -- pyright = {},
  eslint = {},
  jsonls = {},
  emmet_language_server = {
    filetypes = { 'vue' },
  },
  vue_ls = {
    init_options = {
      vue = {
        hybridMode = false,
      },
    },
  },
  rust_analyzer = {
    ['rust-analyzer'] = {
      checkOnSave = {
        command = 'clippy',
        enable = true,
        extraArgs = { '--target-dir', './rust-analyzer-target' },
      },
    },
  },
  ts_ls = {
    init_options = {
      plugins = {
        {
          name = '@vue/typescript-plugin',
          location = vue_language_server_path,
          languages = { 'vue', 'typescript' },
        },
      },
      typescript = { tsdk = typescript_sdk_path },
    },
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
  },
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      -- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require('mason-lspconfig').setup {
  ensure_installed = vim.tbl_keys(servers),
  automatic_installation = true,
}

-- Set up individual LSP servers
local lspconfig = require 'lspconfig'
for server_name, _ in pairs(servers) do
  lspconfig[server_name].setup {
    capabilities = capabilities,
    on_attach = on_attach,
    settings = servers[server_name],
    filetypes = (servers[server_name] or {}).filetypes,
    init_options = (servers[server_name] or {}).init_options,
  }
end

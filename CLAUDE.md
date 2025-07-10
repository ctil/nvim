Personal Neovim config using Lazy.nvim plugin manager.

## Architecture

**Key Files:**
- `init.lua` - Entry point, sets leader key, requires modules
- `lua/plugins.lua` - All plugin definitions
- `lua/options.lua` - Vim settings
- `lua/keymaps.lua` - Key bindings and Which-key groups
- `lua/lsp-setup.lua` - LSP + Mason configuration
- `lua/*-setup.lua` - Individual plugin configurations

## Development Commands

**Plugin Management:**
```bash
:Lazy          # Open plugin manager
:Mason         # Manage LSP servers
:LspRestart    # Restart LSP
```

## LSP Configuration

**Active Language Servers:**
- TypeScript/JS: `ts_ls` (with Vue plugin)
- Vue: `vue_ls`
- Rust: `rust_analyzer`
- Lua: `lua_ls`
- JSON: `jsonls`
- ESLint: `eslint`

**Project Paths:**
- Vue server: `$MASON/packages/vue-language-server/node_modules/@vue/language-server`

## Key Features

- Format-on-save via conform.nvim
- Git integration (gitsigns, fugitive, diffview)
- Harpoon for file marks (branch-specific)
- Auto-session with git branch support
- Codeium AI completion
- Custom Vue snippets in `snippets/vue.json`

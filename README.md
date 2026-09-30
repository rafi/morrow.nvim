# Morrow for Neovim

Features:

- Vim and terminal highlights
- Neovim LSP and diagnostics
- Semantic highlights
- Many popular plugins support.

Based on [w0ng/vim-hybrid] that is based on a combined palette of
[Tomorrow-Night], and a reduced contrast palette from [Codecademy]'s online
editor.

## Updates

- 2023-12-20: Refactor to pure Lua, only Neovim support.
- 2023-12-20: Renamed to `morrow`.
- 2023-06-20: Add LspInlayHint and CmpGhostText. Change darkpurple color and
  define diff highlights.
- 2023-05-09: Add missing vim and terminal highlights, neovim lsp and diagnostics,
  semantic highlights, and many popular plugins support.
- 2023-05-06: Add Terminal highlights.

## Requirements

- Neovim

## Installation

1. Use your favorite package-manager, for example:

   <details>
   <summary>With <a href="https://github.com/folke/lazy.nvim">lazy.nvim</a></summary>

   ```lua
   { 'rafi/morrow.nvim', version = false, lazy = false, opts = {} },
   ```

   </details>

2. Add to `~/.config/nvim/init.lua` or `~/.vimrc` or your own configurations:

   ```vim
   colorscheme morrow
   ```

[w0ng/vim-hybrid]: https://github.com/w0ng/vim-hybrid
[Tomorrow-Night]: https://github.com/chriskempson/vim-tomorrow-theme
[Codecademy]: https://www.codecademy.com

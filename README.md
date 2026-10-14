# morrow.nvim

Tomorrow-family colorschemes for Neovim, built like
[tokyonight.nvim](https://github.com/folke/tokyonight.nvim): three
themes, gray palettes to restyle parts of the UI, and a cache of the
final highlight groups.

## Themes

| Theme | Based on |
|---|---|
| `night` (default) | [Tomorrow Night for JetBrains](https://github.com/MenWhoRust/TomorrowNightTheme): Chris Kempson's mapping (purple keywords, blue functions, yellow types, red variables and fields, aqua operators), italic comments and keywords, flat chrome with a raised status line |
| `hybrid` | [w0ng/vim-hybrid](https://github.com/w0ng/vim-hybrid) dark: blue keywords, yellow functions, orange types, hybrid's popup selection and dark gutter |
| `rafi` | neohybrid: hybrid's code colors with purple identifiers, an olive status line and dark floats |

```vim
colorscheme morrow        " the configured theme
colorscheme morrow-hybrid " a theme by name
```

From Lua, `require('morrow').load()` applies the configured theme and
`require('morrow').load({ theme = 'hybrid' })` a theme by name; options
given to `load()` apply to that load only.

## Setup

`setup()` is optional; call it before the colorscheme loads.

```lua
require('morrow').setup({
	theme = 'night', -- 'night', 'hybrid' or 'rafi'
	transparent = false, -- no background on Normal or elements painted with it
	terminal_colors = true, -- set g:terminal_color_0 .. 15
	styles = {
		-- syntax attributes, merged over the theme's
		comments = {}, keywords = {}, functions = {}, variables = {},
		-- elements, see below
	},
	plugins = {
		all = true, -- every integration (default when no plugin manager is found)
		auto = true, -- integrations for plugins lazy.nvim or vim.pack reports installed
		-- snacks = false, -- turn one off, by group or plugin name
	},
	cache = true, -- cache final groups in stdpath('cache')/morrow-<theme>.json
	on_colors = function(c) end,
	on_highlights = function(hl, c) end,
})
```

`transparent` clears the editor background and every element painted
with it, such as night's floats, gutter and tab labels. Elements with
their own color (night's status line, floats in hybrid and rafi) keep
it.

## Styling elements with palettes

A palette is a gray ramp (`olive`, `neutral`, `slate`, `steel`). Name one
under `styles` to restyle a single element; the rest of the theme stays.

```lua
styles = {
	statusline = 'olive',
	float = 'steel',
	picker = 'steel',
	sidebar = 'transparent',
	code = { bg = '#262a2e' },
	border = 'hidden',
}
```

| Element | What it colors |
|---|---|
| `statusline` | StatusLine, the lualine theme, mini.statusline, navic |
| `winbar` | WinBar (follows `statusline` when unset) |
| `tabline` | TabLine and tab plugins (follows `statusline` when unset) |
| `float` | floating windows, which-key, noice, cmp and blink docs |
| `pmenu` | the popup menu, blink.cmp and nvim-cmp menus |
| `picker` | snacks picker and explorer, telescope (follows `float` when unset) |
| `sidebar` | neo-tree, trouble, dap-ui, and `NormalSB` for other plugins' `winhl` |
| `code` | markdown code blocks |
| `separator` | window separators |
| `inactive` | unfocused windows (`'normal'` means no dimming) |
| `cmdline` | the message area and ui2's cmdline and pager |
| `gutter` | line numbers, sign and fold columns |
| `cursorline` | the cursor line, color column and folds |

Each element takes:

- a palette name: the element's colors from that gray ramp
- `'normal'`: the editor background
- `'transparent'`: no background
- a table of colors, merged over the theme's

`border` takes a palette name, `'hidden'` (the border takes its window's
background) or a `'#rrggbb'` color, and applies to floats, the popup
menu, pickers and the cmdline.

## Colors in your code

```lua
local c = require('morrow.themes').setup() -- or setup({ theme = 'hybrid' })
print(c.syntax.keyword, c.statusline.bg)
```

`on_colors` runs after the syntax colors are built, so change
`c.syntax.keyword` rather than `c.blue` to recolor keywords. Roles are
derived before `on_colors` too, so changing `c.base` there doesn't
recompute derived colors such as diff backgrounds; set those roles
(`c.diff.add`, ...) directly.

## Lualine

```lua
require('lualine').setup({ options = { theme = 'morrow' } }) -- or 'morrow-hybrid'
```

`morrow` follows the active morrow colorscheme, else the configured
theme.

## Integrations

aerial, alpha, barbecue, blink.cmp, bqf, bufferline, nvim-cmp, copilot,
nvim-dap, nvim-dap-ui, gitsigns, glance, grug-far, headlines,
illuminate, incline, indent-blankline, lazy, leap, lualine, marks, mini
(cursorword, diff, hipatterns, icons, indentscope, jump2d, map,
statusline, trailspace), navic, neo-tree, noice, outline,
rainbow-delimiters, render-markdown, snacks, tabstrip, telescope,
treesitter-context, trouble, which-key.

Under `plugins`, turn one on or off by its group name: `aerial`,
`alpha`, `barbecue`, `blink`, `bqf`, `bufferline`, `cmp`, `copilot`,
`dap`, `dap-ui`, `gitsigns`, `glance`, `grug-far`, `headlines`,
`illuminate`, `incline`, `indent-blankline`, `lazy`, `leap`, `lualine`,
`marks`, `mini_cursorword`, `mini_diff`, `mini_hipatterns`,
`mini_icons`, `mini_indentscope`, `mini_jump2d`, `mini_map`,
`mini_statusline`, `mini_trailspace`, `navic`, `neo-tree`, `noice`,
`outline`, `rainbow`, `render-markdown`, `snacks`, `tabstrip`,
`telescope`, `treesitter-context`, `trouble`, `which-key`. A plugin's
name as lazy.nvim and vim.pack report it works too (`blink.cmp`,
`rainbow-delimiters.nvim`, `mini.icons`). Older option names such as
`blink_cmp`, `rainbow_delimiters` or `mini` are not recognized.

```lua
plugins = { all = false, auto = true, snacks = false, ['mini.icons'] = true }
```

## Development

```bash
nvim --headless --clean -u NONE -l tests/run.lua
```

The cache rebuilds when the plugin version, its Lua files or the colors
change. Clear it with `require('morrow.util').cache.clear()`.

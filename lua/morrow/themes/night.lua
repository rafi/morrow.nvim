-- Night: Tomorrow Night after MenWhoRust's JetBrains theme
-- (https://github.com/MenWhoRust/TomorrowNightTheme): base16 grays, Chris
-- Kempson's accents and mapping, and the IDE's flat chrome, where every
-- panel sits on the editor background and borders draw the edges. Where
-- the JetBrains scheme defines nothing, base16-vim decides. Four of its
-- off-palette colors are replaced (inlay hints, folded text, the current
-- search, URLs: aqua instead of the too-bright #89ddf7), the rest are
-- kept. Deviations: operators take Kempson's aqua from his TextMate and
-- Vim schemes, where JetBrains leaves them plain; the tab line is a deeper
-- strip than the editor (crust) with the active tab on a lighter base02.

---@type morrow.Theme
local M = {
	-- stylua: ignore start
	crust    = '#101113', -- below base16's grays: the neutral palette
	mantle   = '#18191a',
	base     = '#1d1f21', -- base00
	surface0 = '#282a2e', -- base01
	surface1 = '#373b41', -- base02
	surface2 = '#4f5256', -- interpolated between base02 and base03
	overlay0 = '#666a6c',
	overlay1 = '#7e8181',
	overlay2 = '#969896', -- base03
	subtext0 = '#a5a8a5', -- interpolated between base03 and base04
	subtext1 = '#b4b7b4', -- base04
	text     = '#c5c8c6', -- base05

	red     = '#cc6666',
	orange  = '#de935f',
	yellow  = '#f0c674',
	green   = '#b5bd68',
	cyan    = '#8abeb7',
	blue    = '#81a2be',
	magenta = '#b294bb',
	brown   = '#a3685a',

	-- JetBrains editor scheme extras
	todo  = '#ffeb95',
	label = '#c3d3de',
	-- stylua: ignore end
}

-- Kempson's mapping as the JetBrains scheme sets it: keywords purple,
-- functions blue, types yellow, constants, numbers and parameters orange,
-- variables, fields and keys red, operators aqua (Kempson's TextMate),
-- punctuation plain.
---@param c morrow.Theme
---@return morrow.Syntax
function M.syntax(c)
	-- stylua: ignore
	return {
		comment          = c.overlay2,
		keyword          = c.magenta,
		keyword_return   = c.magenta,
		label            = c.label,
		func             = c.blue,
		type             = c.yellow,
		type_builtin     = c.yellow,
		structure        = c.yellow,
		string           = c.green,
		number           = c.orange,
		const            = c.orange,
		const_builtin    = c.orange,
		variable         = c.red,
		variable_builtin = c.red,
		builtin          = c.blue,
		module           = c.yellow,
		member           = c.red,
		property         = c.red,
		parameter        = c.orange,
		constructor      = c.yellow,
		identifier       = c.red,
		operator         = c.cyan,
		punct            = c.text,
		preproc          = c.magenta,
		special          = c.cyan,
		escape           = c.text,
		regex            = c.cyan,
		tag              = c.red,
		tag_attr         = c.yellow,
		tag_delim        = c.text,
		todo             = c.todo,
		deprecated       = c.brown,
		heading          = { c.green, c.blue, c.blue, c.blue, c.blue, c.blue },
		raw              = c.magenta,
		url              = c.cyan, -- softer than JetBrains' #89ddf7 hyperlinks
		quote            = c.blue,
		list             = c.red,
		strong           = c.red,
	}
end

-- Italic comments and keywords, and flat chrome on the editor background
-- with base02 borders. Deviations: the status line and cursor line use
-- base01, as base16-vim does, since the JetBrains status line vanished
-- into the editor and its teal cursor line #1b2529 read as a stray tint.
-- stylua: ignore
M.styles = {
	comments   = { italic = true },
	keywords   = { italic = true },
	statusline = { bg = '#282a2e', fg = '#c5c8c6', fg_nc = '#969896' },
	tabline    = {}, -- morrow's rule; a table stops the statusline style leaking in
	float      = { bg = '#1d1f21', border = '#373b41' },
	pmenu      = { bg = '#1d1f21', sel = '#282a2e', border = '#373b41' },
	separator  = { fg = '#373b41' },
	gutter     = { bg = '#1d1f21', fg = '#475f63' },
	cursorline = { bg = '#282a2e' },
}

M.search = { bg = '#32424a', fg = '#c5c8c6' }
M.incsearch = { bg = '#f0c674', fg = '#1d1f21' } -- replaces #f8e71c
-- Bold with a gold underline; 'NONE' keeps the bracket's own colors.
M.match_paren = { fg = 'NONE', bg = 'NONE', sp = '#b39613' }
M.diff = { add = '#264b33', change = '#12404b', delete = '#41454b' }
M.git = { sign = { add = '#b5bd68', change = '#f0c674', delete = '#cc6666' } }
M.diag = { info = '#b5bd68' }
M.indent = { fg = '#37474f', scope = '#80cbc4' }
M.inlay = '#666a6c' -- overlay0, replaces magenta on #777777
M.folded = { fg = '#969896' } -- overlay2, replaces #f3f349

return M

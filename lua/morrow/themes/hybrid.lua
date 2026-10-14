-- Hybrid: w0ng/vim-hybrid's dark scheme (https://github.com/w0ng/vim-hybrid)
-- as Neovim renders it. Upstream only defines Vim groups; where Neovim's
-- built-in colors leak through instead (plain variables, members,
-- parameters and punctuation, floats, the current search), hybrid's own
-- foreground, popup color and Search are used.

---@type morrow.Theme
local M = {
	-- stylua: ignore start
	crust    = '#101113', -- below hybrid's grays: the neutral palette
	mantle   = '#18191a',
	base     = '#1d1f21', -- background
	surface0 = '#282a2e', -- line
	surface1 = '#373b41', -- selection
	surface2 = '#4a4f56', -- interpolated between selection and comment
	overlay0 = '#5d646b',
	overlay1 = '#707880', -- comment
	overlay2 = '#858c92', -- interpolated between comment and foreground
	subtext0 = '#9aa0a3',
	subtext1 = '#b0b4b4',
	text     = '#c5c8c6', -- foreground

	red     = '#cc6666',
	orange  = '#de935f',
	yellow  = '#f0c674',
	green   = '#b5bd68',
	cyan    = '#8abeb7', -- aqua
	blue    = '#81a2be',
	magenta = '#b294bb', -- purple
	brown   = '#a3685a', -- Tomorrow's base0F; hybrid has no brown

	-- hybrid's other palette entries
	window     = '#303030',
	darkcolumn = '#1c1c1c',
	addbg      = '#5f875f',
	addfg      = '#d7ffaf',
	changebg   = '#5f5f87',
	changefg   = '#d7d7ff',
	-- stylua: ignore end
}

-- Vim groups as hybrid defines them: Statement blue, Function yellow,
-- Type orange, Constant red, Identifier purple, PreProc and Operator
-- aqua, Special green; plain variables keep the foreground.
---@param c morrow.Theme
---@return morrow.Syntax
function M.syntax(c)
	-- stylua: ignore
	return {
		comment          = c.overlay1,
		keyword          = c.blue,
		keyword_return   = c.blue,
		label            = c.blue,
		func             = c.yellow,
		type             = c.orange,
		type_builtin     = c.green,
		structure        = c.cyan,
		string           = c.green,
		number           = c.red,
		const            = c.red,
		const_builtin    = c.green,
		variable         = c.text,
		variable_builtin = c.green,
		builtin          = c.green,
		module           = c.cyan,
		member           = c.text,
		property         = c.magenta,
		parameter        = c.text,
		constructor      = c.green,
		identifier       = c.magenta,
		operator         = c.cyan,
		punct            = c.text,
		preproc          = c.cyan,
		special          = c.green,
		escape           = c.green,
		regex            = c.green,
		tag              = c.green,
		tag_attr         = c.green,
		tag_delim        = c.green,
		todo             = c.addfg,
		deprecated       = c.overlay2,
		heading          = { c.yellow, c.yellow, c.yellow, c.yellow, c.yellow, c.yellow },
		raw              = c.green,
		url              = c.blue,
		quote            = c.green,
		list             = c.green,
		strong           = c.text,
	}
end

-- Chrome: the selection color for popups and a dark gutter. Upstream's
-- reversed status and tab lines and selection-colored floats are dropped
-- (too bright, and a selection inside a float was invisible): the status
-- line, winbar, tab line, floats and picker use morrow's element rules.
-- Deviation: the tab line follows the rule too, a deeper strip than the
-- editor with a lighter active tab.
-- stylua: ignore
M.styles = {
	pmenu      = { bg = '#373b41', sel = '#c5c8c6', sel_fg = '#373b41' },
	gutter     = { bg = '#1c1c1c', fg = '#373b41' },
	separator  = { fg = '#303030' },
	cursorline = { bg = '#282a2e' },
}

M.search = { bg = '#f0c674', fg = '#1d1f21' }
M.match_paren = { fg = '#1d1f21', bg = '#5f5f87', bold = false } -- plain, as upstream
M.folded = { fg = '#707880', bg = '#1c1c1c' }
-- stylua: ignore
M.diff = {
	add    = '#5f875f', add_fg    = '#d7ffaf',
	change = '#5f5f87', change_fg = '#d7d7ff',
	delete = '#cc6666', delete_fg = '#1d1f21',
	text   = '#81a2be', text_fg   = '#1d1f21',
}

return M

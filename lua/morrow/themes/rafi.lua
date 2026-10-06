-- Rafi: neohybrid as of revision 5281fc32. Hybrid's code colors with its
-- own builtins, regexes, tags and markup, an olive status line, a dark
-- slate float and a blue popup selection. It extends hybrid: grays it
-- doesn't override, accents and most syntax are inherited, while styles
-- and role tables are replaced whole so no hybrid field survives.

local hybrid = require('morrow.themes.hybrid')
local ret = vim.deepcopy(hybrid)

-- stylua: ignore start
ret.crust    = '#0e1116' -- the slate palette, below 5281fc32's grays
ret.mantle   = '#171b21' -- bg3: floats
ret.surface2 = '#425059' -- bg4: borders
ret.overlay0 = '#666656' -- fg4: inactive status line
ret.overlay2 = '#969896' -- fg3
ret.subtext0 = '#a8a897' -- fg2: status line
ret.subtext1 = '#b4b7b4' -- fg0: brackets

ret.orange_bright = '#e3a377' -- 5281fc32's Shade(orange, 0.15).bright
ret.red_dim       = '#994d4d' -- 5281fc32's Shade(red, -0.25).dim
ret.pink          = '#4d2238'
ret.sel           = '#465f90'
-- stylua: ignore end

-- 5281fc32's mapping over hybrid's: identifiers of every kind purple,
-- builtins green or bright orange, brackets light, tags blue.
---@param c morrow.Theme
---@return morrow.Syntax
ret.syntax = function(c)
	-- stylua: ignore
	return vim.tbl_extend('force', hybrid.syntax(c), {
		variable         = c.magenta,
		member           = c.magenta,
		property         = c.magenta,
		parameter        = c.magenta,
		module           = c.magenta,
		type_builtin     = c.magenta,
		constructor      = c.magenta,
		builtin          = c.green,
		keyword_return   = c.green,
		variable_builtin = c.orange_bright,
		const_builtin    = c.orange_bright,
		regex            = c.orange_bright,
		escape           = c.orange_bright,
		punct_special    = c.orange_bright,
		punct            = c.subtext1,
		attribute        = c.red,
		tag              = c.blue,
		tag_attr         = c.yellow,
		tag_delim        = c.magenta,
		raw              = c.magenta,
		list             = c.magenta,
		quote            = c.subtext0,
		url              = c.red,
		strong           = c.red_dim,
		deprecated       = c.overlay2,
		todo             = c.base,
		todo_bg          = c.blue,
	})
end

-- stylua: ignore
ret.styles = {
	statusline = { bg = '#30302c', fg = '#a8a897', fg_nc = '#666656' },
	winbar     = { bg = '#30302c', fg = '#969896' },
	tabline    = { bg = '#282a2e', fg = '#767676', fill = '#30302c', sel = '#969896', sel_fg = '#626262' },
	float      = { bg = '#171b21', border = '#425059' },
	pmenu      = { bg = '#373b41', sel = '#465f90', sbar = '#30302c', thumb = '#707880' },
	separator  = { fg = '#282a2e' },
	gutter     = { bg = '#1d1f21', fg = '#373b41' },
}

ret.search = { bg = '#465f90', fg = '#c5c8c6' }
ret.incsearch = { bg = '#b5bd68', fg = '#1d1f21' }
ret.selection = '#4d2238'
ret.match_paren = { fg = '#81a2be', bg = '#425059' }
ret.folded = { fg = '#666656' }
-- 5281fc32's blends of #008500 and #800000 over the background.
-- stylua: ignore
ret.diff = {
	add      = '#1a291e',
	change   = '#31191a',
	delete   = '#31191a',
	text     = '#580c0d',
	text_add = '#2f5c36',
}

return ret

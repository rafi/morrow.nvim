-- Builds the color table `c` for a theme: its grays, accents and syntax
-- roles, the shared roles derived from them, the UI elements resolved
-- from `styles`, then the user's on_colors.

local Config = require('morrow.config')
local Util = require('morrow.util')

local M = {}

-- The status line's raised background: a third of the way from surface0
-- to surface1.
local function raised(g)
	return Util.blend(g.surface1, 0.33, g.surface0)
end

-- Which gray steps (and accents) each element uses. `g` is the theme's
-- colors with the element's palette laid over them.
-- stylua: ignore
M.elements = {
	statusline = function(g) return { bg = raised(g), fg = g.subtext0, fg_nc = g.overlay0 } end,
	winbar     = function(g) return { bg = raised(g), fg = g.overlay2, bg_nc = g.mantle } end,
	tabline    = function(g) return { bg = g.base, fill = g.crust, fg = g.overlay2, sel = g.surface1, sel_fg = g.subtext0 } end,
	float      = function(g) return { bg = g.mantle, border = g.surface2, title = g.yellow, footer = g.overlay1 } end,
	pmenu      = function(g) return { bg = g.surface1, sel = Util.blend(g.blue, 0.4, g.surface1), sbar = g.surface0, thumb = g.overlay1, border = g.overlay2 } end,
	picker     = function(g) return { bg = g.mantle, border = g.surface2, title = g.yellow } end,
	sidebar    = function(g) return { bg = g.mantle } end,
	code       = function(g) return { bg = g.surface0 } end,
	separator  = function(g) return { fg = g.surface0 } end,
	inactive   = function(g) return { bg = g.mantle } end,
	cmdline    = function(g) return { bg = g.mantle, border = g.surface1 } end,
	gutter     = function(g) return { bg = g.mantle, fg = g.surface1 } end,
	cursorline = function(g) return { bg = g.surface0 } end,
}

-- Resolution order: an element a fallback names comes before it.
-- stylua: ignore
M.order = {
	'statusline', 'float', 'pmenu', 'code', 'sidebar', 'separator',
	'inactive', 'cmdline', 'gutter', 'cursorline', 'winbar', 'tabline',
	'picker',
}

-- Style for an element neither the user nor the theme styles: another
-- element's name (reuse its style value with this element's rule) or a
-- keyword. Elements missing here use their rule on the theme's colors.
-- stylua: ignore
M.fallback = {
	winbar = 'statusline', tabline = 'statusline', picker = 'float',
	sidebar = 'normal', inactive = 'normal', cmdline = 'normal', gutter = 'normal',
}

-- Elements whose border `styles.border` overrides.
M.framed = { 'float', 'pmenu', 'picker', 'cmdline' }

-- Colors for one element from its style value: a palette name, 'normal'
-- (the editor background), 'transparent', a table of colors merged over
-- the element's rule, or nil (the rule on the theme's own colors). With
-- `opts.transparent`, an element painted with the editor background has
-- none, so the terminal shows through it as it does through Normal.
---@param c morrow.Colors
---@param opts morrow.Config
---@param name string
---@param style? morrow.StyleValue
---@return table
local function element(c, opts, name, style)
	local rule = M.elements[name]
	local ret
	if style == 'normal' or style == 'transparent' then
		ret = vim.tbl_extend('force', rule(c), {
			bg = style == 'transparent' and c.none or c.base,
		})
	elseif type(style) == 'string' then
		local palette = Util.mod(
			'morrow.palettes.' .. style,
			("morrow: unknown palette '%s' in styles.%s"):format(style, name)
		)
		ret = rule(vim.tbl_extend('force', c, palette))
	else
		ret = vim.tbl_extend('force', rule(c), style or {})
	end
	if opts.transparent and ret.bg == c.base then
		ret.bg = c.none
	end
	return ret
end

-- The border color `styles.border` gives an element: its own background
-- for 'hidden' (the editor background when it has none), a hex color as
-- given, else that palette's surface2.
---@param c morrow.Colors
---@param e table the element's colors
---@param border string
---@return string
local function border_color(c, e, border)
	if border == 'hidden' then
		return e.bg == c.none and c.base or e.bg
	elseif border:sub(1, 1) == '#' then
		return border
	end
	local palette = Util.mod(
		'morrow.palettes.' .. border,
		("morrow: unknown palette '%s' in styles.border"):format(border)
	)
	return palette.surface2 or c.surface2
end

-- Shared roles derived from the theme's colors. setup() merges them with
-- 'keep', so any role (or role field) the theme sets itself wins.
---@param c morrow.Colors
---@return table
local function derive(c)
	-- A color mixed over the editor background.
	local function mix(color, alpha)
		return Util.blend(color, alpha, c.base)
	end
	-- stylua: ignore
	return {
		diag        = { error = c.red, warn = c.yellow, info = c.cyan, hint = c.blue, ok = c.green },
		diff        = { add = mix(c.green, 0.15), change = mix(c.blue, 0.15), delete = mix(c.red, 0.15), text = mix(c.blue, 0.3), text_add = mix(c.green, 0.3) },
		git         = { add = c.green, change = c.yellow, delete = c.red, ignore = c.overlay0, sign = { add = mix(c.green, 0.5), change = mix(c.yellow, 0.56), delete = mix(c.red, 0.48) } },
		ref         = { read = mix(c.magenta, 0.2), write = mix(c.green, 0.2) },
		search      = { bg = mix(c.blue, 0.4), fg = c.text },
		incsearch   = { bg = c.green, fg = c.base },
		visual      = c.surface1,
		selection   = mix(c.magenta, 0.25),
		match_paren = { fg = c.blue, bg = c.surface2, bold = true },
		indent      = { fg = c.surface1, scope = c.blue },
		inlay       = c.syntax.comment,
		folded      = { fg = c.overlay0 },
		rainbow     = { red = c.red, yellow = c.yellow, blue = c.blue, orange = c.orange, green = c.green, violet = c.magenta, cyan = c.cyan },
		terminal    = {
			black   = c.surface0, black_bright   = c.overlay1,
			red     = c.red,      red_bright     = c.red,
			green   = c.green,    green_bright   = c.green,
			yellow  = c.yellow,   yellow_bright  = c.yellow,
			blue    = c.blue,     blue_bright    = c.blue,
			magenta = c.magenta,  magenta_bright = c.magenta,
			cyan    = c.cyan,     cyan_bright    = c.cyan,
			white   = c.subtext1, white_bright   = c.text,
		},
	}
end

-- A fresh copy of a theme; a theme file may return a function of the
-- options instead of a table. Only plain names map to theme files, and
-- 'init' is this module, not a theme.
---@param name string
---@param opts morrow.Config
---@return morrow.Theme
local function load(name, opts)
	local err = ("morrow: unknown theme '%s'"):format(tostring(name))
	if
		type(name) ~= 'string'
		or not name:match('^[%w_%-]+$')
		or name == 'init'
	then
		error(err, 0)
	end
	local theme = Util.mod('morrow.themes.' .. name, err)
	theme = vim.deepcopy(theme)
	if type(theme) == 'function' then
		theme = theme(opts)
	end
	return theme
end

-- Build `c` for the configured (or given) theme. Also returns the options
-- with the theme's default styles merged under the user's, for groups.
---@param opts? morrow.Config
---@return morrow.Colors c
---@return morrow.Config opts
function M.setup(opts)
	opts = Config.extend(opts)
	local theme = load(opts.theme, opts)
	local styles =
		vim.tbl_deep_extend('force', theme.styles or {}, opts.styles or {})

	---@type morrow.Colors
	local c = theme
	local syntax = theme.syntax
	c.styles = nil
	c.none = 'NONE'
	c.syntax = syntax(c)
	c = vim.tbl_deep_extend('keep', c, derive(c))

	-- Resolve each element's style value, remembering the raw values so a
	-- fallback can reuse another element's.
	local chosen = {}
	for _, name in ipairs(M.order) do
		local style = styles[name]
		if style == nil then
			style = M.fallback[name]
			if M.elements[style] then
				style = chosen[style]
			end
		end
		chosen[name] = style
		c[name] = element(c, opts, name, style)
	end

	if styles.border then
		if type(styles.border) ~= 'string' then
			error(
				'morrow: styles.border must be a palette name, '
					.. "'hidden' or a '#rrggbb' color",
				0
			)
		end
		for _, name in ipairs(M.framed) do
			c[name].border = border_color(c, c[name], styles.border)
		end
	end

	opts = vim.tbl_extend('force', {}, opts, { styles = styles })
	opts.on_colors(c)
	-- After on_colors, so group files blend over a changed base.
	Util.bg = c.base
	return c, opts
end

return M

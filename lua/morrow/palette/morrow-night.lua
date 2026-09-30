local C = require('morrow.lib.color')
local Shade = require('morrow.lib.shade')

local meta = {
	name = 'morrow-night',
	light = false,
}

-- stylua: ignore
local catpu = {
	rosewater = "#f5e0dc", --    winbar
	flamingo  = "#f2cdcd", --    identifier
	pink      = "#f5c2e7", --    preproc, special, h1
	mauve     = "#cba6f7", --    syntax
	red       = "#cc6666", -- OK
	maroon    = "#eba0ac", --    lsp parameter, strong
	peach     = "#de935f", -- OK
	yellow    = "#f0c674", -- OK
	green     = "#b5bd68", -- OK
	teal      = "#8abeb7", -- OK
	sky       = "#89dceb", --    search, operator
	sapphire  = "#74c7ec", --    Label -- whats this?
	blue      = "#81a2be", -- OK
	lavender  = "#b294bb", -- OK
	text      = "#c5c8c6", -- OK Normal fg
	subtext1  = "#bac2de", --    not used
	subtext0  = "#a6adc8", --    floattitle
	overlay2  = "#9399b2", --    delimiter, pmenu fg
	overlay1  = "#7f849c", --    conceal
	overlay0  = "#6c7086", --    fg: comment, fold column, etc.
	surface2  = "#585b70", --
	surface1  = "#45475a", --    illuminate, selections, columns, etc.
	surface0  = "#313244", --    column/line, pmenu bg
	base      = "#1d1f21", -- OK Normal bg
	mantle    = "#181825", --    surround
	crust     = "#11111b", --    cover
}

-- stylua: ignore
local palette = {
	black   = Shade.new('#373b41', 0.15, -0.15),
	red     = Shade.new('#cc6666', 0.25, -0.25),
	green   = Shade.new('#b5bd68', 0.10, -0.15),
	yellow  = Shade.new('#f0c674', 0.25, -0.25),
	blue    = Shade.new('#81a2be', 0.15, -0.15),
	magenta = Shade.new('#b294bb', 0.30, -0.15),
	cyan    = Shade.new('#8abeb7', 0.15, -0.15),
	white   = Shade.new('#e0e0e0', 0.15, -0.15), -- Used?
	orange  = Shade.new('#de935f', 0.15, -0.15),
	pink    = Shade.new('#4d2238', 0.15, -0.15),
	brown   = Shade.new('#a3685a', 0.15, -0.15), -- TODO not used

	comment = '#707880',

	bg0     = '#30302c', -- Dark bg (status line and float)
	bg1     = '#1d1f21', -- Default bg
	bg2     = '#282a2e', -- Lighter bg (color column, folds, cursor line)
	bg3     = '#171b21', -- Float bg
	bg4     = '#425059', -- Borders (window separator, float border)

	fg0     = '#b4b7b4', -- Lighter fg TODO not used
	fg1     = '#c5c8c6', -- Default fg
	fg2     = '#a8a897', -- Darker fg (status line)
	fg3     = '#969896', -- Darker fg (line numbers, fold colums)
	fg4     = '#666656', -- Status line non-active

	sel0    = '#373b41', -- Popup bg, visual selection bg
	sel1    = '#465F90', -- Popup sel bg, search bg
}

local function generate_spec(pal)
	-- stylua: ignore start
	local spec = {
		bg0  = pal.bg0,  -- Dark bg (status line and float)
		bg1  = pal.bg1,  -- Default bg
		bg2  = pal.bg2,  -- Lighter bg (colorcolm folds)
		bg3  = pal.bg3,  -- Lighter bg (cursor line)
		bg4  = pal.bg4,  -- Conceal, border fg

		fg0  = pal.fg0,  -- Lighter fg
		fg1  = pal.fg1,  -- Default fg
		fg2  = pal.fg2,  -- Darker fg (status line)
		fg3  = pal.fg3,  -- Darker fg (line numbers, fold colums)
		fg4  = pal.fg4,

		sel0 = pal.sel0, -- Popup bg, visual selection bg
		sel1 = pal.sel1, -- Popup sel bg, search bg

		-- TODO:
		read          = '#3d3741', -- reference read
		write         = '#374137', -- reference write
		tabline       = '#767676', -- Tabline foreground
		tablinesel    = '#626262', -- Tabline selected tab
		lualineadd    = C(pal.green:subtle()):lighten(-10):to_css(),  -- #53713e
		lualinechange = C(pal.yellow:subtle()):lighten(-10):to_css(), -- #875F00
		lualinedelete = pal.brown:subtle(),                           -- #7a3d3d
		gitadd        = '#008500',
		gitchange     = C(pal.yellow:subtle()):lighten(-10):to_css(), -- #808200
		gitdelete     = C(pal.red:subtle()):lighten(-10):to_css(),    -- #800000
		neotreeadd    = pal.cyan.base,   -- #85b293
		neotreechange = pal.red:harsh(), -- #c88d8d
		neotreedelete = pal.pink.base,   -- #804152

		diff_text       = C(pal.bg1):blend(C('#800000'), 0.6):to_css(), -- word diff
		-- diff_text       = C(pal.bg1):blend(C('#5f5f87'), 0.7):to_css(),
		diff_add        = C(pal.bg1):blend(C('#008500'), 0.1):to_css(), -- '#5f875f',
		diff_addfg      = '#d7ffaf',
		diff_change     = C(pal.bg1):blend(C('#800000'), 0.2):to_css(),
		-- diff_change     = '#5f5f87',
		diff_changefg   = '#d7d7ff',
		-- diff_delete     = C(pal.bg1):blend(C(pal.red:harsh()), 0.3):to_css(),
		diff_word_add   = '#2f5c36',
		diff_word_addfg = '#ddffc3',
	}
	-- NeogitDiffAdd xxx guifg=#949a55 guibg=#1a291e
	-- DiffAdd       xxx guibg=#1a291e
	-- diffAdded     xxx guifg=#b5bd68
	-- DiffText      xxx guibg=#402623
	--
	-- GitSignsDeletePreview xxx guibg=#523436
	-- GitSignsAddPreview    xxx guifg=#d7ffaf guibg=#1a291e


	spec.syntax = {
		bracket     = spec.fg0,           -- Brackets and Punctuation
		builtin0    = pal.green.base,     -- Builtin variable
		builtin1    = pal.magenta.base,   -- Builtin type
		builtin2    = pal.orange.bright,  -- Builtin const
		builtin3    = pal.red.bright,     -- TODO not used
		comment     = pal.comment,        -- Comment
		conditional = pal.blue.base,      -- Conditional and loop
		const       = pal.red.base,       -- Constants, imports and booleans
		dep         = spec.fg3,           -- Deprecated
		field       = pal.magenta.base,   -- Field
		func        = pal.yellow.base,    -- Functions and Titles
		ident       = pal.magenta.base,   -- Identifiers
		keyword     = pal.blue.base,      -- Keywords
		number      = pal.red.base,       -- Numbers
		operator    = pal.cyan.base,      -- Operators
		preproc     = pal.cyan.base,      -- PreProc
		regex       = pal.orange.bright,  -- Regex
		statement   = pal.blue.base,      -- Statements
		string      = pal.green.base,     -- Strings
		structure   = pal.cyan.base,      -- Structures
		type        = pal.orange.base,    -- Types
		variable    = pal.magenta.base,   -- Variables
	}

	spec.diag = {
		error = pal.red.base,
		warn  = pal.yellow.base,
		info  = pal.cyan.base,
		hint  = pal.blue.base,
		ok    = pal.green.base,
	}

	spec.diag_virtual_bg = {
		error = C(spec.bg1):blend(C(spec.diag.error), 0.2):to_css(),
		warn  = C(spec.bg1):blend(C(spec.diag.warn), 0.2):to_css(),
		info  = C(spec.bg1):blend(C(spec.diag.info), 0.2):to_css(),
		hint  = C(spec.bg1):blend(C(spec.diag.hint), 0.2):to_css(),
		ok    = C(spec.bg1):blend(C(spec.diag.ok), 0.2):to_css(),
	}

	return spec
end

return { meta = meta, palette = palette, generate_spec = generate_spec }

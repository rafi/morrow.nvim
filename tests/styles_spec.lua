-- Element styles: palettes, keywords, tables, fallbacks and border.

local function colors(opts)
	fresh(opts)
	return (require('morrow.themes').setup())
end

test('night elements default to its literal chrome', function()
	local c = colors({ theme = 'night' })
	eq({ bg = '#282a2e', fg = '#c5c8c6', fg_nc = '#969896' }, c.statusline)
	-- winbar reuses the statusline's style value with the winbar rule
	eq(
		{ bg = '#282a2e', fg = '#c5c8c6', fg_nc = '#969896', bg_nc = '#18191a' },
		c.winbar
	)
	-- picker reuses the float's table
	eq({ bg = '#1d1f21', border = '#373b41', title = '#f0c674' }, c.picker)
	eq({ bg = '#1d1f21' }, c.sidebar) -- 'normal'
	eq({ bg = '#1d1f21' }, c.inactive)
	eq({ bg = '#1d1f21', border = '#373b41' }, c.cmdline)
	eq({ bg = '#282a2e' }, c.code) -- rule on night's grays
	eq({ bg = '#1d1f21', fg = '#475f63' }, c.gutter)
end)

test('a palette restyles one element from its gray ramp', function()
	local c = colors({ theme = 'night', styles = { statusline = 'olive' } })
	eq({ bg = '#313027', fg = '#a7a89b', fg_nc = '#666656' }, c.statusline)
	-- winbar has no style and follows the statusline's palette
	eq({ bg = '#313027', fg = '#909083', bg_nc = '#19190e' }, c.winbar)
	-- tabline follows morrow's rule, not the statusline's palette
	eq('#1d1f21', c.tabline.bg)
	-- the rest of the theme is untouched
	eq('#282a2e', c.surface0)
end)

test('every theme draws its tabline deeper than the editor', function()
	for _, theme in ipairs({ 'night', 'hybrid', 'rafi' }) do
		local c = colors({ theme = theme })
		local function n(hex)
			return tonumber(hex:sub(2), 16)
		end
		-- the bar is below the editor, inactive tabs are lighter than the
		-- bar, and the active tab is lighter still
		assert(n(c.tabline.fill) < n(c.base), theme)
		assert(n(c.tabline.fill) < n(c.tabline.bg), theme)
		assert(n(c.tabline.bg) < n(c.tabline.sel), theme)
	end
end)

test('the four palettes give their raised status lines', function()
	for name, bg in pairs({
		olive = '#313027',
		neutral = '#2e3032',
		slate = '#2c3035',
		steel = '#26313d',
	}) do
		eq(bg, colors({ styles = { statusline = name } }).statusline.bg, name)
	end
end)

test('a table merges over the theme table and the rule', function()
	local c =
		colors({ theme = 'night', styles = { statusline = { fg = '#ffffff' } } })
	eq({ bg = '#282a2e', fg = '#ffffff', fg_nc = '#969896' }, c.statusline)
end)

test("'normal' and 'transparent' set the background", function()
	local c = colors({ styles = { float = 'normal', sidebar = 'transparent' } })
	eq('#1d1f21', c.float.bg)
	eq('NONE', c.sidebar.bg)
	c = colors({ transparent = true })
	eq('NONE', c.sidebar.bg) -- 'normal' fallback honors transparent
	eq('NONE', c.inactive.bg)
	eq('NONE', c.float.bg) -- night's flat float is the editor background
end)

test('picker follows a styled float when unset', function()
	local c = colors({ theme = 'hybrid', styles = { float = 'slate' } })
	eq('#15191f', c.float.bg)
	eq({ bg = '#15191f', border = '#484e56', title = '#f0c674' }, c.picker)
end)

test('a palette accent reaches only its element', function()
	fresh({ theme = 'hybrid', styles = { float = 'zz' } })
	-- injected after fresh(), which unloads every morrow.* module
	package.loaded['morrow.palettes.zz'] =
		{ mantle = '#000000', yellow = '#ff0000' }
	local c = require('morrow.themes').setup()
	package.loaded['morrow.palettes.zz'] = nil
	eq({
		bg = '#000000',
		border = '#4a4f56',
		title = '#ff0000',
		footer = '#707880',
	}, c.float)
	eq('#f0c674', c.syntax.func)
	eq('#f0c674', c.yellow)
end)

test('an unknown palette raises an error naming the element', function()
	fresh({ styles = { float = 'nope' } })
	raises("morrow: unknown palette 'nope' in styles.float", function()
		require('morrow.themes').setup()
	end)
end)

test('border hidden, palette and hex modes', function()
	local c = colors({ theme = 'hybrid', styles = { border = 'hidden' } })
	eq(c.float.bg, c.float.border)
	eq('#373b41', c.pmenu.border)
	eq(c.cmdline.bg, c.cmdline.border)
	c = colors({ theme = 'hybrid', styles = { border = 'slate' } })
	eq('#484e56', c.float.border)
	eq('#484e56', c.picker.border)
	c = colors({ theme = 'hybrid', styles = { border = '#123456' } })
	eq('#123456', c.pmenu.border)
end)

test('hybrid and rafi keep their literal chrome', function()
	local c = colors({ theme = 'hybrid' })
	eq({
		bg = '#1d1f21',
		fg = '#858c92',
		fill = '#101113',
		sel = '#373b41',
		sel_fg = '#9aa0a3',
	}, c.tabline)
	eq({
		bg = '#373b41',
		sel = '#c5c8c6',
		sel_fg = '#373b41',
		sbar = '#282a2e',
		thumb = '#707880',
		border = '#858c92',
	}, c.pmenu)
	c = colors({ theme = 'rafi' })
	eq(nil, c.statusline.bg_nc)
	eq('#171b21', c.float.bg)
	eq({ bg = '#30302c', fg = '#969896', bg_nc = '#171b21' }, c.winbar)
end)

test('a hidden border on a transparent element uses the base', function()
	local c = colors({
		theme = 'night',
		transparent = true,
		styles = { border = 'hidden' },
	})
	eq('#1d1f21', c.float.border)
end)

test('a border that is not a string raises', function()
	fresh({ styles = { border = {} } })
	raises(
		'morrow: styles.border must be a palette name, '
			.. "'hidden' or a '#rrggbb' color",
		function()
			require('morrow.themes').setup()
		end
	)
end)

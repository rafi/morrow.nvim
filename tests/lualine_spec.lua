-- Lualine themes follow each theme's status line, including styles.

test('lualine themes sit on the status line background', function()
	fresh()
	eq('#282a2e', require('lualine.themes.morrow-night').normal.c.bg)
	local hybrid = require('lualine.themes.morrow-hybrid')
	eq('#2d3034', hybrid.normal.c.bg)
	eq('#2d3034', hybrid.inactive.a.bg)
	eq('#5d646b', hybrid.inactive.a.fg)
	eq('#685d47', hybrid.insert.z.bg) -- yellow blended into #2d3034
	eq('#30302c', require('lualine.themes.morrow-rafi').normal.c.bg)
end)

test(
	'the morrow lualine theme follows the configured theme and styles',
	function()
		fresh({ theme = 'night', styles = { statusline = 'olive' } })
		local t = require('lualine.themes.morrow')
		eq('#313027', t.normal.c.bg)
		eq('#4f4a30', t.normal.z.bg)
	end
)

test('transparent lualine sections have no background', function()
	fresh({ transparent = true })
	eq('NONE', require('lualine.themes._morrow').get('rafi').normal.c.bg)
end)

test('a transparent status line style still builds mode colors', function()
	fresh({ theme = 'night', styles = { statusline = 'transparent' } })
	local t = require('lualine.themes._morrow').get()
	eq('NONE', t.normal.c.bg)
	eq('#5c513a', t.insert.z.bg) -- yellow blended over the editor background
end)

test('dim lualine text follows the status line foreground', function()
	fresh()
	eq('#797e82', require('lualine.themes._morrow').get('hybrid').normal.x.fg)
end)

test('the morrow lualine theme follows the active morrow scheme', function()
	fresh({ theme = 'night' })
	vim.cmd.colorscheme('morrow-hybrid')
	eq('#2d3034', require('lualine.themes.morrow').normal.c.bg)
end)

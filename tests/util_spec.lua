-- Util: color blending, module loading by path and style flattening.

local Util = require('morrow.util')

test('blend mixes in RGB: alpha 1 gives fg, 0 gives bg', function()
	eq('#808080', Util.blend('#ffffff', 0.5, '#000000'))
	eq('#cc6666', Util.blend('#cc6666', 1, '#1d1f21'))
	eq('#1d1f21', Util.blend('#cc6666', 0, '#1d1f21'))
	eq('#2c3035', Util.blend('#373b41', 0.33, '#272a2f'))
end)

test('blend extrapolates outside 0..1 and clamps channels', function()
	eq('#ffffff', Util.blend('#000000', -1.5, '#808080'))
end)

test('blend_bg blends over Util.bg unless a background is given', function()
	Util.bg = '#1d1f21'
	eq('#402d2f', Util.blend_bg('#cc6666', 0.2))
	eq('#808080', Util.blend_bg('#ffffff', 0.5, '#000000'))
end)

test('root is the plugin directory', function()
	eq(ROOT, Util.root)
end)

test('mod loads by path and caches in package.loaded', function()
	package.loaded['morrow.util'] = nil
	local loaded = Util.mod('morrow.util')
	eq('function', type(loaded.blend))
	eq(loaded, package.loaded['morrow.util'])
end)

test('mod raises the given message for a missing file', function()
	raises("morrow: unknown theme 'nope'", function()
		Util.mod('morrow.themes.nope', "morrow: unknown theme 'nope'")
	end)
	raises('morrow: module not found: morrow.nope', function()
		Util.mod('morrow.nope')
	end)
end)

test('resolve flattens style tables into the group', function()
	local groups = Util.resolve({
		Comment = { fg = '#969896', style = { italic = true } },
		Link = 'Comment',
	})
	eq({ fg = '#969896', italic = true }, groups.Comment)
	eq('Comment', groups.Link)
end)

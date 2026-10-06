-- themes.setup(): theme loading, syntax, derived roles and on_colors.

local function setup(opts)
	fresh(opts)
	return require('morrow.themes').setup()
end

test('setup builds the configured theme', function()
	local c = setup({ theme = 'hybrid' })
	eq('#1d1f21', c.base)
	eq('NONE', c.none)
	eq('#81a2be', c.syntax.keyword)
	eq(nil, c.styles)
end)

test('an unknown theme raises an error naming it', function()
	fresh({ theme = 'nope' })
	raises("morrow: unknown theme 'nope'", function()
		require('morrow.themes').setup()
	end)
end)

test('a theme name that is not a theme file raises', function()
	fresh({ theme = 'init' })
	raises("morrow: unknown theme 'init'", function()
		require('morrow.themes').setup()
	end)
end)

test('derived roles fill what the theme leaves out', function()
	local c = setup({ theme = 'night' })
	eq({
		add = '#264b33',
		change = '#12404b',
		delete = '#41454b',
		text = '#3b4650',
		text_add = '#4b4e36',
	}, c.diff)
	eq({ add = '#b5bd68', change = '#f0c674', delete = '#cc6666' }, c.git.sign)
	eq('#b5bd68', c.git.add)
	eq('#666a6c', c.git.ignore) -- overlay0
end)

test('derived defaults for hybrid', function()
	local c = setup({ theme = 'hybrid' })
	eq('#cc6666', c.diag.error)
	eq('#8abeb7', c.diag.info)
	eq('#4b4e36', c.diff.text_add) -- derived, next to hybrid's literals
	eq('#d7ffaf', c.diff.add_fg)
	eq({ read = '#3b3640', write = '#3b3f2f' }, c.ref)
	eq('#373b41', c.visual)
	eq('#423c48', c.selection)
	eq({ fg = '#373b41', scope = '#81a2be' }, c.indent)
	eq('#707880', c.inlay) -- the comment color
	eq({ fg = '#707880', bg = '#1c1c1c' }, c.folded)
	eq('#b294bb', c.rainbow.violet)
	eq('#282a2e', c.terminal.black)
	eq('#707880', c.terminal.black_bright)
	eq('#cc6666', c.terminal.red_bright)
	eq('#c5c8c6', c.terminal.white_bright)
end)

test('rafi keeps its literal roles', function()
	local c = setup({ theme = 'rafi' })
	eq({ bg = '#465f90', fg = '#c5c8c6' }, c.search)
	eq('#4d2238', c.selection)
	eq({ fg = '#666656' }, c.folded)
end)

test('night match_paren keeps NONE so brackets keep their colors', function()
	local c = setup({ theme = 'night' })
	eq({ fg = 'NONE', bg = 'NONE', sp = '#b39613', bold = true }, c.match_paren)
	eq('#b5bd68', c.diag.info)
end)

test('Util.bg follows the theme base', function()
	setup({ theme = 'hybrid' })
	eq('#1d1f21', require('morrow.util').bg)
end)

test('returned opts merge theme styles under user styles', function()
	fresh({ theme = 'night', styles = { comments = { italic = false } } })
	local _, opts = require('morrow.themes').setup()
	eq({ italic = false }, opts.styles.comments)
	eq({ italic = true }, opts.styles.keywords)
	eq(nil, require('morrow.config').options.styles.keywords.italic)
end)

test('on_colors sees and can change the final colors', function()
	local c = setup({
		theme = 'hybrid',
		on_colors = function(colors)
			colors.syntax.keyword = '#ff0000'
		end,
	})
	eq('#ff0000', c.syntax.keyword)
end)

test('colors hold no functions, so they encode as JSON', function()
	for _, name in ipairs({ 'night', 'hybrid', 'rafi' }) do
		local c = setup({ theme = name })
		local ok, err = pcall(vim.json.encode, c)
		assert(ok, name .. ': ' .. tostring(err))
	end
end)

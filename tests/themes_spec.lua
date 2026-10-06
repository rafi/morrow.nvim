-- Theme files: required keys, syntax completeness and the values copied
-- from each source.

local GRAYS = {
	'crust',
	'mantle',
	'base',
	'surface0',
	'surface1',
	'surface2',
	'overlay0',
	'overlay1',
	'overlay2',
	'subtext0',
	'subtext1',
	'text',
}
local ACCENTS =
	{ 'red', 'orange', 'yellow', 'green', 'cyan', 'blue', 'magenta', 'brown' }
local ROLES = {
	'comment',
	'keyword',
	'keyword_return',
	'func',
	'type',
	'type_builtin',
	'structure',
	'string',
	'number',
	'const',
	'const_builtin',
	'variable',
	'variable_builtin',
	'builtin',
	'module',
	'member',
	'property',
	'parameter',
	'constructor',
	'identifier',
	'operator',
	'punct',
	'punct_special',
	'preproc',
	'attribute',
	'special',
	'escape',
	'regex',
	'tag',
	'tag_attr',
	'tag_delim',
	'label',
	'todo',
	'deprecated',
	'raw',
	'url',
	'quote',
	'list',
	'strong',
}

local function is_hex(v)
	return type(v) == 'string' and v:match('^#%x%x%x%x%x%x$') ~= nil
end

-- Every theme defines the 12 grays, the 8 accents and a syntax() that
-- returns every role as a hex color (heading as a list of 6).
local function check_theme(name, theme)
	for _, key in ipairs(vim.list_extend(vim.list_extend({}, GRAYS), ACCENTS)) do
		assert(is_hex(theme[key]), name .. '.' .. key .. ' is not a hex color')
	end
	local syn = theme.syntax(theme)
	for _, role in ipairs(ROLES) do
		assert(is_hex(syn[role]), name .. ' syntax.' .. role .. ' is not hex')
	end
	eq(6, #syn.heading, name .. ' syntax.heading')
	for i, color in ipairs(syn.heading) do
		assert(is_hex(color), name .. ' syntax.heading[' .. i .. ']')
	end
end

test('hybrid defines every color and syntax role', function()
	check_theme('hybrid', require('morrow.themes.hybrid'))
end)

test('hybrid keeps upstream colors where Neovim leaks defaults', function()
	local t = require('morrow.themes.hybrid')
	local syn = t.syntax(t)
	eq('#707880', syn.comment)
	eq('#81a2be', syn.keyword)
	eq('#f0c674', syn.func)
	eq('#de935f', syn.type)
	eq('#c5c8c6', syn.variable) -- not Neovim's leaked #e0e2ea
	eq('#c5c8c6', syn.punct)
	eq('#b294bb', syn.property)
	eq('#b5bd68', syn.tag)
	eq('#d7ffaf', syn.todo)
	eq({ sel = '#1d1f21', sel_fg = '#c5c8c6' }, t.styles.tabline)
	eq({ bg = '#1c1c1c', fg = '#373b41' }, t.styles.gutter)
	eq({ bg = '#f0c674', fg = '#1d1f21' }, t.search)
	eq('#5f875f', t.diff.add)
	eq('#d7ffaf', t.diff.add_fg)
end)

test('night defines every color and syntax role', function()
	check_theme('night', require('morrow.themes.night'))
end)

test('night uses the JetBrains Tomorrow Night mapping and chrome', function()
	local t = require('morrow.themes.night')
	local syn = t.syntax(t)
	eq('#969896', syn.comment)
	eq('#b294bb', syn.keyword)
	eq('#81a2be', syn.func)
	eq('#f0c674', syn.type)
	eq('#de935f', syn.parameter)
	eq('#cc6666', syn.variable)
	eq('#c5c8c6', syn.punct)
	eq('#89ddf7', syn.url)
	eq('#ffeb95', syn.todo)
	eq(
		{ '#b5bd68', '#81a2be', '#81a2be', '#81a2be', '#81a2be', '#81a2be' },
		syn.heading
	)
	eq({ italic = true }, t.styles.comments)
	eq({ italic = true }, t.styles.keywords)
	eq({ bg = '#282a2e', fg = '#c5c8c6', fg_nc = '#969896' }, t.styles.statusline)
	eq({ bg = '#282a2e' }, t.styles.cursorline)
	eq({ bg = '#1d1f21', fg = '#475f63' }, t.styles.gutter)
	eq({ bg = '#32424a', fg = '#c5c8c6' }, t.search)
	eq({ fg = 'NONE', bg = 'NONE', sp = '#b39613' }, t.match_paren)
	eq({ add = '#264b33', change = '#12404b', delete = '#41454b' }, t.diff)
	eq({ fg = '#37474f', scope = '#80cbc4' }, t.indent)
	eq('#666a6c', t.inlay)
end)

test('rafi defines every color and syntax role', function()
	check_theme('rafi', require('morrow.themes.rafi'))
end)

test('rafi extends hybrid with 5281fc32 colors', function()
	local t = require('morrow.themes.rafi')
	local syn = t.syntax(t)
	eq('#707880', syn.comment) -- inherited from hybrid
	eq('#81a2be', syn.keyword)
	eq('#b294bb', syn.variable) -- hybrid keeps the foreground here
	eq('#b4b7b4', syn.punct)
	eq('#e3a377', syn.regex)
	eq('#b5bd68', syn.keyword_return)
	eq('#1d1f21', syn.todo)
	eq('#81a2be', syn.todo_bg)
	eq('#994d4d', syn.strong)
	eq('#171b21', t.mantle)
	eq('#425059', t.surface2)
	eq('#373b41', t.surface1) -- inherited
end)

test('rafi replaces hybrid tables whole, leaving no stray fields', function()
	local t = require('morrow.themes.rafi')
	eq({ bg = '#30302c', fg = '#a8a897', fg_nc = '#666656' }, t.styles.statusline)
	eq(nil, t.styles.pmenu.sel_fg)
	eq(nil, t.diff.add_fg)
	eq({ fg = '#666656' }, t.folded)
	eq({ bg = '#465f90', fg = '#c5c8c6' }, t.search)
end)

test(
	'a child theme that changes an accent moves syntax built from it',
	function()
		local child = vim.deepcopy(require('morrow.themes.hybrid'))
		child.blue = '#0000ff'
		eq('#0000ff', child.syntax(child).keyword)
	end
)

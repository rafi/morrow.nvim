-- Public API: colorschemes, theme switching, options and terminal colors.

test('colorscheme morrow-night applies night', function()
	fresh()
	vim.cmd.colorscheme('morrow-night')
	eq('morrow-night', vim.g.colors_name)
	eq('dark', vim.o.background)
	eq('#1d1f21', hex(hl('Normal').bg))
	eq('#c5c8c6', hex(hl('Normal').fg))
	eq('#969896', hex(hl('Comment').fg))
	eq(true, hl('Comment').italic)
	eq(true, hl('Keyword').italic)
	eq('#282a2e', hex(hl('CursorLine').bg))
	eq('#475f63', hex(hl('LineNr').fg))
	eq(true, hl('MatchParen').underline)
	eq('#b39613', hex(hl('MatchParen').sp))
	eq(nil, hl('MatchParen').bg)
end)

test('colorscheme morrow-hybrid applies hybrid', function()
	fresh()
	vim.cmd.colorscheme('morrow-hybrid')
	eq('morrow-hybrid', vim.g.colors_name)
	eq('#2d3034', hex(hl('StatusLine').bg))
	eq('#9aa0a3', hex(hl('StatusLine').fg))
	eq('#5d646b', hex(hl('StatusLineNC').fg))
	eq('#c5c8c6', hex(hl('PmenuSel').bg))
	eq('#373b41', hex(hl('PmenuSel').fg))
	eq('#c5c8c6', hex(hl('@variable').fg))
	eq('#b294bb', hex(hl('Identifier').fg))
	eq('#1c1c1c', hex(hl('SignColumn').bg))
	eq('#d7ffaf', hex(hl('DiffAdd').fg))
end)

test('colorscheme morrow-rafi applies rafi', function()
	fresh()
	vim.cmd.colorscheme('morrow-rafi')
	eq('#30302c', hex(hl('StatusLine').bg))
	eq('#171b21', hex(hl('NormalFloat').bg))
	eq('#425059', hex(hl('FloatBorder').fg))
	eq('#465f90', hex(hl('PmenuSel').bg))
	eq('#b294bb', hex(hl('@variable').fg))
	eq('#b4b7b4', hex(hl('Delimiter').fg))
	eq('#1d1f21', hex(hl('Todo').fg))
	eq('#81a2be', hex(hl('Todo').bg))
end)

test('colorscheme morrow loads the configured theme', function()
	fresh({ theme = 'rafi' })
	vim.cmd.colorscheme('morrow')
	eq('morrow-rafi', vim.g.colors_name)
end)

test('switching themes does not carry styles over', function()
	fresh()
	vim.cmd.colorscheme('morrow-night')
	eq(true, hl('Comment').italic)
	vim.cmd.colorscheme('morrow-hybrid')
	eq(nil, hl('Comment').italic)
	eq('#707880', hex(hl('Comment').fg))
end)

test('load works without setup()', function()
	for name in pairs(package.loaded) do
		if name:match('^morrow') then
			package.loaded[name] = nil
		end
	end
	require('morrow').load()
	eq('morrow-night', vim.g.colors_name)
end)

test('a light background ends dark without recursion', function()
	fresh()
	vim.cmd.colorscheme('morrow-hybrid')
	vim.o.background = 'light'
	vim.cmd.colorscheme('morrow-night')
	eq('dark', vim.o.background)
	eq('morrow-night', vim.g.colors_name)
end)

test('transparent clears the editor but keeps chrome', function()
	fresh({ theme = 'hybrid', transparent = true })
	require('morrow').load()
	eq(nil, hl('Normal').bg)
	eq(nil, hl('NormalNC').bg)
	eq(nil, hl('NormalSB').bg)
	eq('#18191a', hex(hl('NormalFloat').bg))
	eq('#373b41', hex(hl('Pmenu').bg))
	eq('#2d3034', hex(hl('StatusLine').bg))
end)

test('terminal colors follow the theme', function()
	fresh({ theme = 'hybrid' })
	require('morrow').load()
	eq('#282a2e', vim.g.terminal_color_0)
	eq('#cc6666', vim.g.terminal_color_1)
	eq('#707880', vim.g.terminal_color_8)
	eq('#c5c8c6', vim.g.terminal_color_15)
end)

test('on_highlights changes final groups', function()
	fresh({
		on_highlights = function(groups, c)
			groups.Normal = { fg = c.red }
		end,
	})
	require('morrow').load()
	eq('#cc6666', hex(hl('Normal').fg))
end)

test('element styles reach their groups', function()
	fresh({
		theme = 'night',
		styles = {
			statusline = 'olive',
			sidebar = 'steel',
			cmdline = 'slate',
			gutter = 'neutral',
			cursorline = 'olive',
			inactive = 'slate',
		},
	})
	require('morrow').load()
	eq('#313027', hex(hl('StatusLine').bg))
	eq('#313027', hex(hl('WinBar').bg))
	eq('#101926', hex(hl('NormalSB').bg))
	eq('#15191f', hex(hl('MsgArea').bg))
	eq('#18191a', hex(hl('LineNr').bg))
	eq('#2b2a22', hex(hl('CursorLine').bg))
	eq('#15191f', hex(hl('NormalNC').bg))
end)

test('transparent clears chrome painted with the editor background', function()
	fresh({ theme = 'night', transparent = true })
	require('morrow').load()
	eq(nil, hl('LineNr').bg)
	eq(nil, hl('SignColumn').bg)
	fresh({ theme = 'rafi', transparent = true })
	require('morrow').load()
	eq(nil, hl('LineNr').bg)
	eq('#30302c', hex(hl('StatusLine').bg))
end)

test('group blends follow an on_colors base change', function()
	fresh({
		on_colors = function(c)
			c.base = '#000000'
		end,
	})
	require('morrow').load()
	eq('#291414', hex(hl('DiagnosticVirtualTextError').bg))
end)

test(
	'NormalNC is left undefined when inactive windows are not dimmed',
	function()
		fresh({ theme = 'hybrid' })
		require('morrow').load()
		eq(true, vim.tbl_isempty(hl('NormalNC')))
	end
)

test('MatchParen is bold in night and rafi, plain in hybrid', function()
	fresh({ theme = 'hybrid' })
	require('morrow').load()
	eq(nil, hl('MatchParen').bold)
	fresh({ theme = 'night' })
	require('morrow').load()
	eq(true, hl('MatchParen').bold)
	fresh({ theme = 'rafi' })
	require('morrow').load()
	eq(true, hl('MatchParen').bold)
end)

test('a style may list attribute names', function()
	fresh({ theme = 'night', styles = { comments = { 'italic' } } })
	require('morrow').load()
	eq(true, hl('Comment').italic)
end)

test('invalid groups are skipped with one warning', function()
	fresh({
		on_highlights = function(groups)
			groups.Normal = { fg = 'nope' }
		end,
	})
	local notify = vim.notify
	local messages = {}
	vim.notify = function(msg, level)
		messages[#messages + 1] = { msg = msg, level = level }
	end
	local ok, err = pcall(require('morrow').load)
	vim.notify = notify
	eq(true, ok, tostring(err))
	eq(1, #messages)
	eq(vim.log.levels.WARN, messages[1].level)
	eq('morrow: skipped invalid highlight groups: Normal', messages[1].msg)
	eq('#969896', hex(hl('Comment').fg))
end)

test('LspReferenceTarget keeps text readable', function()
	fresh({ theme = 'night' })
	require('morrow').load()
	eq('#32424a', hex(hl('LspReferenceTarget').bg))
	eq('#c5c8c6', hex(hl('LspReferenceTarget').fg))
end)

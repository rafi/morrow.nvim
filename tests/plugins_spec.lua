-- Integration groups: element colors and roles reach plugin groups.

local function load(opts)
	fresh(opts)
	require('morrow').load()
end

test('completion menus use pmenu and floats', function()
	load({ theme = 'hybrid' })
	eq('#18191a', hex(hl('CmpDocumentation').bg))
	eq('#858c92', hex(hl('BlinkCmpMenuBorder').fg))
	eq('#373b41', hex(hl('BlinkCmpMenuBorder').bg))
	eq('#f0c674', hex(hl('BlinkCmpKindFunction').fg))
	eq('#f0c674', hex(hl('CmpItemKindFunction').fg))
	eq('#81a2be', hex(hl('BlinkCmpKind').fg))
end)

test('indent guides, code blocks and dap use their roles', function()
	load({ theme = 'night' })
	eq('#37474f', hex(hl('IblIndent').fg))
	eq('#80cbc4', hex(hl('IblScope').fg))
	eq('#474032', hex(hl('DapStoppedLine').bg))
	load({ theme = 'hybrid' })
	eq('#282a2e', hex(hl('CodeBlock').bg))
	eq('#3d382d', hex(hl('Headline').bg))
	eq('#9aa15b', hex(hl('LazySpecial').fg))
	eq('#3b3f2f', hex(hl('LazyButtonActive').bg))
end)

test('code style reaches code blocks', function()
	load({ theme = 'hybrid', styles = { code = 'steel' } })
	eq('#212b37', hex(hl('CodeBlock').bg))
end)

test('pickers follow the picker element', function()
	load({ theme = 'hybrid' })
	eq('#18191a', hex(hl('SnacksPicker').bg)) -- falls back to the float
	eq('#4a4f56', hex(hl('SnacksPickerBorder').fg))
	eq('#18191a', hex(hl('TelescopeNormal').bg))
	load({ theme = 'hybrid', styles = { picker = 'slate' } })
	eq('#15191f', hex(hl('SnacksPicker').bg))
	eq('#15191f', hex(hl('TelescopeNormal').bg))
	eq('#18191a', hex(hl('NormalFloat').bg)) -- floats stay
end)

test('sidebars follow the sidebar element', function()
	load({ theme = 'hybrid' })
	eq('#1d1f21', hex(hl('NeoTreeNormal').bg))
	eq('#1d1f21', hex(hl('TroubleNormal').bg))
	load({ theme = 'hybrid', styles = { sidebar = 'steel' } })
	eq('#101926', hex(hl('NeoTreeNormal').bg))
	eq('#101926', hex(hl('NeoTreeNormalNC').bg))
	eq('#101926', hex(hl('TroubleNormal').bg))
	eq('#101926', hex(hl('DapUINormal').bg))
end)

test('status line plugins sit on the status line', function()
	load({ theme = 'hybrid' })
	eq('#2d3034', hex(hl('NavicText').bg))
	eq('#f0c674', hex(hl('NavicIconsFunction').fg))
	eq('#2d3034', hex(hl('NavicIconsFunction').bg))
	eq('#685d47', hex(hl('MiniStatuslineModeInsert').bg))
end)

test('other integrations use their roles', function()
	load({ theme = 'hybrid' })
	eq('#282a2e', hex(hl('RenderMarkdownCode').bg))
	eq('#3d382d', hex(hl('RenderMarkdownH1Bg').bg))
	eq('#8abeb7', hex(hl('MiniIconsAzure').fg))
	eq('#b294bb', hex(hl('MiniIconsPurple').fg))
	eq('#7aa6a0', hex(hl('MarkSignHL').fg))
	eq('#b294bb', hex(hl('RainbowDelimiterViolet').fg))
	eq('#18191a', hex(hl('WhichKeyFloat').bg))
	eq('#bb7e54', hex(hl('MiniJump2dSpotAhead').fg))
end)

test('a transparent status line still colors mini.statusline modes', function()
	load({ theme = 'night', styles = { statusline = 'transparent' } })
	eq('#5c513a', hex(hl('MiniStatuslineModeInsert').bg))
end)

test('status line text stays readable on a light status line', function()
	-- hybrid upstream's reversed status line
	load({
		theme = 'hybrid',
		styles = {
			statusline = {
				bg = '#707880',
				fg = '#1d1f21',
				bg_nc = '#303030',
				fg_nc = '#707880',
			},
		},
	})
	eq('#707880', hex(hl('WinBarNC').fg))
	eq('#303030', hex(hl('WinBarNC').bg))
	eq('#363a3e', hex(hl('NavicText').fg))
	eq('#363a3e', hex(hl('NavicSeparator').fg))
	load({ theme = 'night' })
	eq('#969998', hex(hl('NavicText').fg))
end)

test("diff and gitsigns groups use the theme's fg pairs", function()
	load({ theme = 'night' })
	eq('#3b4650', hex(hl('GitSignsChangeInline').bg))
	load({ theme = 'hybrid' })
	eq('#1d1f21', hex(hl('diffRemoved').fg))
	eq('#cc6666', hex(hl('diffRemoved').bg))
	eq('#1d1f21', hex(hl('GitSignsDeleteInline').fg))
	eq('#81a2be', hex(hl('GitSignsDeleteInline').bg))
end)

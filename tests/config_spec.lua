-- Config: defaults, setup() merging and per-load extension.

test('defaults use the night theme and no element styles', function()
	fresh()
	local Config = require('morrow.config')
	eq('night', Config.defaults.theme)
	eq(false, Config.defaults.transparent)
	eq(true, Config.defaults.terminal_colors)
	eq(
		{ comments = {}, keywords = {}, functions = {}, variables = {} },
		Config.defaults.styles
	)
	eq(true, Config.defaults.plugins.auto)
	-- Neither lazy.nvim nor vim.pack is loaded in the test Neovim.
	eq(true, Config.defaults.plugins.all)
end)

test('options are the defaults before setup', function()
	for name in pairs(package.loaded) do
		if name:match('^morrow') then
			package.loaded[name] = nil
		end
	end
	local Config = require('morrow.config')
	eq('night', Config.options.theme)
end)

test('setup merges user options over the defaults', function()
	fresh({ theme = 'hybrid', styles = { statusline = 'olive' } })
	local Config = require('morrow.config')
	eq('hybrid', Config.options.theme)
	eq('olive', Config.options.styles.statusline)
	eq({}, Config.options.styles.comments)
end)

test('extend overrides per load without changing options', function()
	fresh()
	local Config = require('morrow.config')
	local opts = Config.extend({ theme = 'rafi' })
	eq('rafi', opts.theme)
	eq('night', Config.options.theme)
	eq(Config.options, Config.extend())
end)

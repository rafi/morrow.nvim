-- Group files: shape and the merge in groups/init.lua.

test('every group file returns a table of groups', function()
	fresh()
	local c, opts = require('morrow.themes').setup()
	local dir = ROOT .. '/lua/morrow/groups'
	for _, file in ipairs(vim.fn.globpath(dir, '*.lua', false, true)) do
		local name = vim.fn.fnamemodify(file, ':t:r')
		if name ~= 'init' then
			local mod = require('morrow.groups.' .. name)
			eq('table', type(mod.get(c, opts)), name)
		end
	end
end)

test('core groups come first and always load', function()
	fresh({ plugins = { all = false, auto = false } })
	local names = require('morrow.groups').names(require('morrow.config').options)
	eq({ 'base', 'kinds', 'semantic_tokens', 'treesitter' }, names)
end)

test('kinds link to syntax groups and navic gets colors', function()
	fresh({ theme = 'hybrid' })
	local Kinds = require('morrow.groups.kinds')
	local ret = Kinds.kinds({}, 'BlinkCmpKind%s')
	eq('LspKindFunction', ret.BlinkCmpKindFunction)
	eq('@function', Kinds.links.Function)
	local c = require('morrow.themes').setup()
	eq('#f0c674', Kinds.colors(c).Function)
end)

test('the plugin map and the group files match', function()
	fresh()
	local Groups = require('morrow.groups')
	local files = {}
	for _, file in
		ipairs(vim.fn.globpath(ROOT .. '/lua/morrow/groups', '*.lua', false, true))
	do
		files[vim.fn.fnamemodify(file, ':t:r')] = true
	end
	files.init = nil
	for _, name in ipairs(Groups.core) do
		files[name] = nil
	end
	local mapped = {}
	for plugin, group in pairs(Groups.plugins) do
		assert(
			files[group],
			plugin .. ' maps to missing groups/' .. group .. '.lua'
		)
		mapped[group] = true
	end
	for name in pairs(files) do
		assert(mapped[name], 'groups/' .. name .. '.lua is not in M.plugins')
	end
	eq(42, vim.tbl_count(Groups.plugins))
end)

local function names(plugins)
	fresh({ plugins = plugins })
	local list = require('morrow.groups').names(require('morrow.config').options)
	local set = {}
	for _, name in ipairs(list) do
		set[name] = true
	end
	return set, list
end

test('all enables every integration, explicit false disables one', function()
	local set = names({ all = true, snacks = false })
	eq(true, set.blink)
	eq(nil, set.snacks)
	set = names({ all = true, ['snacks.nvim'] = false })
	eq(nil, set.snacks)
	set = names({ all = true, snacks = { enabled = false } })
	eq(nil, set.snacks)
end)

test('explicit true enables one integration without all', function()
	local set, list = names({ all = false, auto = false, telescope = true })
	eq(true, set.telescope)
	eq(5, #list)
end)

test('auto asks lazy.nvim which plugins are installed', function()
	package.loaded.lazy = {}
	package.loaded['lazy.core.config'] =
		{ plugins = { ['blink.cmp'] = {}, ['mini.nvim'] = {} } }
	local ok, set = pcall(names, { all = false, auto = true })
	package.loaded.lazy = nil
	package.loaded['lazy.core.config'] = nil
	assert(ok, set)
	eq(true, set.blink)
	eq(true, set.mini_icons) -- mini.nvim enables every mini_* file
	eq(nil, set.snacks)
end)

test('auto asks vim.pack when it is loaded', function()
	local orig = rawget(vim, 'pack')
	local orig_loaded = package.loaded['vim.pack']
	rawset(vim, 'pack', {
		get = function()
			return { { spec = { name = 'snacks.nvim' } } }
		end,
	})
	package.loaded['vim.pack'] = vim.pack
	local ok, set = pcall(names, { all = false, auto = true })
	rawset(vim, 'pack', orig)
	package.loaded['vim.pack'] = orig_loaded
	assert(ok, set)
	eq(true, set.snacks)
	eq(nil, set.blink)
end)

test('auto without a plugin manager enables nothing extra', function()
	local _, list = names({ all = false, auto = true })
	eq({ 'base', 'kinds', 'semantic_tokens', 'treesitter' }, list)
end)

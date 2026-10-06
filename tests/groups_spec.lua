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

test('kinds link to syntax groups and navic gets colors', function()
	fresh({ theme = 'hybrid' })
	local Kinds = require('morrow.groups.kinds')
	local ret = Kinds.kinds({}, 'BlinkCmpKind%s')
	eq('LspKindFunction', ret.BlinkCmpKindFunction)
	eq('@function', Kinds.links.Function)
	local c = require('morrow.themes').setup()
	eq('#f0c674', Kinds.colors(c).Function)
end)

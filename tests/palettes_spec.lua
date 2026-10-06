-- Palette files: the tinted gray ramps element styles pick from.

test('palettes hold the 10 tinted gray steps', function()
	local steps = {
		'crust',
		'mantle',
		'surface0',
		'surface1',
		'surface2',
		'overlay0',
		'overlay1',
		'overlay2',
		'subtext0',
		'subtext1',
	}
	for _, name in ipairs({ 'olive', 'neutral', 'slate', 'steel' }) do
		local p = require('morrow.palettes.' .. name)
		eq(10, vim.tbl_count(p), name)
		for _, step in ipairs(steps) do
			assert(
				type(p[step]) == 'string' and p[step]:match('^#%x%x%x%x%x%x$'),
				name .. '.' .. step
			)
		end
	end
	eq('#272a2f', require('morrow.palettes.slate').surface0)
	eq('#666656', require('morrow.palettes.olive').overlay0)
end)

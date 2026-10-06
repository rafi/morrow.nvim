-- Lualine theme for a morrow theme: every section sits on the status line
-- background, and mode colors are accents blended into it, so a palette
-- or literal status line style carries over.

local M = {}

---@param theme? string theme name; the configured theme when nil
---@return table
function M.get(theme)
	local Util = require('morrow.util')
	local c, opts =
		require('morrow.themes').setup(theme and { theme = theme } or nil)
	local stl = c.statusline

	-- An accent (or the background) blended into the status line; over
	-- the editor background when the status line has none.
	local stl_bg = stl.bg ~= 'NONE' and stl.bg or c.base
	local function fade(color, amount)
		return Util.blend(color, amount or 0.3, stl_bg)
	end
	-- Dim text: the status line's fg faded toward its background, readable
	-- on light and dark status lines.
	local dim = fade(stl.fg, 0.7)

	local trans = opts.transparent
	local tbg = trans and 'NONE' or stl.bg
	local tbg_nc = trans and 'NONE' or (stl.bg_nc or stl.bg)
	local tbgy = trans and 'NONE' or fade(c.base, 0.5)
	local tbgz = trans and 'NONE' or fade(c.base, -1.5)

	return {
		normal = {
			a = { bg = tbg, fg = stl.fg },
			b = { bg = tbg, fg = stl.fg },
			c = { bg = tbg, fg = stl.fg },
			x = { bg = tbg, fg = dim },
			y = { bg = tbgy, fg = stl.fg },
			z = { bg = tbgz, fg = stl.fg },
		},
		insert = { z = { bg = fade(c.yellow), fg = stl.fg } },
		command = { z = { bg = fade(c.blue), fg = stl.fg } },
		visual = { z = { bg = fade(c.magenta), fg = stl.fg } },
		replace = { z = { bg = fade(c.red), fg = stl.fg } },
		terminal = {
			a = { bg = tbg, fg = stl.fg, gui = 'bold' },
			c = { bg = fade(c.yellow, 0.2), fg = c.text },
		},
		inactive = {
			a = { bg = tbg_nc, fg = stl.fg_nc },
			z = { bg = tbg_nc, fg = stl.fg_nc },
		},
	}
end

return M

local Util = require('morrow.util')

local M = {}

M.url = 'https://github.com/nvim-mini/mini.statusline'

-- Mode colors are accents blended into the status line, as in the
-- bundled lualine theme.
---@type morrow.HighlightsFn
function M.get(c)
	local stl = c.statusline
	-- Over the editor background when the status line has none.
	local stl_bg = stl.bg ~= 'NONE' and stl.bg or c.base
	local function fade(color, amount)
		return Util.blend(color, amount or 0.3, stl_bg)
	end
	-- stylua: ignore
	return {
		MiniStatuslineModeNormal  = { fg = stl.fg, bg = fade(c.base, -1.5) },
		MiniStatuslineModeInsert  = { fg = stl.fg, bg = fade(c.yellow) },
		MiniStatuslineModeVisual  = { fg = stl.fg, bg = fade(c.magenta) },
		MiniStatuslineModeReplace = { fg = stl.fg, bg = fade(c.red) },
		MiniStatuslineModeCommand = { fg = stl.fg, bg = fade(c.blue) },
		MiniStatuslineModeOther   = { fg = stl.fg, bg = fade(c.cyan) },
	}
end

return M

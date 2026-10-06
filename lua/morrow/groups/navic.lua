local Util = require('morrow.util')

local M = {}

M.url = 'https://github.com/SmiteshP/nvim-navic'

-- navic draws in the status line, so text and icons carry its background.
---@type morrow.HighlightsFn
function M.get(c)
	local stl = c.statusline
	-- Dim text: the status line's fg blended 0.7 toward its background (the
	-- editor's when it has none), readable on light and dark status lines.
	local dim = Util.blend(stl.fg, 0.7, stl.bg ~= 'NONE' and stl.bg or c.base)
	local ret = {
		NavicText = { fg = dim, bg = stl.bg },
		NavicSeparator = { fg = dim, bg = stl.bg },
	}
	for kind, fg in pairs(require('morrow.groups.kinds').colors(c)) do
		ret['NavicIcons' .. kind] = { fg = fg, bg = stl.bg }
	end
	return ret
end

return M

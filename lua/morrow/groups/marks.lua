local Util = require('morrow.util')

local M = {}

M.url = 'https://github.com/chentau/marks.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	return {
		MarkSignHL = { fg = Util.blend(c.cyan, 0.85, c.base) },
	}
end

return M

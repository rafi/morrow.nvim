local Util = require('morrow.util')

local M = {}

M.url = 'https://github.com/nvim-mini/mini.jump2d'

---@type morrow.HighlightsFn
function M.get(c)
	-- stylua: ignore
	return {
		MiniJump2dSpot       = { fg = c.orange, bold = true, nocombine = true },
		MiniJump2dSpotUnique = { fg = c.yellow, bold = true, nocombine = true },
		MiniJump2dSpotAhead  = { fg = Util.blend(c.orange, 0.82, c.base), nocombine = true },
	}
end

return M

local Util = require('morrow.util')

local M = {}

M.url = 'https://github.com/folke/lazy.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	-- stylua: ignore
	return {
		LazyButtonActive = { bg = Util.blend_bg(c.diag.ok, 0.2) },
		LazyDimmed       = { fg = c.overlay2 },
		LazyProp         = 'Comment',
		LazySpecial      = { fg = Util.blend(c.green, 0.82, c.base) },
		LazyReasonEvent  = { fg = c.blue },
		LazyReasonKeys   = { fg = c.overlay1 },
		LazyReasonPlugin = { fg = c.syntax.comment },
		LazyReasonSource = { fg = c.magenta },
		LazyReasonFt     = { fg = c.subtext0 },
		LazyReasonCmd    = { fg = c.cyan },
	}
end

return M

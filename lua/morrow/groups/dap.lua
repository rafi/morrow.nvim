local Util = require('morrow.util')

local M = {}

M.url = 'https://github.com/mfussenegger/nvim-dap'

---@type morrow.HighlightsFn
function M.get(c)
	local d = c.diag
	-- stylua: ignore
	return {
		DapBreakpoint          = { fg = d.error },
		DapBreakpointCondition = { fg = d.warn },
		DapBreakpointRejected  = { fg = c.syntax.comment },
		DapLogPoint            = { fg = d.info },
		DapStopped             = { fg = d.warn },
		DapStoppedLine         = { bg = Util.blend_bg(d.warn, 0.2) },
	}
end

return M

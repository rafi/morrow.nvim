local Util = require('morrow.util')

local M = {}

M.url = 'https://github.com/lukas-reineke/headlines.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	return {
		Headline = { bg = Util.blend(c.syntax.heading[1], 0.15, c.base) },
		CodeBlock = { bg = c.code.bg },
	}
end

return M

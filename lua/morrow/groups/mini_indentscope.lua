local M = {}

M.url = 'https://github.com/nvim-mini/mini.indentscope'

---@type morrow.HighlightsFn
function M.get(c)
	return {
		MiniIndentscopeSymbol = { fg = c.indent.scope },
	}
end

return M

local M = {}

M.url = 'https://github.com/nvim-treesitter/nvim-treesitter-context'

---@type morrow.HighlightsFn
function M.get(c)
	return {
		TreesitterContextBottom = { sp = c.overlay0, underline = true },
		TreesitterContextLineNumberBottom = { sp = c.overlay0, underline = true },
	}
end

return M

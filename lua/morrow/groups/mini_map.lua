local M = {}

M.url = 'https://github.com/nvim-mini/mini.map'

---@type morrow.HighlightsFn
function M.get(c)
	return {
		MiniMapNormal = 'Comment',
		MiniMapSymbolLine = { fg = c.surface2 },
		MiniMapSymbolView = { fg = c.surface2 },
	}
end

return M

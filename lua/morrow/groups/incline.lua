local M = {}

M.url = 'https://github.com/b0o/incline.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	return {
		InclineNormal = { fg = c.text, bg = c.surface0 },
		InclineNormalNC = { fg = c.syntax.comment, bg = c.surface0 },
	}
end

return M

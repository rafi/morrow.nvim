local M = {}

M.url = 'https://github.com/rafi/tabstrip.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	return {
		TabLineProject = { fg = c.text, bg = c.surface2 },
	}
end

return M

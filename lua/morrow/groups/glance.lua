local M = {}

M.url = 'https://github.com/dnlhc/glance.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	return {
		GlanceListMatch = { bg = c.surface1 },
		GlanceListFilepath = { fg = c.overlay2 },
	}
end

return M

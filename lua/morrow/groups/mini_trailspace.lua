local M = {}

M.url = 'https://github.com/nvim-mini/mini.trailspace'

---@type morrow.HighlightsFn
function M.get(c)
	return {
		-- The default links to Error, which has no background in morrow,
		-- so trailing spaces would be invisible.
		MiniTrailspace = { bg = c.red },
	}
end

return M

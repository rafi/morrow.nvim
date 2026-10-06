local M = {}

M.url = 'https://github.com/MagicDuck/grug-far.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	return {
		GrugFarResultsPath = { fg = c.blue },
	}
end

return M

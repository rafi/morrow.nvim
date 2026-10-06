local M = {}

M.url = 'https://codeberg.org/andyg/leap.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	return {
		LeapLabel = { fg = c.base, bg = c.green, bold = true, nocombine = true },
		LeapMatch = { fg = c.green, underline = true, nocombine = true },
	}
end

return M

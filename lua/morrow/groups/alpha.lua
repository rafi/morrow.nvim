local M = {}

M.url = 'https://github.com/goolord/alpha-nvim'

---@type morrow.HighlightsFn
function M.get()
	-- stylua: ignore
	return {
		AlphaHeader   = 'Type',
		AlphaShortcut = 'Constant',
		AlphaButtons  = 'Keyword',
		AlphaFooter   = 'Comment',
	}
end

return M

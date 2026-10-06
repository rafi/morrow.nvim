local M = {}

M.url = 'https://github.com/stevearc/aerial.nvim'

---@type morrow.HighlightsFn
function M.get()
	return require('morrow.groups.kinds').kinds({}, 'Aerial%sIcon')
end

return M

local M = {}

M.url = 'https://github.com/RRethy/vim-illuminate'

---@type morrow.HighlightsFn
function M.get()
	return {
		illuminatedWordText = 'LspReferenceText',
		illuminatedWordRead = 'LspReferenceRead',
		illuminatedWordWrite = 'LspReferenceWrite',
	}
end

return M

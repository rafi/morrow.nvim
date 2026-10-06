local M = {}

M.url = 'https://github.com/nvim-mini/mini.cursorword'

---@type morrow.HighlightsFn
function M.get()
	return {
		MiniCursorword = 'LspReferenceText', -- same as LSP references
	}
end

return M

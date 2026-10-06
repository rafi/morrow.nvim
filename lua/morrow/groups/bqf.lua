local M = {}

M.url = 'https://github.com/kevinhwang91/nvim-bqf'

---@type morrow.HighlightsFn
function M.get()
	return {
		BqfPreviewBorder = 'FloatBorder',
		BqfPreviewCursor = 'TermCursor',
	}
end

return M

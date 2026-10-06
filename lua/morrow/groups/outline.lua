local M = {}

M.url = 'https://github.com/hedyhli/outline.nvim'

-- outline.nvim has no window group; set its winhl to 'Normal:NormalSB'
-- for the sidebar style.
---@type morrow.HighlightsFn
function M.get()
	return {
		OutlineFoldMarker = 'Comment',
	}
end

return M

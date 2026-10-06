local M = {}

M.url = 'https://github.com/akinsho/bufferline.nvim'

---@type morrow.HighlightsFn
function M.get(c, opts)
	return {
		-- Dimmer text than bufferline's Normal fg. The bg must be restated:
		-- without it the label falls through to TabLineFill, which differs
		-- from the selected tab's edges when the tab line is raised.
		BufferLineBufferSelected = {
			fg = c.subtext0,
			bg = opts.transparent and c.none or c.base,
		},
	}
end

return M

local M = {}

M.url = 'https://github.com/folke/noice.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	local comment = c.syntax.comment
	-- stylua: ignore
	return {
		NoiceLspProgressTitle = { fg = comment },
		NoiceFormatEvent      = { fg = comment },
		NoiceFormatKind       = { fg = comment },
		NoiceFormatLevelDebug = { fg = comment },
		NoiceFormatLevelOff   = { fg = comment },
		NoiceFormatLevelTrace = { fg = comment },
	}
end

return M

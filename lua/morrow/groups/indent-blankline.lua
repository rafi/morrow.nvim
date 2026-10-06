local M = {}

M.url = 'https://github.com/lukas-reineke/indent-blankline.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	return {
		IblScope = { fg = c.indent.scope, nocombine = true },
		IblIndent = { fg = c.indent.fg, nocombine = true },
		IblWhitespace = 'NonText',
	}
end

return M

local M = {}

M.url = 'https://github.com/hrsh7th/nvim-cmp'

---@type morrow.HighlightsFn
function M.get(c)
	local syn = c.syntax
	-- stylua: ignore
	local ret = {
		CmpDocumentation       = { fg = c.text, bg = c.float.bg },
		CmpDocumentationBorder = { fg = c.float.border, bg = c.float.bg },
		CmpItemAbbr            = { fg = c.text },
		CmpItemAbbrDeprecated  = { fg = syn.deprecated, strikethrough = true },
		CmpItemAbbrMatch       = { fg = syn.keyword },
		CmpItemAbbrMatchFuzzy  = { fg = syn.func },
		CmpItemMenu            = 'Comment',
	}
	return require('morrow.groups.kinds').kinds(ret, 'CmpItemKind%s')
end

return M

local M = {}

M.url = 'https://github.com/folke/which-key.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	-- stylua: ignore
	return {
		WhichKey          = 'Identifier',
		WhichKeyGroup     = 'Function',
		WhichKeyDesc      = 'Keyword',
		WhichKeySeperator = 'Comment',
		WhichKeySeparator = 'Comment',
		WhichKeyFloat     = { bg = c.float.bg },
		WhichKeyValue     = 'Comment',
	}
end

return M

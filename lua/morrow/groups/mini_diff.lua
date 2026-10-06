local M = {}

M.url = 'https://github.com/nvim-mini/mini.diff'

---@type morrow.HighlightsFn
function M.get(c)
	-- stylua: ignore
	return {
		MiniDiffSignAdd    = { fg = c.git.sign.add }, -- same as gitsigns
		MiniDiffSignChange = { fg = c.git.sign.change },
		MiniDiffSignDelete = { fg = c.git.sign.delete },
	}
end

return M

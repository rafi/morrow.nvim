local M = {}

M.url = 'https://github.com/nvim-lualine/lualine.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	-- stylua: ignore
	return {
		LuaLineDiffAdd    = { fg = c.git.sign.add },
		LuaLineDiffChange = { fg = c.git.sign.change },
		LuaLineDiffDelete = { fg = c.git.sign.delete },
	}
end

return M

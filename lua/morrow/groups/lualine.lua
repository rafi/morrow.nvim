local Util = require('morrow.util')

local M = {}

M.url = 'https://github.com/nvim-lualine/lualine.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	local stl = c.statusline
	-- LuaLineLspStatus is for the lsp_status component, which sits in a
	-- dimmed section. Cyan softened toward the status line's background (the
	-- editor's when it has none) stays readable without outshining the file
	-- name. A config opts in with `color = { fg = <this group's fg> }`.
	local lsp = Util.blend(c.cyan, 0.6, stl.bg ~= 'NONE' and stl.bg or c.base)
	-- stylua: ignore
	return {
		LuaLineDiffAdd    = { fg = c.git.sign.add },
		LuaLineDiffChange = { fg = c.git.sign.change },
		LuaLineDiffDelete = { fg = c.git.sign.delete },
		LuaLineLspStatus  = { fg = lsp },
	}
end

return M

local M = {}

M.url = 'https://github.com/folke/trouble.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	-- stylua: ignore
	return {
		TroubleNormal   = { fg = c.text, bg = c.sidebar.bg },
		TroubleNormalNC = { fg = c.text, bg = c.sidebar.bg },
		TroubleText     = { fg = c.text },
		TroublePos      = { fg = c.syntax.comment },
		TroubleCount    = { fg = c.magenta, bg = c.surface1 },
	}
end

return M

local M = {}

M.url = 'https://github.com/rcarriga/nvim-dap-ui'

---@type morrow.HighlightsFn
function M.get(c)
	-- stylua: ignore
	return {
		DapUINormal       = 'NormalSB', -- dap-ui windows are sidebars
		DapUIFloatBorder  = 'FloatBorder',
		DapUILineNumber   = { fg = c.syntax.comment },
		DapUIWatchesError = { fg = c.diag.error },
		DapUIPlayPause    = { fg = c.green },
		DapUIPlayPauseNC  = { fg = c.green },
		DapUIRestart      = { fg = c.green },
		DapUIRestartNC    = { fg = c.green },
		DapUIStop         = { fg = c.red },
		DapUIStopNC       = { fg = c.red },
	}
end

return M

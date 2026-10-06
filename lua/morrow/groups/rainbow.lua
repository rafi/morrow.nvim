local M = {}

M.url = 'https://github.com/hiphish/rainbow-delimiters.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	local rb = c.rainbow
	-- stylua: ignore
	return {
		RainbowDelimiterBlue   = { fg = rb.blue },
		RainbowDelimiterCyan   = { fg = rb.cyan },
		RainbowDelimiterGreen  = { fg = rb.green },
		RainbowDelimiterOrange = { fg = rb.orange },
		RainbowDelimiterRed    = { fg = rb.red },
		RainbowDelimiterViolet = { fg = rb.violet },
		RainbowDelimiterYellow = { fg = rb.yellow },
	}
end

return M

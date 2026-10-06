local M = {}

M.url = 'https://github.com/nvim-mini/mini.icons'

-- The defaults link to syntax groups whose colors don't match the icon
-- color names, so each name gets the accent it says.
---@type morrow.HighlightsFn
function M.get(c)
	-- stylua: ignore
	return {
		MiniIconsAzure  = { fg = c.cyan },
		MiniIconsBlue   = { fg = c.blue },
		MiniIconsCyan   = { fg = c.cyan },
		MiniIconsGreen  = { fg = c.green },
		MiniIconsGrey   = { fg = c.overlay2 },
		MiniIconsOrange = { fg = c.orange },
		MiniIconsPurple = { fg = c.magenta },
		MiniIconsRed    = { fg = c.red },
		MiniIconsYellow = { fg = c.yellow },
	}
end

return M

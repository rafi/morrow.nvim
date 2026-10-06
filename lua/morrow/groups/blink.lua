local M = {}

M.url = 'https://github.com/Saghen/blink.cmp'

---@type morrow.HighlightsFn
function M.get(c)
	local syn = c.syntax
	-- stylua: ignore
	local ret = {
		BlinkCmpGhostText        = { fg = c.overlay0 }, -- like ComplHint, below comments
		-- Same label styles as nvim-cmp's CmpItemAbbr* groups.
		BlinkCmpLabelMatch       = { fg = syn.keyword },
		BlinkCmpLabelDeprecated  = { fg = syn.deprecated, strikethrough = true },
		BlinkCmpLabelDetail      = { fg = syn.comment },
		BlinkCmpLabelDescription = { fg = syn.comment },
		BlinkCmpSource           = { fg = syn.comment },
		-- The menu keeps Pmenu's background, so its border uses pmenu's.
		BlinkCmpMenuBorder          = { fg = c.pmenu.border, bg = c.pmenu.bg },
		-- Documentation and signature windows are floats.
		BlinkCmpDocBorder           = 'FloatBorder',
		BlinkCmpDocSeparator        = 'FloatBorder',
		BlinkCmpSignatureHelpBorder = 'FloatBorder',
		BlinkCmpKind                = { fg = c.blue },
	}
	return require('morrow.groups.kinds').kinds(ret, 'BlinkCmpKind%s')
end

return M

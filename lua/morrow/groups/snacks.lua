local M = {}

M.url = 'https://github.com/folke/snacks.nvim'

-- The picker's list, input, preview and box windows link to SnacksPicker*
-- by default, so coloring these three styles every picker window (the
-- explorer included).
---@type morrow.HighlightsFn
function M.get(c)
	local comment = c.syntax.comment
	-- stylua: ignore
	return {
		SnacksPicker                   = { fg = c.text, bg = c.picker.bg },
		SnacksPickerBorder             = { fg = c.picker.border, bg = c.picker.bg },
		SnacksPickerTitle              = { fg = c.picker.title, bg = c.picker.bg },
		SnacksIndent                   = { fg = c.indent.fg, nocombine = true },
		SnacksIndentScope              = { fg = c.indent.scope, nocombine = true },
		-- Tree guides default to LineNr, whose gutter bg paints over the
		-- cursor line.
		SnacksPickerTree               = { fg = c.gutter.fg },
		SnacksPickerDir                = 'Comment',
		SnacksPickerMatch              = 'WildMenu',
		SnacksPickerGitStatusModified  = { fg = c.git.change },
		SnacksPickerGitStatusUntracked = 'Comment',
		SnacksPickerGitStatusStaged    = { fg = c.git.add },
		SnacksPickerPathHidden         = { fg = c.overlay2 },
		-- Ignored paths default to NonText, too dark to read.
		SnacksPickerPathIgnored        = { fg = comment },
		SnacksPickerGitStatusIgnored   = { fg = comment },
		-- Debug and trace notifications default to NonText.
		SnacksNotifierIconDebug        = { fg = comment },
		SnacksNotifierTitleDebug       = { fg = comment },
		SnacksNotifierBorderDebug      = { fg = comment },
		SnacksNotifierFooterDebug      = { fg = comment },
		SnacksNotifierIconTrace        = { fg = c.magenta },
		SnacksNotifierTitleTrace       = { fg = c.magenta },
		SnacksNotifierBorderTrace      = { fg = c.magenta },
		SnacksNotifierFooterTrace      = { fg = c.magenta },
		-- Dashboard, same roles as alpha-nvim.
		SnacksDashboardHeader          = 'Type',
		SnacksDashboardKey             = 'Constant',
		SnacksDashboardDesc            = 'Keyword',
		SnacksDashboardIcon            = 'Keyword',
		SnacksDashboardFooter          = 'Comment',
		SnacksDashboardDir             = 'Comment',
	}
end

return M

local M = {}

M.url = 'https://github.com/lewis6991/gitsigns.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	-- stylua: ignore
	return {
		GitSignsAdd           = { fg = c.git.sign.add },
		GitSignsChange        = { fg = c.git.sign.change },
		GitSignsDelete        = { fg = c.git.sign.delete },
		GitSignsAddInline     = { fg = c.diff.add_fg or c.text, bg = c.diff.text_add },
		GitSignsDeleteInline  = { fg = c.diff.text_fg, bg = c.diff.text },
		GitSignsChangeInline  = { fg = c.diff.text_fg or c.text, bg = c.diff.text },
		GitSignsAddPreview    = { fg = c.diff.add_fg or c.subtext1, bg = c.diff.add },
		GitSignsChangePreview = { fg = c.diff.change_fg or c.text, bg = c.diff.change },
		GitSignsDeletePreview = { fg = c.diff.delete_fg, bg = c.diff.delete },
	}
end

return M

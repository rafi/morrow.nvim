local M = {}

M.url = 'https://github.com/nvim-telescope/telescope.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	-- stylua: ignore
	return {
		TelescopeNormal         = { fg = c.text, bg = c.picker.bg },
		TelescopeBorder         = { fg = c.picker.border, bg = c.picker.bg },
		TelescopeTitle          = { fg = c.picker.title, bg = c.picker.bg },
		TelescopeSelectionCaret = { fg = c.magenta, bg = c.selection },
		TelescopeSelection      = 'WildMenu',
		TelescopePreviewLine    = 'WildMenu',
		TelescopeMatching       = 'Search',
	}
end

return M

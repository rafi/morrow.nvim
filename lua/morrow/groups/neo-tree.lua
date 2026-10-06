local Util = require('morrow.util')

local M = {}

M.url = 'https://github.com/nvim-neo-tree/neo-tree.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	-- stylua: ignore
	return {
		NeoTreeNormal             = { fg = c.text, bg = c.sidebar.bg },
		NeoTreeNormalNC           = { fg = c.text, bg = c.sidebar.bg },
		NeoTreeIndentMarker       = { fg = c.surface2 },
		NeoTreeCursorLine         = 'WildMenu',
		NeoTreeRootName           = { fg = c.text, bold = true },
		NeoTreeDirectoryName      = { fg = c.blue },
		NeoTreeDirectoryIcon      = { fg = c.blue },
		NeoTreeDotfile            = { fg = Util.blend(c.blue, 0.82, c.base) },
		NeoTreeSymbolicLinkTarget = { fg = c.red },
		NeoTreeFileName           = { fg = c.subtext0 },
		NeoTreeFileNameOpened     = { fg = c.overlay2 },
		NeoTreeDimText            = 'Conceal',
		NeoTreeGitAdded           = { fg = c.git.add },
		NeoTreeGitModified        = { fg = c.git.change },
		NeoTreeGitDeleted         = { fg = c.git.delete },
		NeoTreeGitConflict        = { fg = c.orange, italic = true },
		NeoTreeGitIgnored         = { fg = c.overlay2 },
		NeoTreeGitUntracked       = { fg = Util.blend(c.overlay1, 0.65, c.base) },
	}
end

return M

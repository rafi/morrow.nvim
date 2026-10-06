local M = {}

M.url = 'https://github.com/nvim-mini/mini.hipatterns'

---@type morrow.HighlightsFn
function M.get(c)
	local d = c.diag
	-- Same colors as Tree-sitter's @comment.error/warning/todo/note.
	-- stylua: ignore
	return {
		MiniHipatternsFixme = { fg = c.base, bg = d.error },
		MiniHipatternsHack  = { fg = c.base, bg = d.warn },
		MiniHipatternsTodo  = { fg = c.base, bg = d.hint },
		MiniHipatternsNote  = { fg = c.base, bg = d.info },
	}
end

return M

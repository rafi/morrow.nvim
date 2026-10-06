local M = {}

M.url = 'https://github.com/zbirenbaum/copilot.lua'

---@type morrow.HighlightsFn
function M.get(c)
	return {
		CopilotSuggestion = { fg = c.overlay0 }, -- ghost text, below comments
	}
end

return M

local M = {}

M.url = 'https://github.com/utilyre/barbecue.nvim'

---@type morrow.HighlightsFn
function M.get()
	local ret = {}
	-- barbecue names its kind groups in lower case.
	for kind in pairs(require('morrow.groups.kinds').links) do
		ret['barbecue_context_' .. kind:lower()] = 'LspKind' .. kind
	end
	return ret
end

return M

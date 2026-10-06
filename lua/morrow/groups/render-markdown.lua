local Util = require('morrow.util')

local M = {}

M.url = 'https://github.com/MeanderingProgrammer/render-markdown.nvim'

---@type morrow.HighlightsFn
function M.get(c)
	local syn = c.syntax
	-- stylua: ignore
	local ret = {
		RenderMarkdownBullet     = { fg = c.brown },
		RenderMarkdownCode       = { bg = c.code.bg },
		RenderMarkdownCodeInline = '@markup.raw.markdown_inline',
		RenderMarkdownDash       = { fg = c.orange },
		RenderMarkdownTableHead  = { fg = c.red },
		RenderMarkdownTableRow   = { fg = c.brown },
	}
	-- Heading text in the heading colors, on a faint wash of the same.
	for level, color in ipairs(syn.heading) do
		ret['RenderMarkdownH' .. level] = { fg = color, bold = true }
		ret['RenderMarkdownH' .. level .. 'Bg'] =
			{ bg = Util.blend(color, 0.15, c.base) }
	end
	return ret
end

return M

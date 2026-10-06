-- Tree-sitter capture groups, colored from the theme's syntax roles.

local M = {}

---@type morrow.HighlightsFn
function M.get(c, opts)
	local syn = c.syntax
	local d = c.diag
	local stl = opts.styles

	-- stylua: ignore
	local hl = {
		-- Identifiers
		['@variable']                   = { fg = syn.variable, style = stl.variables },
		['@variable.builtin']           = { fg = syn.variable_builtin },
		['@variable.parameter']         = { fg = syn.parameter },
		['@variable.parameter.builtin'] = { fg = syn.variable_builtin },
		['@variable.member']            = { fg = syn.member },
		['@constant']                   = 'Constant',
		['@constant.builtin']           = { fg = syn.const_builtin },
		['@constant.macro']             = 'Macro',
		['@module']                     = { fg = syn.module },
		['@module.builtin']             = { fg = syn.builtin },
		['@label']                      = 'Label',

		-- Literals
		['@string']                 = 'String',
		['@string.documentation']   = 'String',
		['@string.regexp']          = { fg = syn.regex },
		['@string.escape']          = { fg = syn.escape, bold = true },
		['@string.special']         = 'Special',
		['@string.special.url']     = { fg = syn.url, italic = true, underline = true },
		['@character']              = 'Character',
		['@character.special']      = { fg = syn.escape },
		['@character.printf']       = { fg = syn.escape },
		['@boolean']                = 'Boolean',
		['@number']                 = 'Number',
		['@number.float']           = 'Float',

		-- Types
		['@type']                   = 'Type',
		['@type.builtin']           = { fg = syn.type_builtin },
		['@type.definition']        = 'Type',
		['@attribute']              = { fg = syn.attribute },
		['@property']               = { fg = syn.property },

		-- Functions
		['@function']               = 'Function',
		['@function.builtin']       = { fg = syn.builtin, style = stl.functions },
		['@function.macro']         = { fg = syn.preproc },
		['@constructor']            = { fg = syn.constructor },
		['@operator']               = 'Operator',

		-- Keywords
		['@keyword']                     = 'Keyword',
		['@keyword.coroutine']           = 'Keyword',
		['@keyword.function']            = { fg = syn.keyword, style = stl.keywords },
		['@keyword.operator']            = { fg = syn.operator },
		['@keyword.import']              = 'Include',
		['@keyword.storage']             = 'StorageClass',
		['@keyword.repeat']              = 'Repeat',
		['@keyword.return']              = { fg = syn.keyword_return, style = stl.keywords },
		['@keyword.debug']               = 'Keyword',
		['@keyword.exception']           = 'Exception',
		['@keyword.conditional']         = 'Conditional',
		['@keyword.conditional.ternary'] = 'Conditional',
		['@keyword.directive']           = 'PreProc',
		['@keyword.directive.define']    = 'PreProc',

		-- Punctuation
		['@punctuation.delimiter'] = { fg = syn.punct },
		['@punctuation.bracket']   = { fg = syn.punct },
		['@punctuation.special']   = { fg = syn.punct_special },

		-- Comments
		['@comment']         = 'Comment',
		['@comment.error']   = { fg = c.base, bg = d.error },
		['@comment.warning'] = { fg = c.base, bg = d.warn },
		['@comment.todo']    = { fg = c.base, bg = d.hint },
		['@comment.note']    = { fg = c.base, bg = d.info },
		['@comment.hint']    = { fg = c.base, bg = d.hint },
		['@comment.info']    = { fg = c.base, bg = d.info },

		-- Markup
		['@markup']                = { fg = c.text },
		['@markup.strong']         = { fg = syn.strong, bold = true },
		['@markup.italic']         = { italic = true },
		['@markup.strikethrough']  = { fg = c.text, strikethrough = true },
		['@markup.underline']      = 'Underlined',
		['@markup.heading']        = 'Title',
		['@markup.quote']          = { fg = syn.quote },
		['@markup.math']           = { fg = syn.func },
		['@markup.link']           = { fg = syn.keyword, bold = true },
		['@markup.link.label']     = 'Special',
		['@markup.link.url']       = { fg = syn.url, italic = true, underline = true },
		['@markup.raw']            = { fg = syn.raw, italic = true },
		['@markup.raw.block']      = { fg = c.subtext0 },
		['@markup.list']           = { fg = syn.list },
		['@markup.list.checked']   = { fg = c.green },
		['@markup.list.unchecked'] = { fg = c.yellow },

		['@diff.plus']  = 'diffAdded',
		['@diff.minus'] = 'diffRemoved',
		['@diff.delta'] = 'diffChanged',

		['@tag']           = { fg = syn.tag },
		['@tag.attribute'] = { fg = syn.tag_attr, italic = true },
		['@tag.delimiter'] = { fg = syn.tag_delim },

		-- Language specific
		['@label.json']           = { fg = syn.func },
		['@constructor.lua']      = { fg = syn.punct }, -- Lua's table braces
		['@field.rust']           = { fg = c.subtext0 },
		['@variable.member.yaml'] = { fg = syn.func }, -- YAML keys
	}

	-- Headings 1-6, generic and markdown-specific.
	for level, color in ipairs(syn.heading) do
		local heading = { fg = color, bold = true }
		hl['@markup.heading.' .. level] = heading
		hl['@markup.heading.' .. level .. '.markdown'] = heading
	end

	-- Captures renamed in nvim-treesitter, kept for older parsers and
	-- queries. Only groups defined above are copied.
	-- stylua: ignore
	local legacy = {
		['@parameter'] = '@variable.parameter', ['@field'] = '@variable.member',
		['@namespace'] = '@module', ['@float'] = '@number.float',
		['@string.regex'] = '@string.regexp', ['@text'] = '@markup',
		['@text.strong'] = '@markup.strong', ['@text.emphasis'] = '@markup.italic',
		['@text.underline'] = '@markup.underline', ['@text.strike'] = '@markup.strikethrough',
		['@text.uri'] = '@markup.link.url', ['@text.math'] = '@markup.math',
		['@text.title'] = '@markup.heading', ['@text.literal'] = '@markup.raw',
		['@text.reference'] = '@markup.link', ['@text.todo.checked'] = '@markup.list.checked',
		['@text.todo.unchecked'] = '@markup.list.unchecked', ['@text.todo'] = '@comment.todo',
		['@text.warning'] = '@comment.warning', ['@text.note'] = '@comment.note',
		['@text.danger'] = '@comment.error', ['@text.diff.add'] = '@diff.plus',
		['@text.diff.delete'] = '@diff.minus', ['@define'] = '@keyword.directive.define',
		['@preproc'] = '@keyword.directive', ['@storageclass'] = '@keyword.storage',
		['@conditional'] = '@keyword.conditional', ['@exception'] = '@keyword.exception',
		['@include'] = '@keyword.import', ['@repeat'] = '@keyword.repeat',
	}
	for old, new in pairs(legacy) do
		hl[old] = hl[new]
	end

	return hl
end

return M

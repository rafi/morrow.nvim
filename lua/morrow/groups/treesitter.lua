-- Tree-sitter capture groups, shaped after catppuccin: most captures link
-- to the Vim syntax groups in base.lua, the baseline every theme colors;
-- a theme's syntax role colors a capture directly only where Tree-sitter
-- is finer than Vim's groups (variables, members, builtins, tags...).
-- Captures: https://github.com/nvim-treesitter/nvim-treesitter/blob/main/CONTRIBUTING.md

local M = {}

---@type morrow.HighlightsFn
function M.get(c, opts)
	local syn = c.syntax
	local d = c.diag
	local stl = opts.styles

	-- stylua: ignore
	local hl = {
		-- Identifiers
		['@variable']                    = { fg = syn.variable, style = stl.variables },
		['@variable.builtin']            = { fg = syn.variable_builtin }, -- this, self
		['@variable.parameter']          = { fg = syn.parameter },
		['@variable.member']             = { fg = syn.member }, -- fields
		['@constant']                    = 'Constant',
		['@constant.builtin']            = { fg = syn.const_builtin }, -- nil, NULL
		['@constant.macro']              = 'Macro',
		['@module']                      = { fg = syn.module },
		['@label']                       = 'Label',

		-- Literals
		['@string']                      = 'String',
		['@string.documentation']        = 'String', -- docstrings
		['@string.regexp']               = { fg = syn.regex },
		['@string.escape']               = { fg = syn.escape, bold = true },
		['@string.special']              = 'Special',
		['@string.special.path']         = 'Special',
		['@string.special.url']          = { fg = syn.url, italic = true, underline = true },
		['@punctuation.delimiter.regex'] = '@string.regexp',
		['@character']                   = 'Character',
		['@character.special']           = 'SpecialChar', -- wildcards
		['@boolean']                     = 'Boolean',
		['@number']                      = 'Number',
		['@number.float']                = 'Float',

		-- Types
		['@type']                        = 'Type',
		['@type.builtin']                = { fg = syn.type_builtin },
		['@type.definition']             = 'Type',
		['@attribute']                   = 'Constant', -- decorators, annotations
		['@property']                    = { fg = syn.property }, -- keys, CSS properties

		-- Functions
		['@function']                    = 'Function',
		['@function.builtin']            = { fg = syn.builtin, style = stl.functions },
		['@function.call']               = 'Function',
		['@function.macro']              = { fg = syn.preproc },
		['@function.method']             = 'Function',
		['@function.method.call']        = 'Function',
		['@constructor']                 = { fg = syn.constructor },
		['@operator']                    = 'Operator',

		-- Keywords
		['@keyword']                     = 'Keyword',
		['@keyword.modifier']            = 'Keyword', -- const, static, public
		['@keyword.type']                = 'Keyword', -- struct, enum
		['@keyword.coroutine']           = 'Keyword',
		['@keyword.function']            = { fg = syn.keyword, style = stl.keywords },
		['@keyword.operator']            = { fg = syn.operator }, -- and, or, not
		['@keyword.import']              = 'Include',
		['@keyword.repeat']              = 'Repeat',
		['@keyword.return']              = { fg = syn.keyword_return, style = stl.keywords },
		['@keyword.debug']               = 'Exception',
		['@keyword.exception']           = 'Exception',
		['@keyword.conditional']         = 'Conditional',
		['@keyword.conditional.ternary'] = 'Operator',
		['@keyword.directive']           = 'PreProc',
		['@keyword.directive.define']    = 'Define',

		-- Punctuation
		['@punctuation.delimiter']       = 'Delimiter',
		['@punctuation.bracket']         = { fg = syn.punct },
		['@punctuation.special']         = 'Special', -- {} in string interpolation

		-- Comments
		['@comment']                     = 'Comment',
		['@comment.documentation']       = 'Comment',
		['@comment.error']               = { fg = c.base, bg = d.error },
		['@comment.warning']             = { fg = c.base, bg = d.warn },
		['@comment.hint']                = { fg = c.base, bg = d.hint },
		['@comment.todo']                = { fg = c.base, bg = d.hint },
		['@comment.note']                = { fg = c.base, bg = d.info },

		-- Markup
		['@markup']                      = { fg = c.text },
		['@markup.strong']               = { fg = syn.strong, bold = true },
		['@markup.italic']               = { italic = true },
		['@markup.strikethrough']        = { fg = c.text, strikethrough = true },
		['@markup.underline']            = 'Underlined',
		['@markup.heading']              = 'Title',
		['@markup.math']                 = { fg = syn.func },
		['@markup.quote']                = { fg = syn.quote },
		['@markup.link']                 = { fg = syn.keyword, bold = true },
		['@markup.link.label']           = 'Special',
		['@markup.link.url']             = { fg = syn.url, italic = true, underline = true },
		['@markup.raw']                  = { fg = syn.raw, italic = true },
		['@markup.raw.block']            = { fg = c.subtext0 },
		['@markup.list']                 = { fg = syn.list },
		['@markup.list.checked']         = { fg = c.green },
		['@markup.list.unchecked']       = { fg = c.yellow },

		-- Diff
		['@diff.plus']                   = 'diffAdded',
		['@diff.minus']                  = 'diffRemoved',
		['@diff.delta']                  = 'diffChanged',

		-- Tags
		['@tag']                         = { fg = syn.tag },
		['@tag.builtin']                 = { fg = syn.tag }, -- HTML elements in JSX
		['@tag.attribute']               = { fg = syn.tag_attr, italic = true },
		['@tag.delimiter']               = { fg = syn.tag_delim },

		['@error']                       = 'Error',

		-- Language specific
		['@markup.heading.html']         = '@markup', -- <title>, <h1> text stays text
		['@constructor.lua']             = '@punctuation.bracket', -- table braces
		['@function.method.php']         = 'Function',
		['@function.method.call.php']    = 'Function',
		['@keyword.directive.css']       = 'Keyword', -- @media, @import
	}

	-- Headings 1-6, generic and markdown-specific; HTML's stay text.
	for level, color in ipairs(syn.heading) do
		local heading = { fg = color, bold = true }
		hl['@markup.heading.' .. level] = heading
		hl['@markup.heading.' .. level .. '.markdown'] = heading
		hl['@markup.heading.' .. level .. '.html'] = '@markup'
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
		['@text.diff.delete'] = '@diff.minus', ['@method'] = '@function.method',
		['@method.call'] = '@function.method.call', ['@type.qualifier'] = '@keyword.modifier',
		['@keyword.storage'] = '@keyword.modifier', ['@storageclass'] = '@keyword.modifier',
		['@define'] = '@keyword.directive.define', ['@preproc'] = '@keyword.directive',
		['@conditional'] = '@keyword.conditional', ['@exception'] = '@keyword.exception',
		['@include'] = '@keyword.import', ['@repeat'] = '@keyword.repeat',
	}
	for old, new in pairs(legacy) do
		hl[old] = hl[new]
	end

	return hl
end

return M

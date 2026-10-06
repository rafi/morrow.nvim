-- LSP semantic token groups.
-- https://neovim.io/doc/user/lsp.html#lsp-semantic-highlight
--
-- Tree-sitter colors a buffer as it opens; a server's tokens arrive
-- seconds later at a higher priority (125, typemods 127) and repaint what
-- they cover. Neovim links each @lsp.type.<type> to the capture of the
-- same name. Where a language has no parser installed, those tokens and
-- Vim's regex syntax are all the color a buffer gets, so generic groups
-- stay linked; a group is cleared (an empty table lets Tree-sitter or
-- syntax show through) only where both always color it, or for a
-- language whose parser ships with Neovim.

local M = {}

---@type morrow.HighlightsFn
function M.get(c)
	-- stylua: ignore
	return {
		-- Comments are colored by Tree-sitter or syntax either way, and the
		-- token would paint over injected URLs, notes and doc markup.
		['@lsp.type.comment']                      = {},
		['@lsp.type.variable']                     = {}, -- keep Tree-sitter's variable colors

		-- Linked to the capture with the same meaning; several add what
		-- Tree-sitter can't know (builtins, parameter uses, callables).
		['@lsp.type.boolean']                      = '@boolean',
		['@lsp.type.builtinType']                  = '@type.builtin',
		['@lsp.type.decorator']                    = '@attribute',
		['@lsp.type.deriveHelper']                 = '@attribute',
		['@lsp.type.enum']                         = '@type',
		['@lsp.type.enumMember']                   = '@constant',
		['@lsp.type.escapeSequence']               = '@string.escape',
		['@lsp.type.formatSpecifier']              = '@punctuation.special',
		['@lsp.type.generic']                      = '@type',
		['@lsp.type.interface']                    = { fg = c.syntax.type },
		['@lsp.type.keyword']                      = '@keyword',
		['@lsp.type.lifetime']                     = '@attribute',
		['@lsp.type.namespace']                    = '@module',
		['@lsp.type.number']                       = '@number',
		['@lsp.type.operator']                     = '@operator',
		['@lsp.type.parameter']                    = '@variable.parameter',
		-- Fields: the capture Tree-sitter gives them, not @property (keys).
		['@lsp.type.property']                     = '@variable.member',
		['@lsp.type.selfKeyword']                  = '@variable.builtin',
		['@lsp.type.selfTypeKeyword']              = '@variable.builtin',
		['@lsp.type.string']                       = '@string',
		['@lsp.type.typeAlias']                    = '@type.definition',
		['@lsp.type.unresolvedReference']          = { sp = c.diag.error, undercurl = true },
		['@lsp.typemod.class.defaultLibrary']      = '@type.builtin',
		['@lsp.typemod.enum.defaultLibrary']       = '@type.builtin',
		['@lsp.typemod.enumMember.defaultLibrary'] = '@constant.builtin',
		['@lsp.typemod.function.builtin']          = '@function.builtin',
		['@lsp.typemod.function.defaultLibrary']   = '@function.builtin',
		['@lsp.typemod.keyword.async']             = '@keyword.coroutine',
		['@lsp.typemod.keyword.injected']          = '@keyword',
		['@lsp.typemod.macro.defaultLibrary']      = '@function.builtin',
		['@lsp.typemod.method.defaultLibrary']     = '@function.builtin',
		['@lsp.typemod.operator.injected']         = '@operator',
		['@lsp.typemod.string.injected']           = '@string',
		['@lsp.typemod.struct.defaultLibrary']     = '@type.builtin',
		['@lsp.typemod.type.defaultLibrary']       = '@type.builtin',
		['@lsp.typemod.variable.callable']         = '@function',
		['@lsp.typemod.variable.defaultLibrary']   = '@variable.builtin',
		['@lsp.typemod.variable.injected']         = '@variable',
		['@lsp.typemod.variable.static']           = '@constant',

		-- lua_ls: a local with a ---@class annotation (a module's M) is a
		-- class token, table keys are properties, annotation types lose
		-- luadoc's builtins (table, string), and the io and table libraries
		-- become variables. Tree-sitter's @constant, @property,
		-- @type.builtin and @module.builtin stay.
		['@lsp.type.class.lua']                    = {},
		['@lsp.type.property.lua']                 = {},
		['@lsp.type.type.lua']                     = {},
		['@lsp.typemod.variable.defaultLibrary.lua'] = {},
		-- clangd marks inactive preprocessor branches as comments.
		['@lsp.type.comment.c']                    = '@comment',
		['@lsp.type.comment.cpp']                  = '@comment',
	}
end

return M

-- LSP symbol and completion kinds (LspKind*), linked to the syntax groups
-- they name so kind icons follow each theme's mapping. Plugins reuse them
-- through kinds(); navic gets plain colors from colors() because its
-- icons need the status line background, which a link can't carry.

local M = {}

-- stylua: ignore
M.links = {
	Array         = '@type',
	Boolean       = '@boolean',
	Class         = '@type',
	Color         = '@string.escape',
	Constant      = '@constant',
	Constructor   = '@constructor',
	Enum          = '@type',
	EnumMember    = '@constant',
	Event         = '@function',
	Field         = '@variable.member',
	File          = 'Directory',
	Folder        = 'Directory',
	Function      = '@function',
	Interface     = '@type',
	Key           = '@variable.member',
	Keyword       = '@keyword',
	Method        = '@function',
	Module        = '@module',
	Namespace     = '@module',
	Null          = '@constant.builtin',
	Number        = '@number',
	Object        = '@type',
	Operator      = '@operator',
	Package       = '@module',
	Property      = '@property',
	Reference     = '@variable.builtin',
	Snippet       = '@string.escape',
	String        = '@string',
	Struct        = '@type',
	Text          = '@markup',
	TypeParameter = '@type',
	Unit          = '@constant',
	Value         = '@constant',
	Variable      = '@variable',
}

-- Add kind groups to `hl`: `pattern` (e.g. 'BlinkCmpKind%s') linked to
-- LspKind<Kind>, or the LspKind* groups themselves when no pattern.
---@param hl? morrow.Highlights
---@param pattern? string
---@return morrow.Highlights
function M.kinds(hl, pattern)
	hl = hl or {}
	for kind, link in pairs(M.links) do
		if pattern then
			hl[pattern:format(kind)] = 'LspKind' .. kind
		else
			hl['LspKind' .. kind] = link
		end
	end
	return hl
end

-- Kind colors that mirror M.links through the syntax roles, for groups
-- that need a background next to the color (navic).
---@param c morrow.Colors
---@return table<string, string>
function M.colors(c)
	local syn = c.syntax
	-- stylua: ignore
	return {
		Array = syn.type, Boolean = syn.number, Class = syn.type,
		Color = syn.escape, Constant = syn.const, Constructor = syn.constructor,
		Enum = syn.type, EnumMember = syn.const, Event = syn.func,
		Field = syn.member, File = syn.keyword, Folder = syn.keyword,
		Function = syn.func, Interface = syn.type, Key = syn.member,
		Keyword = syn.keyword, Method = syn.func, Module = syn.module,
		Namespace = syn.module, Null = syn.const_builtin, Number = syn.number,
		Object = syn.type, Operator = syn.operator, Package = syn.module,
		Property = syn.property, Reference = syn.variable_builtin,
		Snippet = syn.escape, String = syn.string, Struct = syn.type,
		Text = c.text, TypeParameter = syn.type, Unit = syn.const,
		Value = syn.const, Variable = syn.variable,
	}
end

---@type morrow.HighlightsFn
function M.get()
	return M.kinds()
end

return M

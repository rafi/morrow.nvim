-- LSP semantic token groups.
-- https://neovim.io/doc/user/lsp.html#lsp-semantic-highlight
--
-- Most semantic tokens (@lsp.type.<...>) are not defined here: Neovim
-- links them to the Tree-sitter captures of the same name, which
-- treesitter.lua already colors.

local M = {}

---@type morrow.HighlightsFn
function M.get()
	-- stylua: ignore
	return {
		-- Tree-sitter already finds variables; the server's token adds
		-- nothing and is less accurate in places, so let Tree-sitter show.
		['@lsp.type.variable']                   = {},

		-- Where the server is more specific than Tree-sitter, let it win.
		['@lsp.typemod.function.defaultLibrary'] = '@function.builtin',
		['@lsp.typemod.function.builtin']        = '@function.builtin',
	}
end

return M

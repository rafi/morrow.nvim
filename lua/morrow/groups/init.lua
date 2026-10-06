-- Collects the highlight groups for a color table: the core group files,
-- flattened for nvim_set_hl, then the user's on_highlights.

local Util = require('morrow.util')

local M = {}

-- Group files every load includes, in merge order.
M.core = { 'base', 'kinds', 'semantic_tokens', 'treesitter' }

-- The group files to load.
---@param opts morrow.Config
---@return string[]
function M.names(opts)
	return vim.deepcopy(M.core)
end

-- Highlight groups from the named group files, flattened.
---@param names string[]
---@param c morrow.Colors
---@param opts morrow.Config
---@return morrow.Highlights
local function build(names, c, opts)
	local ret = {}
	for _, name in ipairs(names) do
		for group, hl in pairs(Util.mod('morrow.groups.' .. name).get(c, opts)) do
			ret[group] = hl
		end
	end
	return Util.resolve(ret)
end

-- The final groups for `c`, after on_highlights.
---@param c morrow.Colors
---@param opts morrow.Config
---@return morrow.Highlights
function M.setup(c, opts)
	local groups = build(M.names(opts), c, opts)
	opts.on_highlights(groups, c)
	return groups
end

return M

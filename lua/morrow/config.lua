-- Morrow options: defaults, setup() and per-load overrides.

local M = {}

-- Part of the cache key; bump when group files change in a release.
M.version = '0.1.0'

---@type morrow.Config
M.defaults = {
	theme = 'night', -- 'night', 'hybrid' or 'rafi'
	transparent = false, -- no background on Normal or elements painted with it
	terminal_colors = true, -- set g:terminal_color_0 .. 15
	styles = {
		-- Syntax attributes (any nvim_set_hl attributes), merged over the
		-- theme's own (night makes comments and keywords italic).
		comments = {},
		keywords = {},
		functions = {},
		variables = {},
		-- Elements (statusline, winbar, tabline, float, pmenu, picker,
		-- sidebar, code, separator, inactive, cmdline, gutter, cursorline)
		-- take a palette name, 'normal', 'transparent' or a table of
		-- colors; border takes a palette name, 'hidden' or '#rrggbb'.
	},
	plugins = {
		-- Every integration, unless a plugin manager can tell which
		-- plugins are installed.
		all = not (package.loaded.lazy or package.loaded['vim.pack']),
		-- Integrations for plugins lazy.nvim or vim.pack reports installed.
		auto = true,
	},
	cache = true, -- cache final groups in stdpath('cache')/morrow-<theme>.json
	---@param c morrow.Colors
	on_colors = function(c) end,
	---@param hl morrow.Highlights
	---@param c morrow.Colors
	on_highlights = function(hl, c) end,
}

---@type morrow.Config
M.options = nil

-- Store the user's options merged over the defaults.
---@param options? morrow.Config
function M.setup(options)
	M.options = vim.tbl_deep_extend('force', {}, M.defaults, options or {})
end

-- Options for one load: `opts` merged over the stored options, or the
-- stored options themselves when there is nothing to merge.
---@param opts? morrow.Config
---@return morrow.Config
function M.extend(opts)
	return opts and vim.tbl_deep_extend('force', {}, M.options, opts) or M.options
end

-- Before setup() runs, `options` reads as the defaults.
setmetatable(M, {
	__index = function(_, k)
		if k == 'options' then
			return M.defaults
		end
	end,
})

return M

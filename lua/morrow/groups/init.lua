-- Collects the highlight groups for a color table: the core group files,
-- then each enabled plugin's file, flattened for nvim_set_hl, then the
-- user's on_highlights.

local Config = require('morrow.config')
local Util = require('morrow.util')

local M = {}

-- Plugin names (as lazy.nvim and vim.pack name them) to group files.
-- stylua: ignore
M.plugins = {
	['aerial.nvim']           = 'aerial',
	['alpha-nvim']            = 'alpha',
	['barbecue.nvim']         = 'barbecue',
	['blink.cmp']             = 'blink',
	['nvim-bqf']              = 'bqf',
	['bufferline.nvim']       = 'bufferline',
	['nvim-cmp']              = 'cmp',
	['copilot.lua']           = 'copilot',
	['nvim-dap']              = 'dap',
	['nvim-dap-ui']           = 'dap-ui',
	['gitsigns.nvim']         = 'gitsigns',
	['glance.nvim']           = 'glance',
	['grug-far.nvim']         = 'grug-far',
	['headlines.nvim']        = 'headlines',
	['vim-illuminate']        = 'illuminate',
	['incline.nvim']          = 'incline',
	['indent-blankline.nvim'] = 'indent-blankline',
	['lazy.nvim']             = 'lazy',
	['leap.nvim']             = 'leap',
	['lualine.nvim']          = 'lualine',
	['marks.nvim']              = 'marks',
	['mini.cursorword']         = 'mini_cursorword',
	['mini.diff']               = 'mini_diff',
	['mini.hipatterns']         = 'mini_hipatterns',
	['mini.icons']              = 'mini_icons',
	['mini.indentscope']        = 'mini_indentscope',
	['mini.jump2d']             = 'mini_jump2d',
	['mini.map']                = 'mini_map',
	['mini.statusline']         = 'mini_statusline',
	['mini.trailspace']         = 'mini_trailspace',
	['nvim-navic']              = 'navic',
	['neo-tree.nvim']           = 'neo-tree',
	['noice.nvim']              = 'noice',
	['outline.nvim']            = 'outline',
	['rainbow-delimiters.nvim'] = 'rainbow',
	['render-markdown.nvim']    = 'render-markdown',
	['snacks.nvim']             = 'snacks',
	['tabstrip.nvim']           = 'tabstrip',
	['telescope.nvim']          = 'telescope',
	['nvim-treesitter-context'] = 'treesitter-context',
	['trouble.nvim']            = 'trouble',
	['which-key.nvim']          = 'which-key',
}

-- Group files every load includes, in merge order.
M.core = { 'base', 'kinds', 'semantic_tokens', 'treesitter' }

-- Installed plugin names, from lazy.nvim or vim.pack when either is
-- already loaded. Never loads vim.pack itself, so setups without it don't
-- pay for loading it.
---@return table<string, true>
function M.installed()
	local ret = {}
	if package.loaded.lazy then
		for name in pairs(require('lazy.core.config').plugins) do
			ret[name] = true
		end
	elseif package.loaded['vim.pack'] then
		for _, plugin in ipairs(vim.pack.get(nil, { info = false })) do
			ret[plugin.spec.name] = true
		end
	end
	return ret
end

-- The group files to load: the core files, then the enabled plugin files
-- sorted by name. A plugin is enabled by `all`, by `auto` when its plugin
-- is installed (mini.nvim enables every mini_* file), or by name: a
-- group or plugin name set to true, false or { enabled = bool } wins.
---@param opts morrow.Config
---@return string[]
function M.names(opts)
	local enabled = {}
	if opts.plugins.all then
		for _, group in pairs(M.plugins) do
			enabled[group] = true
		end
	elseif opts.plugins.auto then
		local installed = M.installed()
		for plugin, group in pairs(M.plugins) do
			if installed[plugin] then
				enabled[group] = true
			elseif installed['mini.nvim'] and group:find('^mini_') then
				enabled[group] = true
			end
		end
	end
	for plugin, group in pairs(M.plugins) do
		local use = opts.plugins[group]
		if use == nil then
			use = opts.plugins[plugin]
		end
		if type(use) == 'table' then
			use = use.enabled
		end
		if use ~= nil then
			enabled[group] = use or nil
		end
	end
	local names = vim.tbl_keys(enabled)
	table.sort(names)
	return vim.list_extend(vim.deepcopy(M.core), names)
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

-- The final groups for `c`: from the cache when its inputs match (plugin
-- version and checkout, colors, enabled group files, styles and
-- transparency), else built and cached. on_highlights always runs after,
-- because a function can't be part of the key.
---@param c morrow.Colors
---@param opts morrow.Config
---@return morrow.Highlights
function M.setup(c, opts)
	local names = M.names(opts)
	local inputs = {
		version = Config.version .. ':' .. vim.fn.getftime(Util.root .. '/.git'),
		colors = c,
		plugins = names,
		opts = { styles = opts.styles, transparent = opts.transparent },
	}
	local cache = opts.cache and Util.cache.read(opts.theme)
	local groups = cache and vim.deep_equal(inputs, cache.inputs) and cache.groups
	if not groups then
		groups = build(names, c, opts)
		if opts.cache then
			Util.cache.write(opts.theme, { groups = groups, inputs = inputs })
		end
	end
	opts.on_highlights(groups, c)
	return groups
end

return M

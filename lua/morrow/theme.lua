-- Applies a theme: builds colors and groups, resets highlights, sets
-- every group and the terminal colors.

local M = {}

-- Load and apply the configured (or given) theme.
---@param opts? morrow.Config
---@return morrow.Colors c
---@return morrow.Highlights groups
---@return morrow.Config opts
function M.setup(opts)
	opts = require('morrow.config').extend(opts)
	local c
	c, opts = require('morrow.themes').setup(opts)
	local groups = require('morrow.groups').setup(c, opts)

	-- Changing 'background' reloads the current colorscheme, so only set
	-- it when it differs, before anything else changes.
	if vim.o.background ~= 'dark' then
		vim.o.background = 'dark'
	end
	if vim.g.colors_name then
		vim.cmd('hi clear')
	end
	vim.o.termguicolors = true
	vim.g.colors_name = 'morrow-' .. opts.theme

	-- A group nvim_set_hl rejects (say a bad color from on_highlights) is
	-- skipped, so the rest still apply, and reported once.
	local failed = {}
	for group, hl in pairs(groups) do
		hl = type(hl) == 'string' and { link = hl } or hl
		if not pcall(vim.api.nvim_set_hl, 0, group, hl) then
			failed[#failed + 1] = group
		end
	end
	if #failed > 0 then
		table.sort(failed)
		local msg = 'morrow: skipped invalid highlight groups: '
		vim.notify(msg .. table.concat(failed, ', '), vim.log.levels.WARN)
	end

	if opts.terminal_colors then
		M.terminal(c)
	end
	return c, groups, opts
end

-- Set g:terminal_color_0 .. 15 from the terminal role: the 8 colors,
-- then their bright variants.
---@param c morrow.Colors
function M.terminal(c)
	local names =
		{ 'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white' }
	for i, name in ipairs(names) do
		vim.g['terminal_color_' .. (i - 1)] = c.terminal[name]
		vim.g['terminal_color_' .. (i + 7)] = c.terminal[name .. '_bright']
	end
end

return M

-- Credits: Nightfox at https://github.com/EdenEast/nightfox.nvim

local util = require('morrow.util')

local M = {}

local function override(groups, spec, ovr)
	ovr = util.parse(ovr, spec)
	return vim.tbl_deep_extend('force', groups, ovr)
end

function M.from(spec)
	local ovr = require('morrow.override').groups
	local config = require('morrow.config').options

	if not spec then
		print('there is no spec')
	end
	local theme = require('morrow.theme').get(spec, config)

	local default_enable_value = config.module_default
	local mod_names = require('morrow.config').module_names
	for _, name in ipairs(mod_names) do
		local kind = type(config.modules[name])
		local opts = kind == 'boolean' and { enable = config.modules[name] }
			or kind == 'table' and config.modules[name]
			or {}
		opts.enable = opts.enable == nil and default_enable_value or opts.enable

		if opts.enable then
			theme = vim.tbl_deep_extend('force',
				theme,
				require('morrow.modules.' .. name).get(spec, config, opts)
			)
		end
	end

	local function apply_ovr(key, groups)
		return ovr[key] and override(groups, spec, ovr[key]) or groups
	end

	theme = apply_ovr('all', theme)
	theme = apply_ovr(spec.palette.meta.name, theme)

	return theme
end

function M.load(name)
	name = name or require('morrow.config').flavour
	return M.from(require('morrow.spec').load(name))
end

return M

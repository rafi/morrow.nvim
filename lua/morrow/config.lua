-- Morrow configuration
-- https://github.com/rafi/morrow.nvim

-- This is based on Nightfox at https://github.com/EdenEast/nightfox.nvim

local M = {
	flavour = 'morrow-night',
	has_options = false,
}

local defaults = {
	compile_path = vim.fn.stdpath('cache') .. '/morrow',
	compile_file_suffix = '_compiled',
	kitty = vim.env.KITTY_WINDOW_ID and true or false,
	transparent = false,
	colorblind = {
		enable = false,
		simulate_only = false,
		severity = {
			protan = 0,
			deutan = 0,
			tritan = 0,
		},
	},
	styles = {
		comments = 'NONE',
		conditionals = 'NONE',
		constants = 'NONE',
		functions = 'NONE',
		keywords = 'NONE',
		numbers = 'NONE',
		operators = 'NONE',
		statements = 'NONE',
		strings = 'NONE',
		structures = 'NONE',
		types = 'NONE',
		variables = 'NONE',
	},
	inverse = {
		match_paren = false,
		visual = false,
		search = false,
	},
	modules = {
		diagnostic = {
			-- This is linked to so much that is needs to be enabled. This is here primarily
			-- for the extra options that can be added with modules
			enable = true,
			background = true,
		},
		lsp_semantic_tokens = true,
		treesitter = true,
	},
}

M.path_sep = jit and (jit.os == 'Windows' and '\\' or '/')
	or package.config:sub(1, 1)

M.options = vim.deepcopy(defaults)

M.module_names = {
	'diagnostic',
	'lsp_semantic_tokens',
	'treesitter',
}

function M.set_flavour(name)
	M.flavour = name
end

function M.set_options(opts)
	opts = opts or {}
	M.options = vim.tbl_deep_extend('force', M.options, opts)
	M.has_options = true
end

function M.reset()
	M.options = vim.deepcopy(defaults)
end

function M.get_compiled_info(opts)
	local output_path = opts.output_path or M.options.compile_path
	local file_suffix = opts.file_suffix or M.options.compile_file_suffix
	local style = opts.name or M.flavour
	return output_path, output_path .. M.path_sep .. style .. file_suffix
end

function M.hash()
	local hash = require('morrow.util').hash(M.options)
	return hash and hash or 0
end

return M

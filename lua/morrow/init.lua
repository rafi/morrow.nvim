-- Morrow: Tomorrow-family colorschemes for Neovim.
-- https://github.com/rafi/morrow.nvim

local M = {}

-- Apply the configured theme, or the one in `opts.theme`.
---@param opts? morrow.Config
function M.load(opts)
	return require('morrow.theme').setup(opts)
end

M.setup = require('morrow.config').setup

return M

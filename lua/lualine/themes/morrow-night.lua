local style_name = 'morrow-night'
local Color = require('morrow.lib.color')
local config = require('morrow.config').options
local s = require('morrow.spec').load(style_name)
local p = s.palette
local base = Color.from_hex(s.bg0)

local function fade(color, amount)
	amount = amount or 0.3
	return base:blend(Color.from_hex(color), amount):to_css()
end

local tbg = config.transparent and 'NONE' or s.bg0
local tbgy = config.transparent and 'NONE' or fade(s.bg1, 0.50)
local tbgz = config.transparent and 'NONE' or fade(s.bg1, -1.50)

return {
	normal = {
		a = { bg = tbg, fg = s.fg2 },
		b = { bg = tbg, fg = s.fg2 },
		c = { bg = tbg, fg = s.fg2 },
		x = { bg = tbg, fg = s.bg1 },
		y = { bg = tbgy, fg = s.fg2 },
		z = { bg = tbgz, fg = s.fg2 },
	},

	insert = {
		z = { bg = fade(p.yellow.base), fg = s.fg2 },
	},

	command = {
		z = { bg = fade(p.blue.base), fg = s.fg2 },
	},

	visual = {
		z = { bg = fade(p.magenta.base), fg = s.fg2 },
	},

	replace = {
		z = { bg = fade(p.red.base), fg = s.fg2 },
	},

	terminal = {
		a = { bg = tbg, fg = s.fg2, gui = 'bold' },
		c = { bg = fade(p.yellow.base, 0.2), fg = s.fg1 },
	},

	inactive = {
		a = { bg = tbg, fg = s.fg4 },
		z = { bg = tbg, fg = s.fg4 },
	},
}

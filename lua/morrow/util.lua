-- Credits: Nightfox at https://github.com/EdenEast/nightfox.nvim

local M = {}

---Convert a Shade or Color to a css string
---@return string css hex string
local function to_value(value)
	return value.base and value.base or value:to_css()
end

---Walk path (one.two.three) in a table and return value
---@param t table
---@param path string
---@return any
local function get_path(t, path)
	for segment in path:gmatch('[^.]+') do
		if type(t) == 'table' then
			t = t[segment]
		end
	end
	return t
end

---Parse string for configuration template
---@param str string
---@param spec Spec
---@return any
local function parse_string(str, spec)
	if str == '' then
		return str
	end

	if str[1] == '#' then
		return str
	end

	local path = get_path(spec, str)
	return path and path.base and path.base or path or str
end

function M.parse(template, spec)
	local result = {}

	for group, opts in pairs(template) do
		if type(opts) == 'table' then
			local new = {}
			for key, value in pairs(opts) do
				new[key] = type(value) == 'table' and to_value(value)
					or parse_string(value, spec)
			end
			result[group] = new
		else
			result[group] = parse_string(opts, spec)
		end
	end

	return result
end

function M.parse_template_str(template, spec)
	return (
		template:gsub('($%b{})', function(w)
			local path = w:sub(3, -2)
			local value = get_path(spec, path) or w
			if type(value) == 'table' then
				return value.base and value.base or value
			else
				return value or w
			end
		end)
	)
end

---Round float to nearest int
---@param x number Float
---@return number
function M.round(x)
	return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

---Clamp value between the min and max values.
---@param value number
---@param min number
---@param max number
function M.clamp(value, min, max)
	if value < min then
		return min
	elseif value > max then
		return max
	end
	return value
end

---@diagnostic disable-next-line: undefined-global
local bitop = bit or bit32

-- https://theartincode.stanis.me/008-djb2/
local function djb2(s)
	local h = 5381
	for i = 1, #s do
		h = bitop.lshift(h, 5) + h + string.byte(s, i) -- h * 33 + c
	end
	return h
end

-- Reference: https://github.com/catppuccin/nvim/blob/bad9c23f12944683cd11484d9570560849efc101/lua/catppuccin/lib/hashing.lua
function M.hash(x)
	local t = type(x)
	if t == 'table' then
		local h = 0
		for k, v in next, x do
			h = bitop.bxor(h, djb2(k .. M.hash(v)))
		end
		return h
	elseif t == 'function' then
		return djb2(string.dump(x))
	end
	return tostring(x)
end

if jit ~= nil then
	M.is_windows = jit.os == 'Windows'
else
	M.is_windows = package.config:sub(1, 1) == '\\'
end

M.is_nvim = vim.fn.has('nvim') == 1
M.use_nvim_api = M.is_nvim and vim.fn.has('nvim-0.7') == 1

function M.get_tmp_dir()
	return M.is_windows and os.getenv('TMP') or '/tmp'
end

function M.get_separator()
	if M.is_windows then
		return '\\'
	end
	return '/'
end

function M.join_paths(...)
	local separator = M.get_separator()
	return table.concat({ ... }, separator)
end

function M.exists(path)
	local f = io.open(path, 'r')
	if f ~= nil then
		io.close(f)
		return true
	else
		return false
	end
end

function M.ensure_dir(path)
	if vim.fn.isdirectory(path) == 0 then
		vim.fn.mkdir(path, 'p')
	end
end

local function vim_cache_home()
	if M.is_windows then
		return M.join_paths(vim.fn.expand('%localappdata%'), 'Temp', 'vim')
	end
	local xdg = os.getenv('XDG_CACHE_HOME')
	local root = xdg or vim.fn.expand('$HOME/.cache')
	return M.join_paths(root, 'vim')
end

M.cache_home = M.is_nvim and vim.fn.stdpath('cache') or vim_cache_home()

return M

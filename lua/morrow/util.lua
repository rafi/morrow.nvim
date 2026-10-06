-- Shared helpers: RGB color blending, loading morrow modules by file path,
-- and flattening group style tables for nvim_set_hl.

local M = {}

-- Background blend_bg() mixes over; themes.setup() sets it to the
-- theme's base, after on_colors, before group files run.
M.bg = '#000000'

-- Plugin root: three levels above lua/morrow/util.lua.
M.root = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h:h:h')

-- '#rrggbb' as a list of three 0..255 channels.
local function rgb(c)
	c = c:lower()
	return {
		tonumber(c:sub(2, 3), 16),
		tonumber(c:sub(4, 5), 16),
		tonumber(c:sub(6, 7), 16),
	}
end

-- Mix two colors in RGB, as tokyonight does: `alpha` 1 gives `fg`, 0
-- gives `bg`. Values outside 0..1 extrapolate; channels are clamped.
---@param fg string
---@param alpha number
---@param bg string
---@return string
function M.blend(fg, alpha, bg)
	local f, b = rgb(fg), rgb(bg)
	local function channel(i)
		local v = alpha * f[i] + (1 - alpha) * b[i]
		return math.floor(math.min(math.max(0, v), 255) + 0.5)
	end
	return string.format('#%02x%02x%02x', channel(1), channel(2), channel(3))
end

-- Blend a color over the theme background (M.bg) or `bg`.
---@param hex string
---@param alpha number
---@param bg? string
---@return string
function M.blend_bg(hex, alpha, bg)
	return M.blend(hex, alpha, bg or M.bg)
end

-- Load a morrow module by its file path under the plugin root, skipping
-- the runtimepath search, and cache it in package.loaded like require.
-- A missing file raises `err` (or a generic message), so callers can name
-- the unknown theme or palette.
---@param modname string e.g. 'morrow.palettes.olive'
---@param err? string
---@return any
function M.mod(modname, err)
	if package.loaded[modname] then
		return package.loaded[modname]
	end
	local path = M.root .. '/lua/' .. modname:gsub('%.', '/') .. '.lua'
	if not vim.uv.fs_stat(path) then
		error(err or ('morrow: module not found: ' .. modname), 0)
	end
	local ret = assert(loadfile(path))()
	package.loaded[modname] = ret
	return ret
end

-- Flatten each group's `style` table (user syntax attributes such as
-- { italic = true }) into the group itself, as nvim_set_hl expects. A
-- style may also list attribute names ({ 'italic', 'bold' }, the old
-- option format); each listed name is set to true.
---@param groups morrow.Highlights
---@return morrow.Highlights
function M.resolve(groups)
	for _, hl in pairs(groups) do
		if type(hl) == 'table' and type(hl.style) == 'table' then
			for k, v in pairs(hl.style) do
				if type(k) == 'number' and type(v) == 'string' then
					hl[v] = true
				else
					hl[k] = v
				end
			end
			hl.style = nil
		end
	end
	return groups
end

M.cache = {}

-- Cache file for one theme.
---@param key string theme name
---@return string
function M.cache.file(key)
	return vim.fn.stdpath('cache') .. '/morrow-' .. key .. '.json'
end

-- The cached { groups, inputs } for a theme, or nil when the file is
-- missing, unreadable or not shaped like a cache.
---@param key string
---@return morrow.Cache?
function M.cache.read(key)
	local ok, ret = pcall(function()
		local fd = assert(io.open(M.cache.file(key), 'r'))
		local data = fd:read('*a')
		fd:close()
		return vim.json.decode(data, { luanil = { object = true, array = true } })
	end)
	if
		ok
		and type(ret) == 'table'
		and type(ret.groups) == 'table'
		and type(ret.inputs) == 'table'
	then
		return ret
	end
end

-- Write a theme's cache; failures (read-only cache dir) are ignored.
---@param key string
---@param data morrow.Cache
function M.cache.write(key, data)
	pcall(function()
		local file = M.cache.file(key)
		vim.fn.mkdir(vim.fn.fnamemodify(file, ':h'), 'p')
		local fd = assert(io.open(file, 'w'))
		fd:write(vim.json.encode(data))
		fd:close()
	end)
end

-- Remove every theme's cache file.
function M.cache.clear()
	local pattern = vim.fn.stdpath('cache') .. '/morrow-*.json'
	for _, file in ipairs(vim.fn.glob(pattern, false, true)) do
		vim.uv.fs_unlink(file)
	end
end

return M

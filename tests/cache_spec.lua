-- Cache: final groups in stdpath('cache')/morrow-<theme>.json, reused
-- while the inputs match.

-- Count calls to groups/base.lua's get(), i.e. cache misses.
local function counter()
	local base = require('morrow.groups.base')
	local calls, orig = { n = 0 }, base.get
	base.get = function(...)
		calls.n = calls.n + 1
		return orig(...)
	end
	return calls
end

local function start(opts)
	fresh(vim.tbl_extend('force', { cache = true }, opts or {}))
	require('morrow.util').cache.clear()
	return counter()
end

test('a second load reuses the cache', function()
	local calls = start()
	require('morrow').load()
	eq(1, calls.n)
	require('morrow').load()
	eq(1, calls.n)
	eq('#969896', hex(hl('Comment').fg))
	local file = require('morrow.util').cache.file('night')
	assert(vim.uv.fs_stat(file), 'cache file written')
end)

test('changed colors, styles or plugins miss the cache', function()
	local calls = start()
	require('morrow').load()
	require('morrow').load({ styles = { statusline = 'olive' } })
	eq(2, calls.n)
	require('morrow').load({ plugins = { snacks = false } })
	eq(3, calls.n)
	require('morrow').load({
		on_colors = function(c)
			c.red = '#ff0000'
		end,
	})
	eq(4, calls.n)
end)

test('an edited group file misses the cache', function()
	local calls = start()
	require('morrow').load()
	local file = ROOT .. '/lua/morrow/groups/base.lua'
	local stat = assert(vim.uv.fs_stat(file))
	local now = os.time() + 60
	vim.uv.fs_utime(file, now, now)
	local ok, err = pcall(require('morrow').load)
	vim.uv.fs_utime(file, stat.atime.sec, stat.mtime.sec)
	assert(ok, err)
	eq(2, calls.n)
end)

test('on_highlights applies on a cache hit', function()
	local calls = start({
		on_highlights = function(groups)
			groups.Normal = { fg = '#123456' }
		end,
	})
	require('morrow').load()
	require('morrow').load()
	eq(1, calls.n)
	eq('#123456', hex(hl('Normal').fg))
end)

test('cache = false neither reads nor writes', function()
	fresh({ cache = false })
	require('morrow.util').cache.clear()
	require('morrow').load()
	eq(nil, vim.uv.fs_stat(require('morrow.util').cache.file('night')))
end)

test('a corrupt cache file falls back to building', function()
	local calls = start()
	local file = require('morrow.util').cache.file('night')
	vim.fn.mkdir(vim.fn.fnamemodify(file, ':h'), 'p')
	vim.fn.writefile({ 'not json' }, file)
	require('morrow').load()
	eq(1, calls.n)
	eq('#1d1f21', hex(hl('Normal').bg))
end)

test('a cache file holding non-object JSON falls back to building', function()
	local calls = start()
	local file = require('morrow.util').cache.file('night')
	vim.fn.mkdir(vim.fn.fnamemodify(file, ':h'), 'p')
	vim.fn.writefile({ '123' }, file)
	require('morrow').load()
	eq(1, calls.n)
	eq('#1d1f21', hex(hl('Normal').bg))
end)

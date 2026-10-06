-- Minimal headless test runner. Loads tests/*_spec.lua (or the files given
-- as arguments), runs the cases they register with test() and exits
-- non-zero when one fails. The cache goes to a temporary directory so
-- tests never touch the real stdpath('cache').
-- Usage: nvim --headless --clean -u NONE -l tests/run.lua [tests/x_spec.lua ...]
local root = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p:h:h')
vim.opt.rtp:prepend(root)
vim.env.XDG_CACHE_HOME = vim.fn.tempname()
_G.ROOT = root

local cases = {}

-- Register a test case.
function _G.test(name, fn)
	cases[#cases + 1] = { name = name, fn = fn }
end

-- Fail unless `got` deep-equals `want`.
function _G.eq(want, got, msg)
	if not vim.deep_equal(want, got) then
		error(
			string.format(
				'%sexpected %s, got %s',
				msg and (msg .. ': ') or '',
				vim.inspect(want),
				vim.inspect(got)
			),
			2
		)
	end
end

-- Effective attributes of a highlight group, links followed.
function _G.hl(name)
	return vim.api.nvim_get_hl(0, { name = name, link = false })
end

-- An nvim_get_hl color number as '#rrggbb', or nil when unset.
function _G.hex(n)
	return n and string.format('#%06x', n) or nil
end

-- Fail unless calling `fn` raises an error whose text contains `text`.
function _G.raises(text, fn)
	local ok, err = pcall(fn)
	if ok then
		error('expected an error containing ' .. text, 2)
	end
	if not tostring(err):find(text, 1, true) then
		error(
			string.format('expected an error containing %q, got %s', text, err),
			2
		)
	end
end

-- Fresh morrow state for a case: unload morrow's modules (they keep the
-- setup() options and Util.bg), then store `opts`.
function _G.fresh(opts)
	for name in pairs(package.loaded) do
		if name == 'morrow' or name:match('^morrow%.') then
			package.loaded[name] = nil
		end
	end
	require('morrow.config').setup(opts)
end

local files = #_G.arg > 0 and _G.arg
	or vim.fn.globpath(root .. '/tests', '*_spec.lua', false, true)
for _, file in ipairs(files) do
	dofile(file)
end

local failed = 0
for _, case in ipairs(cases) do
	local ok, err = pcall(case.fn)
	io.stdout:write((ok and 'ok   ' or 'FAIL ') .. case.name .. '\n')
	if not ok then
		failed = failed + 1
		io.stdout:write('     ' .. tostring(err) .. '\n')
	end
end
io.stdout:write(
	string.format('%d passed, %d failed\n', #cases - failed, failed)
)
os.exit(failed == 0 and 0 or 1)

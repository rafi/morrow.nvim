lua << EOF
-- Useful when debugging
if vim.g.morrow_debug then
  for name, _ in pairs(package.loaded) do
    if name:match('^morrow') then
      if not name:match('config') and not name:match('deprecation') and not name:match('override') then
        package.loaded[name] = nil
      end
    end
  end
end

require('morrow').load({ name = 'morrow-night' })
EOF

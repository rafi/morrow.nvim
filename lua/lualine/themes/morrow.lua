-- Follows the active morrow colorscheme (morrow-<theme>), else the
-- configured morrow theme.
local theme = (vim.g.colors_name or ''):match('^morrow%-(.+)$')
return require('lualine.themes._morrow').get(theme)

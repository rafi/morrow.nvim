---@meta
-- LuaLS annotations for morrow's options, colors and groups.

---@alias morrow.StyleValue string|table<string, string> palette name, 'normal', 'transparent', or element colors

---@class morrow.Styles
---@field comments? vim.api.keyset.highlight|string[]
---@field keywords? vim.api.keyset.highlight|string[]
---@field functions? vim.api.keyset.highlight|string[]
---@field variables? vim.api.keyset.highlight|string[]
---@field statusline? morrow.StyleValue
---@field winbar? morrow.StyleValue
---@field tabline? morrow.StyleValue
---@field float? morrow.StyleValue
---@field pmenu? morrow.StyleValue
---@field picker? morrow.StyleValue
---@field sidebar? morrow.StyleValue
---@field code? morrow.StyleValue
---@field separator? morrow.StyleValue
---@field inactive? morrow.StyleValue
---@field cmdline? morrow.StyleValue
---@field gutter? morrow.StyleValue
---@field cursorline? morrow.StyleValue
---@field border? string palette name, 'hidden' or '#rrggbb'

---@class morrow.Config
---@field theme? string
---@field transparent? boolean
---@field terminal_colors? boolean
---@field styles? morrow.Styles
---@field plugins? table<string, boolean|{enabled: boolean}>
---@field cache? boolean
---@field on_colors? fun(c: morrow.Colors)
---@field on_highlights? fun(hl: morrow.Highlights, c: morrow.Colors)

---@class morrow.Syntax: table<string, string|string[]>
---@field heading string[]
---@field todo_bg? string

---@class morrow.Theme: table<string, any>
---@field crust string
---@field mantle string
---@field base string
---@field surface0 string
---@field surface1 string
---@field surface2 string
---@field overlay0 string
---@field overlay1 string
---@field overlay2 string
---@field subtext0 string
---@field subtext1 string
---@field text string
---@field red string
---@field orange string
---@field yellow string
---@field green string
---@field cyan string
---@field blue string
---@field magenta string
---@field brown string
---@field syntax fun(c: morrow.Theme): morrow.Syntax
---@field styles? morrow.Styles

---@class morrow.Colors: morrow.Theme
---@field none string
---@field syntax morrow.Syntax

---@class morrow.Highlight: vim.api.keyset.highlight
---@field style? vim.api.keyset.highlight|string[]

---@alias morrow.Highlights table<string, morrow.Highlight|string>

---@alias morrow.HighlightsFn fun(c: morrow.Colors, opts: morrow.Config): morrow.Highlights

---@class morrow.Cache
---@field groups morrow.Highlights
---@field inputs table

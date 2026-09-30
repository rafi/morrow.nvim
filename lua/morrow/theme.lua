-- Morrow editor highlights
-- https://github.com/rafi/morrow.nvim

local M = {}

function M.get(spec, config)
	-- local has_ts = config.modules.treesitter
	local trans = config.transparent
	local inactive = config.dim_inactive
	local inv = config.inverse
	local pal = spec.palette
	local syn = spec.syntax
	local stl = config.styles

	-- stylua: ignore
	local theme = {
		---------------------------------------------------------------------------
		-- Editor

		ColorColumn     = { bg = spec.bg2 }, -- used for the columns set with 'colorcolumn'
		Conceal         = { fg = spec.bg4 }, -- placeholder characters substituted for concealed text (see 'conceallevel') TODO
		Cursor          = { fg = spec.bg1, bg = spec.fg1 }, -- character under the cursor TODO
		lCursor         = { link = 'Cursor' }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
		CursorIM        = { link = 'Cursor' }, -- like Cursor, but used when in IME mode |CursorIM|
		CursorColumn    = { link = 'CursorLine' }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
		CursorLine      = { bg = spec.bg2 }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
		Directory       = { fg = spec.syntax.keyword }, -- directory names (and other special names in listings)
		DiffAdd         = { bg = spec.diff_add }, -- diff mode: Added line |diff.txt|
		DiffChange      = { bg = spec.diff_change }, -- diff mode: Changed line |diff.txt|
		DiffDelete      = { bg = spec.diff_change }, -- diff mode: Deleted line |diff.txt|
		DiffText        = { bg = spec.diff_text }, -- diff mode: Changed text within a changed line |diff.txt|
		-- DiffTextAdd                 = { bg = },
		EndOfBuffer     = { fg = spec.sel0 }, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
		TermCursor      = { bg = spec.syntax.field }, -- cursor in a focused terminal
		ErrorMsg        = { fg = spec.diag.error }, -- error messages on the command line
		WinSeparator    = { fg = spec.bg2 }, -- the column separating vertically split windows
		VertSplit       = { link = 'WinSeperator' }, -- the column separating vertically split windows
		Folded          = { fg = spec.fg4, bg = spec.bg2 }, -- line used for closed folds TODO
		FoldColumn      = { fg = spec.sel0 }, -- 'foldcolumn'
		SignColumn      = { fg = spec.sel0 }, -- column where |signs| are displayed TODO
		SignColumnSB    = { link = 'SignColumn' }, -- column where |signs| are displayed
		Substitute      = { fg = spec.bg1, bg = spec.diag.error }, -- |:substitute| replacement text highlighting
		LineNr          = { fg = spec.sel0 }, -- Line number for ':number' and ':#' commands, and when 'number' or 'relativenumber' option is set.
		CursorLineNr    = { fg = spec.diag.warn, style = 'bold' }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
		MatchParen      = { fg = pal.blue.base, bg = spec.bg4, style = inv.match_paren and 'reverse,bold' or 'bold' }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt| TODO
		ModeMsg         = { fg = spec.diag.ok, style = 'bold' }, -- 'showmode' message (e.g., '-- INSERT -- ')
		-- NOTE: This was commented out as there is an issue with seting this highlight group see issue #98
		-- MsgArea         = { fg = spec.fg2 }, -- Area for messages and cmdline
		-- MsgSeparator    = {}, -- Separator for scrolled messages, `msgsep` flag of 'display'
		MoreMsg         = { fg = spec.diag.ok, style = 'bold' }, -- |more-prompt|
		NonText         = { fg = spec.sel0 }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., '>' displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
		Normal          = { fg = spec.fg1, bg = trans and 'NONE' or spec.bg1 }, -- normal text
		NormalNC        = { fg = spec.fg1, bg = (inactive and spec.bg3) or (trans and 'NONE') or spec.bg1 }, -- normal text in non-current windows
		NormalFloat     = { fg = spec.fg1, bg = spec.bg3 }, -- Normal text in floating windows.
		FloatBorder     = { fg = spec.bg4, bg = spec.bg3 },
		FloatTitle      = { fg = spec.diag.warn },
		-- FloatFooter     = {}, TODO
		Pmenu           = { fg = spec.fg1, bg = spec.sel0 }, -- Popup menu: normal item.
		PmenuSel        = { bg = spec.sel1 }, -- Popup menu: selected item. TODO
		PmenuSbar       = { bg = spec.bg0 }, -- Popup menu: scrollbar. TODO
		PmenuThumb      = { bg = spec.syntax.comment }, -- Popup menu: Thumb of the scrollbar. TODO
		-- TODO: new
		-- PmenuMatch      = { fg = spec.fg4 },
		-- PmenuMatchSel   = { fg = spec.sel0 },
		Question        = { link = 'MoreMsg' }, -- |hit-enter| prompt and yes/no questions
		QuickFixLine    = { bg = pal.pink.base }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
		Search          = inv.search and { style = 'reverse' } or { fg = spec.fg1, bg = spec.sel1 }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out. TODO
		IncSearch       = inv.search and { style = 'reverse' } or { fg = spec.bg1, bg = spec.diag.ok }, -- 'incsearch' highlighting; also used for the text replaced with ':s///c' TODO
		CurSearch       = { link = 'IncSearch'}, -- Search result under cursor (available since neovim >0.7.0 (https://github.com/neovim/neovim/commit/b16afe4d556af7c3e86b311cfffd1c68a5eed71f)).
		SpecialKey      = { link = 'NonText' }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
		SpellBad        = { sp = spec.diag.error, style = 'undercurl' }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
		SpellCap        = { sp = spec.diag.hint, style = 'undercurl' }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
		SpellLocal      = { sp = spec.diag.info, style = 'undercurl' }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
		SpellRare       = { sp = spec.diag.info, style = 'undercurl' }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
		StatusLine      = { fg = spec.fg2, bg = spec.bg0 }, -- status line of current window
		StatusLineNC    = { fg = spec.fg4, bg = spec.bg0 }, -- status lines of not-current windows Note: if this is equal to 'StatusLine' Vim will use '^^^' in the status line of the current window.

		TabLine         = { fg = spec.tabline, bg = spec.bg2 }, -- tab pages line, not active tab page label
		TabLineFill     = { bg = spec.bg0 }, -- tab pages line, where there are no labels
		TabLineSel      = { fg = spec.tablinesel, bg = spec.fg3 }, -- tab pages line, active tab page label
		Title           = { fg = spec.diag.warn, style = 'bold' }, -- titles for output from ':set all', ':autocmd' etc.
		Visual          = inv.visual and { style = 'reverse' } or { bg = spec.sel0 }, -- Visual mode selection
		VisualNOS       = inv.visual and { style = 'reverse' } or { link = 'Visual' }, -- Visual mode selection when vim is 'Not Owning the Selection'.
		WarningMsg      = { fg = spec.diag.warn }, -- warning messages
		Whitespace      = { fg = spec.bg3 }, -- 'nbsp', 'space', 'tab' and 'trail' in 'listchars'
		WildMenu        = { bg = pal.pink.base }, -- current match in 'wildmenu' completion
		WinBar          = { fg = spec.fg3, bg = trans and 'NONE' or spec.bg0, style = 'bold' }, -- Window bar of current window.
		WinBarNC        = { fg = spec.fg3, bg = trans and 'NONE' or inactive and spec.bg0 or spec.bg3, style = 'bold' }, --Window bar of not-current windows.

		-- qfLineNr        = {},
		-- qfFileName      = {},

		-- debugPC         = {}, -- used for highlighting the current line in terminal-debug
		-- debugBreakpoint = {}, -- used for breakpoint colors in terminal-debug

		---------------------------------------------------------------------------
		-- Syntax

		Comment        = { fg = syn.comment, style = stl.comments }, -- any comment
		Constant       = { fg = syn.const, style = stl.constants }, -- (preferred) any constant
		String         = { fg = syn.string, style = stl.strings }, -- a string constant: 'this is a string'
		Character      = { link = 'String' }, -- a character constant: 'c', '\n'
		Number         = { fg = syn.number, style = stl.numbers }, -- a number constant: 234, 0xff
		Float          = { link = 'Number' }, -- a floating point constant: 2.3e10
		Boolean        = { link = 'Number' }, -- a boolean constant: TRUE, false

		Identifier     = { fg = syn.ident, style = stl.variables }, -- (preferred) any variable name
		Function       = { fg = syn.func, style = stl.functions }, -- function name (also: methods for classes)

		Statement      = { fg = syn.statement, style = stl.statements }, -- (preferred) any statement
		Conditional    = { fg = syn.conditional, style = stl.conditionals }, -- if, then, else, endif, switch, etc.
		Repeat         = { link = 'Conditional' }, -- for, do, while, etc.
		Label          = { link = 'Conditional' }, -- case, default, etc.

		Operator       = { fg = syn.operator, style = stl.operators }, -- 'sizeof', '+', '*', etc.
		Keyword        = { fg = syn.keyword, style = stl.keywords }, -- any other keyword
		Exception      = { link = 'Keyword' }, -- try, catch, throw

		PreProc        = { fg = syn.preproc }, -- (preferred) generic Preprocessor
		Include        = { link = 'PreProc' }, -- preprocessor #include
		Define         = { link = 'PreProc' }, -- preprocessor #define
		Macro          = { link = 'PreProc' }, -- same as Define
		PreCondit      = { link = 'PreProc' }, -- preprocessor #if, #else, #endif, etc.

		Type           = { fg = syn.type, style = stl.types }, -- (preferred) int, long, char, etc.
		StorageClass   = { link = 'Type' }, -- static, register, volatile, etc.
		Structure      = { fg = syn.structure, style = stl.structures }, -- struct, union, enum, etc.
		Typedef        = { link = 'Type' }, -- A typedef

		Special        = { fg = syn.string },  -- (preferred) any special symbol
		SpecialChar    = { link = 'Special' }, -- special character in a constant
		Tag            = { link = 'Special' }, -- you can use CTRL-] on this
		-- TODO:
		-- Delimiter      = { link = 'Special' }, -- character that needs attention
		SpecialComment = { link = 'Special' }, -- special things inside a comment
		Debug          = { link = 'Special' }, -- debugging statements

		Underlined     = { style = 'underline' }, -- (preferred) text that stands out, HTML links TODO
		Bold           = { style = 'bold' },
		Italic         = { style = 'italic' },

		-- ('Ignore', below, may be invisible...)
		-- Ignore         = {}, -- (preferred) left blank, hidden  |hl-Ignore|

		Error          = { fg = spec.diag.error }, -- (preferred) any erroneous construct
		--  TODO:
		Todo           = { fg = spec.bg1, bg = spec.diag.hint }, -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX

		qfLineNr       = { fg = spec.diag.warn },
		qfFileName     = { link = 'Directory' },

		-- htmlH1       = {},
		-- htmlH2       = {},

		-- mkdHeading            = {},
		-- mkdCode               = {},
		-- mkdCodeDelimiter      = {},
		-- mkdCodeStart          = {},
		-- mkdCodeEnd            = {},
		-- mkdLink               = {},

		-- markdownHeadingDelimiter = {},
		-- markdownCode             = {},
		-- markdownCodeBlock        = {},
		-- markdownH1               = {},
		-- markdownH2               = {},
		-- markdownLinkText         = {},

		-- Diff filetype (runtime/syntax/diff.vim)
		-- Added       = { fg = pal.green.base }, -- Added lines ("^+.*" | "^>.*")
		-- Removed     = { fg = pal.red.base },-- Removed lines ("^-.*" | "^<.*")
		-- Changed     = { fg = pal.blue.base }, -- Changed lines ("^! .*")
		-- diffSubname = { fg = pal.blue.base, bg = spec.bg4 },

		-- diffOldFile     = { fg = pal.yellow.base }, -- Old file that is being diff against
		-- diffNewFile     = { fg = pal.orange.base }, -- New file that is being compared to the old file
		-- diffFile        = { fg = pal.blue.base, bg = spec.bg4 }, -- The filename of the diff ("diff --git a/readme.md b/readme.md")
		-- diffLine        = { fg = spec.syntax.builtin2 }, -- Line information ("@@ -169,6 +169,9 @@")
		-- diffIndexLine   = { fg = spec.syntax.preproc }, -- Index line of diff ("index bf3763d..94f0f62 100644")

		-- diff (not needed anymore?)
		diffAdded                   = { bg = spec.diff_add },
		diffRemoved                 = { bg = spec.diff_change },
		diffChanged                 = { bg = spec.diff_change },
		diffOldFile                 = { fg = pal.yellow.base },
		diffNewFile                 = { fg = pal.orange.base },
		diffFile                    = { fg = pal.blue.base },
		diffLine                    = { fg = syn.comment },
		diffIndexLine               = { fg = pal.magenta.base },
		helpExample                 = { fg = syn.comment },

		-- These groups are for the native LSP client. Some other LSP clients may
		-- use these groups, or use their own. Consult your LSP client's
		-- documentation.
		LspReferenceText   = { bg = spec.sel0 },      -- used for highlighting "text" references
		LspReferenceRead   = { bg = spec.read },      -- used for highlighting "read" references
		LspReferenceWrite  = { bg = spec.write },     -- used for highlighting "write" references
		LspReferenceTarget = { bg = pal.blue.base },  -- used for highlighting reference targets

		LspCodeLens                 = { fg = syn.comment }, -- Used to color the virtual text of the codelens
		LspCodeLensSeparator        = { fg = spec.fg3 }, -- Used to color the separator between two or more code lens
		LspSignatureActiveParameter = { fg = spec.sel1 }, -- Used to highlight the active parameter in the signature help

		LspInlayHint = { fg = syn.comment, bg = config.background and spec.bg2 or 'NONE' },

		---------------------------------------------------------------------------
		-- Plugins

		-- https://github.com/goolord/alpha-nvim
		AlphaHeader   = { link = 'Type'},
		AlphaShortcut = { link = 'Constant' },
		AlphaButtons  = { link = 'Keyword' },
		AlphaFooter   = { link = 'Comment'},

		-- https://github.com/kevinhwang91/nvim-bqf
		-- hi default link BqfPreviewFloat Normal
		BqfPreviewBorder = { link = 'FloatBorder' },
		BqfPreviewCursor = { link = 'TermCursor' },
		-- BqfPreviewRange = { link = 'TermCursorNC' },
		-- BqfSign = { fg = pal.cyan.base },

		-- :h bufferline-highlights
		-- https://github.com/akinsho/bufferline.nvim
		BufferLineBufferSelected = { fg = spec.fg2 },

		-- :h blink.cmp
		-- https://github.com/Saghen/blink.cmp
		BlinkCmpGhostText = { fg = spec.fg3 },
		ComplMatchIns = { fg = 'red' },
		-- BlinkCmpMenu = { link = 'FloatNormal' },
		-- BlinkCmpMenu = { link = 'NormalFloat' },

		-- :h cmp-highlight
		-- https://github.com/hrsh7th/nvim-cmp
		CmpDocumentation         = { fg = spec.fg1, bg = spec.bg0 },
		CmpDocumentationBorder   = { fg = spec.sel0, bg = spec.bg0 },
		CmpItemAbbr              = { fg = spec.fg1, },
		CmpItemAbbrDeprecated    = { fg = syn.dep, style = 'strikethrough' },
		CmpItemAbbrMatch         = { fg = syn.keyword, },
		CmpItemAbbrMatchFuzzy    = { fg = syn.func, },
		-- CmpItemKindDefault       = { fg = spec.fg2, },
		CmpItemMenu              = { link = 'Comment' },

		-- CmpItemKindKeyword       = { link = 'Identifier' },
		-- CmpItemKindVariable      = { link = has_ts and '@variable' or  'Identifier' },
		-- CmpItemKindConstant      = { link = has_ts and '@constant' or 'Constant' },
		-- CmpItemKindReference     = { link = 'Keyword' },
		-- CmpItemKindValue         = { link = 'Keyword' },
		-- CmpItemKindFunction      = { link = 'Function' },
		-- CmpItemKindMethod        = { link = 'Function' },
		-- CmpItemKindConstructor   = { link = 'Function' },
		-- CmpItemKindInterface     = { link = 'Constant' },
		-- CmpItemKindEvent         = { link = 'Constant' },
		-- CmpItemKindEnum          = { link = 'Constant' },
		-- CmpItemKindUnit          = { link = 'Constant' },
		-- CmpItemKindClass         = { link = 'Type' },
		-- CmpItemKindStruct        = { link = 'Type' },
		-- CmpItemKindModule        = { link = has_ts and '@namespace'  or 'Identifier' },
		-- CmpItemKindProperty      = { link = has_ts and '@property' or  'Identifier' },
		-- CmpItemKindField         = { link = has_ts and '@field' or 'Identifier' },
		-- CmpItemKindTypeParameter = { link = has_ts and '@field' or 'Identifier' },
		-- CmpItemKindEnumMember    = { link = has_ts and '@field' or 'Identifier' },
		-- CmpItemKindOperator      = { link = 'Operator' },
		-- CmpItemKindSnippet       = { fg = spec.fg2 },

		TreesitterContextBottom = { style = 'underline', sp = 'Grey' },
		TreesitterContextLineNumberBottom = { style = 'underline', sp = 'Grey' },

		-- https://github.com/zbirenbaum/copilot.lua
		CopilotSuggestion = { link = 'Identifier' },

		-- :h gitsigns-highlight-groups
		-- https://github.com/lewis6991/gitsigns.nvim
		GitSignsAdd    = { fg = spec.gitadd }, -- diff mode: Added line |diff.txt|
		GitSignsChange = { fg = spec.gitchange }, -- diff mode: Changed line |diff.txt|
		GitSignsDelete = { fg = spec.gitdelete }, -- diff mode: Deleted line |diff.txt|
		-- Word diff in previews
		GitSignsAddInline = { bg = spec.diff_word_add, fg = spec.diff_word_addfg },
		GitSignsDeleteInline = { bg = spec.diff_text },
		GitSignsChangeInline = { bg = spec.gitchange, fg = spec.fg1 },

		GitSignsAddPreview = { fg = spec.fg0, bg = spec.diff_add },
		GitSignsChangePreview = { fg = spec.diff_changefg, bg = spec.diff_change },
		GitSignsDeletePreview = { bg = spec.diff_delete },

		-- :h glance-glance-highlights
		-- https://github.com/dnlhc/glance.nvim
		GlanceListMatch = { spec.sel0 },
		GlanceListFilepath = { spec.fg3 },

		-- Headlines
		-- https://github.com/lukas-reineke/headlines.nvim
		Headline = { bg = spec.bg0 },
		CodeBlock = { bg = spec.bg2 },

		-- :h ibl.highlights
		-- lukas-reineke/indent-blankline.nvim
		IblScope = { style = 'nocombine', fg = pal.blue.base },
		IblIndent = { link = 'NonText' },
		IblWhitespace = { link = 'NonText' },

		-- :h illuminate-highlight-groups
		-- https://github.com/RRethy/vim-illuminate
		illuminatedWordText = { link = 'LspReferenceText' },
		illuminatedWordRead = { link = 'LspReferenceRead' },
		illuminatedWordWrite = { link = 'LspReferenceWrite' },

		-- :h incline-config-highlight
		-- https://github.com/b0o/incline.nvim
		-- InclineNormal = { fg = spec.fg1, bg = pal.black.base },
		InclineNormal = { fg = spec.fg1, bg = spec.bg2 },
		InclineNormalNC = { fg = syn.comment, bg = spec.bg2 },

		-- :h mini.indentscope
		-- https://github.com/nvim-mini/mini.indentscope
		MiniIndentscopeSymbol = { fg = pal.blue.base },

		NavicText = { fg = syn.comment, bg = spec.bg0 },
		NavicSeparator = { fg = syn.comment, bg = spec.bg0 },

		-- :h noice.nvim-noice-(nice,-noise,-notice)-highlight-groups
		-- https://github.com/folke/noice.nvim
		-- NoiceFormatProgressDone = {
		-- 	bg = trans and 'NONE' or U.darken(C.sky, 0.30, C.base),
		-- 	fg = C.subtext0,
		-- },
		-- NoiceFormatProgressTodo = {
		-- 	bg = trans and 'NONE'
		-- 		or U.vary_color({ latte = U.lighten(C.mantle, 0.70, C.base) }, U.darken(C.surface0, 0.64, C.base)),
		-- 	fg = C.subtext0,
		-- },

		-- :h lazy.nvim-lazy.nvim-highlight-groups
		-- https://github.com/folke/lazy.nvim
		LazyButtonActive = { bg = spec.diag_virtual_bg.ok },
		LazyDimmed = { fg = spec.fg3 },
		LazyProp = { link = 'Comment' },
		LazySpecial = { fg = pal.green:subtle() },
		LazyReasonEvent = { fg = pal.blue.base },
		LazyReasonKeys = { fg = spec.tabline },
		LazyReasonPlugin = { fg = spec.syntax.comment },
		LazyReasonSource = { fg = pal.magenta.base },
		LazyReasonFt = { fg = spec.fg2 },
		LazyReasonCmd = { fg = pal.cyan.base },

		-- :h lualine.txt
		-- https://github.com/nvim-lualine/lualine.nvim
		LuaLineDiffAdd = { fg = spec.lualineadd },
		LuaLineDiffChange = { fg = spec.lualinechange },
		LuaLineDiffDelete = { fg = spec.lualinedelete },

		-- :h marks-cmds
		-- https://github.com/chentau/marks.nvim
		MarkSignHL = { fg = pal.blue:harsh() }, -- #94b0c8

		-- :h mini.map
		-- https://github.com/nvim-mini/mini.map
		MiniMapNormal = { link = 'Comment' },
		MiniMapSymbolLine = { fg = spec.bg4 },
		MiniMapSymbolView = { fg = spec.bg4 },

		-- :h grug-far-highlights
		-- https://github.com/MagicDuck/grug-far.nvim
		GrugFarResultsPath = { fg = pal.blue.base },

		-- :h render-markdown.txt
		-- https://github.com/MeanderingProgrammer/render-markdown.nvim
		RenderMarkdownBullet = { fg = pal.brown.base },
		RenderMarkdownCode = { bg = spec.bg2 },
		RenderMarkdownCodeInline = { link = '@markup.raw.markdown_inline' },
		RenderMarkdownDash = { fg = pal.orange.base },
		RenderMarkdownH1Bg = { bg = '#2c314a' },
		RenderMarkdownH1 = { style = 'bold', fg = pal.blue.base },
		RenderMarkdownH2Bg = { bg = '#38343d' },
		RenderMarkdownH2 = { style = 'bold', fg = pal.yellow.base },
		RenderMarkdownH3Bg = { bg = '#32383f' },
		RenderMarkdownH3 = { style = 'bold', fg = pal.green.base },
		RenderMarkdownH4Bg = { bg = '#273644' },
		RenderMarkdownH4 = { style = 'bold', fg = pal.cyan.base },
		RenderMarkdownH5Bg = { bg = '#32304a' },
		RenderMarkdownH5 = { style = 'bold', fg = pal.magenta.base },
		RenderMarkdownH6Bg = { bg = '#383148' },
		RenderMarkdownH6 = { style = 'bold', fg = pal.magenta:harsh() },
		RenderMarkdownTableHead = { fg = pal.red.base },
		RenderMarkdownTableRow = { fg = pal.brown.base },

		-- :help neo-tree-highlights
		-- https://github.com/nvim-neo-tree/neo-tree.nvim
		NeoTreeNormal             = { fg = spec.fg1, bg = config.transparent and 'NONE' or spec.bg1 },
		NeoTreeNormalNC           = { fg = spec.fg1, (inactive and spec.bg3) or (trans and 'NONE') or spec.bg1 },
		NeoTreeIndentMarker       = { fg = spec.bg4 },
		NeoTreeCursorLine         = { link = 'WildMenu' },
		NeoTreeRootName           = { fg = spec.fg1, style = 'bold' },
		NeoTreeDirectoryName      = { fg = pal.blue.base },
		NeoTreeDirectoryIcon      = { fg = pal.blue.base },
		NeoTreeDotfile            = { fg = pal.blue:subtle() }, -- #6e8aa2
		NeoTreeSymbolicLinkTarget = { fg = pal.pink:subtle() }, -- #411d30
		NeoTreeFileName           = { fg = spec.fg2 },
		NeoTreeFileNameOpened     = { fg = spec.fg3 },
		NeoTreeDimText            = { link = 'Conceal' },
		NeoTreeGitAdded           = { fg = spec.neotreeadd },
		NeoTreeGitModified        = { fg = spec.neotreechange },
		NeoTreeGitDeleted         = { fg = spec.neotreedelete, },
		NeoTreeGitConflict        = { fg = pal.orange.base, style = 'italic' },
		NeoTreeGitIgnored         = { fg = spec.fg3 },
		NeoTreeGitUntracked       = { fg = pal.black:harsh() },

		-- Outline
		-- https://github.com/hedyhli/outline.nvim
		OutlineFoldMarker = { link = 'Comment' },

		-- Rainbow delimiters
		-- https://github.com/hiphish/rainbow-delimiters.nvim
		RainbowDelimiterBlue   = { fg = pal.blue.base },
		RainbowDelimiterCyan   = { fg = pal.cyan.base },
		RainbowDelimiterGreen  = { fg = pal.green.base },
		RainbowDelimiterOrange = { fg = pal.orange.base },
		RainbowDelimiterRed    = { fg = pal.red.base },
		RainbowDelimiterViolet = { fg = pal.magenta.base },
		RainbowDelimiterYellow = { fg = pal.yellow.base },

		-- Snacks
		-- https://github.com/folke/snacks.nvim
		SnacksIndentScope = { style = 'nocombine', fg = pal.blue.base },
		SnacksPickerDir = { link = 'Comment' },
		SnacksPickerMatch = { link = 'WildMenu' },
		SnacksPickerGitStatusModified = { link = 'NeoTreeGitModified' },
		SnacksPickerGitStatusUntracked = { link = 'Comment' },
		SnacksPickerGitStatusStaged = { link = 'GitSignsChange' },
		SnacksPickerPathHidden = { fg = spec.fg3 },

		-- https://github.com/rafi/tabstrip.nvim
		TabLineProject = { fg = spec.fg1, bg = spec.bg4 },

		-- Telescope
		-- https://github.com/nvim-telescope/telescope.nvim
		TelescopeNormal         = { link = 'NormalFloat' },
		TelescopeBorder         = { link = 'FloatBorder' },
		TelescopeSelectionCaret = { fg = pal.magenta.base, bg = pal.pink.base },
		TelescopeSelection      = { link = 'WildMenu' },
		TelescopePreviewLine    = { link = 'WildMenu' },
		TelescopeMatching       = { link = 'Search' },
		TelescopeTitle          = { link = 'FloatTitle' },

		-- :h which-key.nvim-which-key-colors
		-- https://github.com/folke/which-key.nvim
		WhichKey          = { link = 'Identifier' },
		WhichKeyGroup     = { link = 'Function' },
		WhichKeyDesc      = { link = 'Keyword' },
		WhichKeySeperator = { link = 'Comment' },
		WhichKeySeparator = { link = 'Comment' },
		WhichKeyFloat     = { bg = spec.bg0 },
		WhichKeyValue     = { link = 'Comment' },
	}

	for kind, fg in pairs(M.lsp_kinds(spec, config)) do
		theme['CmpItemKind' .. kind] = { fg = fg }
	end

	for kind, fg in pairs(M.lsp_kinds(spec, config)) do
		theme['NavicIcons' .. kind] = { fg = fg, bg = spec.bg0 }
	end

	for kind, fg in pairs(M.lsp_kinds(spec, config)) do
		theme['Aerial' .. kind .. 'Icon'] = { fg = fg }
	end

	for kind, fg in pairs(M.lsp_kinds(spec, config)) do
		theme['barbecue_context_' .. kind:lower()] = { fg = fg }
	end

	return theme
end

---@diagnostic disable-next-line: unused-local
function M.lsp_kinds(spec, config)
	local pal = spec.palette

	-- stylua: ignore
	return {
		Array         = pal.yellow.base,
		Boolean       = pal.yellow.base,
		Class         = pal.blue.base,
		Color         = pal.yellow.base,
		Constant      = pal.orange.base,
		Constructor   = pal.green.base,
		Default       = pal.blue.base,
		Enum          = pal.blue.base,
		EnumMember    = pal.magenta.base,
		Event         = pal.yellow.base,
		Field         = pal.green.base,
		File          = pal.green.base,
		Folder        = pal.yellow.base,
		Function      = pal.blue.base,
		Interface     = pal.blue.base,
		Key           = pal.red.base,
		Keyword       = pal.red.base,
		Method        = pal.green.base,
		Module        = pal.blue.base,
		Namespace     = pal.red.base,
		Null          = pal.yellow.base,
		Number        = pal.yellow.base,
		Object        = pal.magenta.base,
		Operator      = pal.green.base,
		Package       = pal.red.base,
		Property      = pal.orange.base,
		Reference     = pal.yellow.base,
		Snippet       = pal.yellow.base,
		String        = pal.yellow.base,
		Struct        = pal.blue.base,
		Text          = spec.fg1,
		TypeParameter = pal.blue.base,
		Unit          = pal.magenta.base,
		Value         = pal.magenta.base,
		Variable      = pal.orange.base,
	}
end

return M

-- Groups every theme defines: Neovim's UI groups, the Vim syntax groups,
-- LSP references and diagnostics.

local Util = require('morrow.util')

local M = {}

---@type morrow.HighlightsFn
function M.get(c, opts)
	local syn = c.syntax
	local d = c.diag
	local stl = opts.styles
	local trans = opts.transparent
	local mp = c.match_paren
	local normal_bg = trans and c.none or c.base
	-- NormalNC only when inactive windows are dimmed: when defined, it
	-- overrides unfocused plugin windows that map Normal through
	-- 'winhighlight' (Normal:NormalSB).
	local normal_nc
	if c.inactive.bg ~= normal_bg then
		normal_nc = { fg = c.text, bg = c.inactive.bg }
	end

	-- stylua: ignore
	return {
		-- Editor
		ColorColumn        = { bg = c.cursorline.bg }, -- 'colorcolumn'
		Conceal            = { fg = c.surface2 }, -- placeholders for concealed text
		Cursor             = { fg = c.base, bg = c.text }, -- character under the cursor
		lCursor            = 'Cursor', -- cursor when language-mapping is used
		CursorIM           = 'Cursor', -- cursor in IME mode
		CursorColumn       = 'CursorLine', -- 'cursorcolumn'
		CursorLine         = { bg = c.cursorline.bg }, -- 'cursorline'
		Directory          = { fg = syn.keyword }, -- directory names in listings
		DiffAdd            = { fg = c.diff.add_fg, bg = c.diff.add }, -- added line
		DiffChange         = { fg = c.diff.change_fg, bg = c.diff.change }, -- changed line
		DiffDelete         = { fg = c.diff.delete_fg, bg = c.diff.delete }, -- deleted line
		DiffText           = { fg = c.diff.text_fg, bg = c.diff.text }, -- changed text in a changed line
		DiffTextAdd        = { bg = c.diff.text_add }, -- added text in a changed line
		EndOfBuffer        = { fg = c.surface1 }, -- filler lines (~) after the buffer
		TermCursor         = { bg = c.magenta }, -- cursor in a focused terminal
		ErrorMsg           = { fg = d.error }, -- error messages
		WinSeparator       = { fg = c.separator.fg }, -- separators between windows
		VertSplit          = 'WinSeparator',
		Folded             = { fg = c.folded.fg, bg = c.folded.bg or c.cursorline.bg }, -- closed folds
		FoldColumn         = { fg = c.gutter.fg, bg = c.gutter.bg }, -- 'foldcolumn'
		SignColumn         = { fg = c.gutter.fg, bg = c.gutter.bg }, -- sign column
		SignColumnSB       = 'SignColumn',
		Substitute         = { fg = c.base, bg = d.error }, -- :substitute replacement text
		LineNr             = { fg = c.gutter.fg, bg = c.gutter.bg }, -- line numbers
		CursorLineNr       = { fg = d.warn, bg = c.gutter.bg, bold = true }, -- cursor line number
		MatchParen         = { fg = mp.fg, bg = mp.bg, sp = mp.sp, underline = mp.sp and true or nil, bold = mp.bold }, -- matching bracket
		ModeMsg            = { fg = d.ok, bold = true }, -- 'showmode' message
		OkMsg              = { fg = d.ok }, -- success messages
		MsgArea            = { bg = c.cmdline.bg }, -- cmdline and messages (ui2's cmd, dialog and pager windows)
		MsgSeparator       = { fg = c.cmdline.border, bg = c.cmdline.bg }, -- separator above scrolled messages
		MoreMsg            = { fg = d.ok, bold = true }, -- more-prompt
		NonText            = { fg = c.surface1 }, -- '@', 'showbreak' and similar characters
		Normal             = { fg = c.text, bg = normal_bg }, -- normal text
		NormalNC           = normal_nc, -- normal text in other windows
		NormalSB           = { fg = c.text, bg = c.sidebar.bg }, -- sidebars, via winhighlight
		NormalFloat        = { fg = c.text, bg = c.float.bg }, -- floating windows
		FloatBorder        = { fg = c.float.border, bg = c.float.bg },
		FloatTitle         = { fg = c.float.title, bg = c.float.bg },
		FloatFooter        = { fg = c.float.footer, bg = c.float.bg }, -- usually key hints
		Pmenu              = { fg = c.text, bg = c.pmenu.bg }, -- popup menu item
		PmenuSel           = { fg = c.pmenu.sel_fg, bg = c.pmenu.sel }, -- selected item
		PmenuSbar          = { bg = c.pmenu.sbar }, -- scrollbar
		PmenuThumb         = { bg = c.pmenu.thumb }, -- scrollbar thumb
		PmenuMatch         = { fg = syn.keyword }, -- matched text, as nvim-cmp and blink.cmp
		PmenuMatchSel      = { bold = true }, -- matched text in the selected item
		PmenuExtra         = { fg = syn.comment, bg = c.pmenu.bg }, -- extra text
		PmenuBorder        = { fg = c.pmenu.border, bg = c.pmenu.bg }, -- border, as blink.cmp's menu
		ComplHint          = { fg = c.overlay0 }, -- selected completion's virtual text, below comments
		ComplMatchIns      = { fg = syn.keyword }, -- inserted text of the selected completion
		Question           = 'MoreMsg', -- hit-enter and yes/no questions
		QuickFixLine       = { bg = c.selection }, -- current quickfix item
		Search             = { fg = c.search.fg, bg = c.search.bg }, -- 'hlsearch' matches
		IncSearch          = { fg = c.incsearch.fg, bg = c.incsearch.bg }, -- 'incsearch' and :s///c
		CurSearch          = 'IncSearch', -- match under the cursor
		SpecialKey         = 'NonText', -- unprintable characters
		SpellBad           = { sp = d.error, undercurl = true },
		SpellCap           = { sp = d.hint, undercurl = true },
		SpellLocal         = { sp = d.info, undercurl = true },
		SpellRare          = { sp = d.info, undercurl = true },
		StatusLine         = { fg = c.statusline.fg, bg = c.statusline.bg }, -- current window
		StatusLineNC       = { fg = c.statusline.fg_nc, bg = c.statusline.bg_nc or c.statusline.bg }, -- other windows
		TabLine            = { fg = c.tabline.fg, bg = c.tabline.bg }, -- inactive tab label
		TabLineFill        = { bg = c.tabline.fill }, -- tab line without labels
		TabLineSel         = { fg = c.tabline.sel_fg, bg = c.tabline.sel }, -- active tab label
		Title              = { fg = d.warn, bold = true }, -- titles in :set all, :autocmd
		Visual             = { bg = c.visual },
		VisualNOS          = 'Visual',
		WarningMsg         = { fg = d.warn },
		Whitespace         = { fg = c.surface1 }, -- 'listchars' whitespace, like NonText
		WildMenu           = { bg = c.selection }, -- current 'wildmenu' match
		WinBar             = { fg = c.winbar.fg, bg = trans and c.none or c.winbar.bg, bold = true },
		WinBarNC           = { fg = c.winbar.fg_nc or c.winbar.fg, bg = trans and c.none or c.winbar.bg_nc, bold = true },
		debugPC            = { bg = Util.blend_bg(d.warn, 0.2) }, -- terminal-debug line, like DapStoppedLine
		debugBreakpoint    = { fg = d.error },
		healthError        = { fg = d.error },
		healthWarning      = { fg = d.warn },
		healthSuccess      = { fg = d.ok },
		FloatShadow        = { bg = c.crust, blend = 80 },
		FloatShadowThrough = { bg = c.crust, blend = 100 },

		-- Syntax
		Comment        = { fg = syn.comment, style = stl.comments },
		Constant       = { fg = syn.const },
		String         = { fg = syn.string },
		Character      = 'String',
		Number         = { fg = syn.number },
		Float          = 'Number',
		Boolean        = 'Number',
		Identifier     = { fg = syn.identifier, style = stl.variables },
		Function       = { fg = syn.func, style = stl.functions },
		Statement      = { fg = syn.keyword },
		Conditional    = { fg = syn.keyword, style = stl.keywords },
		Repeat         = 'Conditional',
		Label          = { fg = syn.label },
		Operator       = { fg = syn.operator },
		Keyword        = { fg = syn.keyword, style = stl.keywords },
		Exception      = 'Keyword',
		PreProc        = { fg = syn.preproc },
		Include        = 'PreProc',
		Define         = 'PreProc',
		Macro          = 'PreProc',
		PreCondit      = 'PreProc',
		Type           = { fg = syn.type },
		StorageClass   = 'Type',
		Structure      = { fg = syn.structure },
		Typedef        = 'Type',
		Special        = { fg = syn.special },
		SpecialChar    = 'Special',
		Tag            = { fg = syn.tag },
		Delimiter      = { fg = syn.punct },
		SpecialComment = 'Special',
		Debug          = 'Special',
		Underlined     = { underline = true },
		Bold           = { bold = true },
		Italic         = { italic = true },
		Error          = { fg = d.error },
		Todo           = { fg = syn.todo, bg = syn.todo_bg },
		qfLineNr       = { fg = d.warn },
		qfFileName     = 'Directory',
		Added          = { fg = c.green }, -- diff filetype
		Removed        = { fg = c.red },
		Changed        = { fg = c.blue },
		diffAdded      = { fg = c.diff.add_fg, bg = c.diff.add },
		diffRemoved    = { fg = c.diff.delete_fg, bg = c.diff.delete },
		diffChanged    = { fg = c.diff.change_fg, bg = c.diff.change },
		diffOldFile    = { fg = c.yellow },
		diffNewFile    = { fg = c.orange },
		diffFile       = { fg = c.blue },
		diffLine       = { fg = syn.comment },
		diffIndexLine  = { fg = c.magenta },
		helpExample    = { fg = syn.comment },

		-- LSP
		LspReferenceText            = { bg = c.surface1 },
		LspReferenceRead            = { bg = c.ref.read },
		LspReferenceWrite           = { bg = c.ref.write },
		LspReferenceTarget          = { fg = c.search.fg, bg = c.search.bg },
		LspCodeLens                 = { fg = syn.comment },
		LspCodeLensSeparator        = { fg = c.overlay2 },
		LspSignatureActiveParameter = { fg = c.blue, bold = true },
		LspInlayHint                = { fg = c.inlay },

		-- Diagnostics
		DiagnosticError            = { fg = d.error },
		DiagnosticWarn             = { fg = d.warn },
		DiagnosticInfo             = { fg = d.info },
		DiagnosticHint             = { fg = d.hint },
		DiagnosticOk               = { fg = d.ok },
		DiagnosticSignError        = 'DiagnosticError',
		DiagnosticSignWarn         = 'DiagnosticWarn',
		DiagnosticSignInfo         = 'DiagnosticInfo',
		DiagnosticSignHint         = 'DiagnosticHint',
		DiagnosticSignOk           = 'DiagnosticOk',
		DiagnosticVirtualTextError = { fg = d.error, bg = Util.blend_bg(d.error, 0.2) },
		DiagnosticVirtualTextWarn  = { fg = d.warn, bg = Util.blend_bg(d.warn, 0.2) },
		DiagnosticVirtualTextInfo  = { fg = d.info, bg = Util.blend_bg(d.info, 0.2) },
		DiagnosticVirtualTextHint  = { fg = d.hint, bg = Util.blend_bg(d.hint, 0.2) },
		DiagnosticVirtualTextOk    = { fg = d.ok, bg = Util.blend_bg(d.ok, 0.2) },
		DiagnosticUnderlineError   = { sp = d.error, undercurl = true },
		DiagnosticUnderlineWarn    = { sp = d.warn, undercurl = true },
		DiagnosticUnderlineInfo    = { sp = d.info, undercurl = true },
		DiagnosticUnderlineHint    = { sp = d.hint, undercurl = true },
		DiagnosticUnderlineOk      = { sp = d.ok, undercurl = true },
		DiagnosticDeprecated       = { sp = d.error, strikethrough = true },
		DiagnosticUnnecessary      = 'Comment',
	}
end

return M

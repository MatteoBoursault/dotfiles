-- =============================================================================
-- PLUGINS
-- =============================================================================

-- vim.pack.add() : déclare les plugins (clone si absent, met à jour sur :PackUpdate)
vim.pack.add({
	"https://www.github.com/echasnovski/mini.nvim",
	"https://www.github.com/ibhagwan/fzf-lua",
	"https://www.github.com/nvim-tree/nvim-tree.lua",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
	-- Stack LSP / complétion
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/creativenull/efmls-configs-nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
	"https://github.com/L3MON4D3/LuaSnip",
})

-- packadd : charge effectivement chaque plugin dans le runtime.
for _, name in ipairs({
	"nvim-treesitter",
  "mini.nvim",
  "fzf-lua",
  "nvim-tree.lua",
	"nvim-lspconfig",
  "mason.nvim",
  "efmls-configs-nvim",
  "blink.cmp",
  "LuaSnip",
}) do
	vim.cmd("packadd " .. name)
end

-- =============================================================================
-- OPTIONS
-- =============================================================================

vim.opt.mouse = ""

-- Apparence
vim.cmd.colorscheme("desert")
vim.opt.termguicolors = true
vim.opt.background    = "dark"

-- Numérotation & curseur
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.cursorline     = true
vim.opt.wrap           = false
vim.opt.scrolloff      = 10
vim.opt.sidescrolloff  = 10

-- Indentation
vim.opt.tabstop     = 2
vim.opt.shiftwidth  = 2
vim.opt.softtabstop = 2
vim.opt.expandtab   = true
vim.opt.smartindent = true
vim.opt.autoindent  = true

-- Recherche
vim.opt.ignorecase = true
vim.opt.smartcase  = true
vim.opt.incsearch  = true
vim.opt.hlsearch   = false

-- UI / divers
vim.opt.signcolumn    = "yes"
vim.opt.colorcolumn   = "120"
vim.opt.showmatch     = true
vim.opt.cmdheight     = 1
vim.opt.completeopt   = "menuone,noinsert,noselect"
vim.opt.showmode      = false
vim.opt.pumheight     = 10
vim.opt.pumblend      = 10
vim.opt.winblend      = 0
vim.opt.conceallevel  = 0
vim.opt.concealcursor = ""
vim.opt.fillchars     = { eob = " " }

-- Persistance des undos
local undodir = vim.fn.expand("~/.vim/undodir")
if vim.fn.isdirectory(undodir) == 0 then
	vim.fn.mkdir(undodir, "p")
end

vim.opt.backup      = false
vim.opt.writebackup = false
vim.opt.swapfile    = false
vim.opt.undofile    = true
vim.opt.undodir     = undodir
vim.opt.updatetime  = 300
vim.opt.timeoutlen  = 500
vim.opt.ttimeoutlen = 50
vim.opt.autoread    = true
vim.opt.autowrite   = false

vim.opt.hidden     = true
vim.opt.errorbells = false
vim.opt.backspace  = "indent,eol,start"
vim.opt.autochdir  = false
vim.opt.iskeyword:append("-")
vim.opt.path:append("**")
vim.opt.selection  = "inclusive"
vim.opt.clipboard:append("unnamedplus")
vim.opt.modifiable = true
vim.opt.encoding   = "utf-8"

vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

-- Folding via Treesitter
vim.opt.foldmethod = "expr"
vim.opt.foldexpr   = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel  = 99

-- Splits & wildmenu
vim.opt.splitbelow    = true
vim.opt.splitright    = true
vim.opt.wildmenu      = true
vim.opt.wildmode      = "longest:full,full"
vim.opt.diffopt:append("linematch:60")
vim.opt.redrawtime    = 10000
vim.opt.maxmempattern = 20000

-- =============================================================================
-- HELPERS
-- =============================================================================

local map = vim.keymap.set
local function nmap(lhs, rhs, desc)  map("n",          lhs, rhs, { desc = desc, silent = true, noremap = true }) end
local function vmap(lhs, rhs, desc)  map("v",          lhs, rhs, { desc = desc, silent = true, noremap = true }) end
local function nvmap(lhs, rhs, desc) map({ "n", "v" }, lhs, rhs, { desc = desc, silent = true, noremap = true }) end

-- =============================================================================
-- STATUSLINE
-- =============================================================================

-- Branche git — 100 % async via vim.system(), jamais bloquante dans le redraw.
-- La fonction git_branch() ne fait que LIRE le cache ; le rafraîchissement
-- se déclenche sur quelques événements ponctuels.
local cached_branch = ""
local refreshing    = false
local function refresh_git_branch()
	if refreshing then return end
	refreshing = true
	vim.system(
		{ "git", "branch", "--show-current" },
		{ text = true },
		vim.schedule_wrap(function(obj)
			refreshing = false
			cached_branch = (obj.code == 0) and (obj.stdout or ""):gsub("\n", "") or ""
			vim.cmd("redrawstatus")
		end)
	)
end

local function git_branch()
	return cached_branch ~= "" and (" \u{e725} " .. cached_branch .. " ") or ""
end

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "DirChanged" }, {
	callback = refresh_git_branch,
})

-- Type de fichier + icône via mini.icons
local function file_type()
	local ft = vim.bo.filetype
	if ft == "" then return MiniIcons.get("default", "file") .. " " end
	return MiniIcons.get("filetype", ft) .. " " .. ft .. " "
end

-- Taille du fichier formatée
local function file_size()
	local size = vim.fn.getfsize(vim.fn.expand("%"))
	if size < 0 then return "" end
	if size < 1024 then return string.format(" \u{f016} %dB ", size) end
	if size < 1024 * 1024 then return string.format(" \u{f016} %.1fK ", size / 1024) end
	return string.format(" \u{f016} %.1fM ", size / 1024 / 1024)
end

-- Indicateur de mode (NORMAL / INSERT / VISUAL / ...)
local mode_map = {
	n      = " \u{f121}  NORMAL",
	i      = " \u{f11c}  INSERT",
	v      = " \u{f0168} VISUAL",
	V      = " \u{f0168} V-LINE",
	["\22"]= " \u{f0168} V-BLOCK", -- \22 = Ctrl-V
	c      = " \u{f120} COMMAND",
	s      = " \u{f0c5} SELECT",
	S      = " \u{f0c5} S-LINE",
	["\19"]= " \u{f0c5} S-BLOCK",  -- \19 = Ctrl-S
	R      = " \u{f044} REPLACE",
	r      = " \u{f044} REPLACE",
	["!"]  = " \u{f489} SHELL",
	t      = " \u{f120} TERMINAL",
}
local function mode_icon()
	return mode_map[vim.fn.mode()] or (" \u{f059} " .. vim.fn.mode())
end

-- Exposition globale pour pouvoir appeler ces fonctions depuis 'statusline'
_G.mode_icon  = mode_icon
_G.git_branch = git_branch
_G.file_type  = file_type
_G.file_size  = file_size

vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

local statusline = table.concat({
	"  ",
	"%#StatusLineBold#%{v:lua.mode_icon()}%#StatusLine#",
	" \u{e0b1} %f %h%m%r",                  -- ▏ + nom de fichier + flags
	"%{v:lua.git_branch()}",
	"\u{e0b1} %{v:lua.file_type()}",
	"\u{e0b1} %{v:lua.file_size()}",
	"%=",                                   -- aligne ce qui suit à droite
	" \u{f017} %l:%c  %P ",                 -- ligne:colonne + pourcentage
})

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	callback = function() vim.opt_local.statusline = statusline end,
})

-- =============================================================================
-- KEYMAPS
-- =============================================================================

vim.g.mapleader      = " "
vim.g.maplocalleader = " "

-- Recherche & demi-pages centrées
nmap("l",     "nzzzv",   "Résultat suivant (centré)")
nmap("L",     "Nzzzv",   "Résultat précédent (centré)")
nmap("<C-d>", "<C-d>zz", "Demi-page bas (centré)")
nmap("<C-u>", "<C-u>zz", "Demi-page haut (centré)")

-- Buffers
nmap("<leader>bl", ":bnext<CR>",     "Buffer suivant")
nmap("<leader>bp", ":bprevious<CR>", "Buffer précédent")

-- Navigation
map({ "n", "v" }, "t", function() return vim.v.count == 0 and "gj" or "j" end,
	{ expr = true, silent = true, noremap = true, desc = "Down (wrap-aware)" })
map({ "n", "v" }, "n", function() return vim.v.count == 0 and "gk" or "k" end,
	{ expr = true, silent = true, noremap = true, desc = "Up (wrap-aware)" })
nvmap("s", "l", "Right")

-- Splits
nmap("<leader>sv", ":vsplit<CR>", "Split vertical")
nmap("<leader>sh", ":split<CR>",  "Split horizontal")
nmap("<C-h>",      "<C-w>h",      "Fenêtre à gauche")
nmap("<C-t>",      "<C-w>j",      "Fenêtre du bas")
nmap("<C-n>",      "<C-w>k",      "Fenêtre du haut")
nmap("<C-s>",      "<C-w>l",      "Fenêtre à droite")

-- Resize
nmap("<C-Up>",    ":resize +2<CR>",          "Hauteur +")
nmap("<C-Down>",  ":resize -2<CR>",          "Hauteur -")
nmap("<C-Left>",  ":vertical resize -2<CR>", "Largeur -")
nmap("<C-Right>", ":vertical resize +2<CR>", "Largeur +")

-- Indentation visuelle persistante
vmap("<", "<gv", "Désindenter et reselectionner")
vmap(">", ">gv", "Indenter et reselectionner")

-- Divers
nmap("J", "mzJ`z", "Joindre les lignes en gardant la position du curseur")

nmap("<leader>td", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end,	"Toggle diagnostics")

nmap("<leader>q", ":q!<CR>", "Quitter (force)")
nmap("<leader>w", ":wq<CR>", "Sauver et quitter")

-- =============================================================================
-- AUTOCOMMANDS
-- =============================================================================

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Format on save (uniquement les vrais buffers de fichier, et seulement si
-- efm-langserver est attaché). Évite les prompts d'écriture sur les buffers
-- spéciaux (terminaux, quickfix, etc.).
vim.api.nvim_create_autocmd("BufWritePre", {
	group = augroup,
	pattern = {
		"*.lua","*.py","*.go","*.js","*.jsx","*.ts","*.tsx","*.json",
		"*.css","*.scss","*.html","*.sh","*.bash","*.zsh",
		"*.c","*.cpp","*.h","*.hpp",
	},
	callback = function(args)
		-- Filtres défensifs
		if vim.bo[args.buf].buftype ~= "" then return end            -- buffer non-fichier
		if not vim.bo[args.buf].modifiable then return end           -- read-only
		if vim.api.nvim_buf_get_name(args.buf) == "" then return end -- pas de nom

		local has_efm = false
		for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
			if c.name == "efm" then has_efm = true; break end
		end
		if not has_efm then return end

		pcall(vim.lsp.buf.format, {
			bufnr      = args.buf,
			timeout_ms = 2000,
			filter     = function(c) return c.name == "efm" end,
		})
	end,
})

-- Flash visuel après un yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function() vim.hl.on_yank() end,
})

-- Restaure la position du curseur à l'ouverture d'un fichier
-- (utilise le mark `"` placé automatiquement par Vim à la dernière position).
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then return end
		local last_pos  = vim.api.nvim_buf_get_mark(0, '"')
		local last_line = vim.api.nvim_buf_line_count(0)
		if last_pos[1] < 1 or last_pos[1] > last_line then return end
		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

-- Wrap + linebreak pour les types texte
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap      = true
		vim.opt_local.linebreak = true
	end,
})

-- =============================================================================
-- PLUGIN CONFIGS
-- =============================================================================

-- nvim-treesitter
-- Installe les parsers manquants au démarrage et active treesitter sur les
-- filetypes pour lesquels un parser est dispo.
do
	local treesitter = require("nvim-treesitter")
	treesitter.setup({})

	local ensure_installed = {
		"vim", "vimdoc", "rust", "c", "cpp", "go", "html", "css",
		"javascript", "json", "lua", "markdown", "python",
		"typescript", "vue", "svelte", "bash",
	}
	local already = require("nvim-treesitter.config").get_installed()
	local todo = {}
	for _, p in ipairs(ensure_installed) do
		if not vim.tbl_contains(already, p) then table.insert(todo, p) end
	end
	if #todo > 0 then treesitter.install(todo) end

	local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
				vim.treesitter.start(args.buf)
			end
		end,
	})
end

-- nvim-tree
require("nvim-tree").setup({
	view     = { width = 35 },
	filters  = { dotfiles = false },
	renderer = { group_empty = true },
})
nmap("<leader>e", function() require("nvim-tree.api").tree.toggle() end, "Toggle NvimTree")

-- fzf-lua
local fzf = require("fzf-lua")
fzf.setup({})

nmap("<leader>ff", fzf.files,                 "FZF Files")
nmap("<leader>fg", fzf.live_grep,             "FZF Live Grep")
nmap("<leader>fb", fzf.buffers,               "FZF Buffers")
nmap("<leader>fh", fzf.help_tags,             "FZF Help Tags")
nmap("<leader>fx", fzf.diagnostics_document,  "FZF Diags Doc")
nmap("<leader>fX", fzf.diagnostics_workspace, "FZF Diags WS")

-- Écosystème mini.nvim
require("mini.comment").setup({})         -- gcc, gc<motion>
require("mini.move").setup({
	mappings = {
		left       = "<A-h>",
    down       = "<A-t>",
    up         = "<A-n>",
    right      = "<A-s>",
		line_left  = "<A-h>",
    line_down  = "<A-t>",
    line_up    = "<A-n>",
    line_right = "<A-s>",
	},
	options = { reindent_linewise = true },
})
require("mini.trailspace").setup({})      -- highlight des espaces de fin de ligne
require("mini.notify").setup({})          -- vim.notify non bloquant
require("mini.icons").setup({})           -- icônes (consommé par nvim-tree, fzf-lua, statusline)

-- =============================================================================
-- LSP, LINTING, FORMATTING & COMPLETION
-- =============================================================================

require("mason").setup({}) -- gestionnaire d'installation de LSP/linters/formatters

-- Diagnostics
local diagnostic_signs = { Error = " ", Warn = " ", Hint = "", Info = "" }

vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 4 },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
			[vim.diagnostic.severity.WARN]  = diagnostic_signs.Warn,
			[vim.diagnostic.severity.INFO]  = diagnostic_signs.Info,
			[vim.diagnostic.severity.HINT]  = diagnostic_signs.Hint,
		},
	},
	underline        = true,
	update_in_insert = false,
	severity_sort    = true,
	float = {
		source    = "always",
    header    = "",
    prefix    = "",
		focusable = false,
    style     = "minimal",
	},
})

nmap("<leader>Q",  function() vim.diagnostic.setloclist({ open = true }) end, "Liste des diagnostics")
nmap("<leader>dl", vim.diagnostic.open_float, "Diag de la ligne")

-- on_attach : keymaps appliqués UNIQUEMENT aux buffers où un LSP s'attache
local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then return end
	local bufnr = ev.buf

	local function bmap(lhs, rhs, desc)
		map("n", lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
	end

	-- Goto / refactor
	bmap("<leader>gd", function() fzf.lsp_definitions({ jump_to_single_result = true }) end,  "Definition (fzf)")
	bmap("<leader>gD", vim.lsp.buf.definition,                                                "Definition")
	bmap("<leader>gS", function() vim.cmd("vsplit"); vim.lsp.buf.definition() end,            "Definition (vsplit)")
	bmap("<leader>ca", vim.lsp.buf.code_action,                                               "Code action")
	bmap("<leader>rn", vim.lsp.buf.rename,                                                    "Rename")
	bmap("K",          vim.lsp.buf.hover,                                                     "Hover")

	-- Diagnostics ciblés
	bmap("<leader>D",  function() vim.diagnostic.open_float({ scope = "line"   }) end, "Diag ligne")
	bmap("<leader>d",  function() vim.diagnostic.open_float({ scope = "cursor" }) end, "Diag curseur")
	bmap("<leader>nd", function() vim.diagnostic.jump({ count =  1 }) end,             "Diag suivant")
	bmap("<leader>pd", function() vim.diagnostic.jump({ count = -1 }) end,             "Diag précédent")

	-- Recherches LSP via fzf
	bmap("<leader>fd", function() fzf.lsp_definitions({ jump_to_single_result = true }) end, "Definitions")
	bmap("<leader>fr", fzf.lsp_references,                                                   "References")
	bmap("<leader>ft", fzf.lsp_typedefs,                                                     "Type defs")
	bmap("<leader>fs", fzf.lsp_document_symbols,                                             "Document symbols")
	bmap("<leader>fw", fzf.lsp_workspace_symbols,                                            "Workspace symbols")
	bmap("<leader>fi", fzf.lsp_implementations,                                              "Implementations")

	-- Organize imports + format dans la foulée
	if client:supports_method("textDocument/codeAction", bufnr) then
		bmap("<leader>oi", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.organizeImports" }, diagnostics = {} },
				apply = true, bufnr = bufnr,
			})
			vim.defer_fn(function() vim.lsp.buf.format({ bufnr = bufnr }) end, 50)
		end, "Organize imports")
	end
end

vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

-- blink.cmp (moteur de complétion)
require("blink.cmp").setup({
	keymap = {
		preset        = "none",
		["<C-Space>"] = { "show", "hide" },
		["<CR>"]      = { "accept", "fallback" },
		["<A-l>"]     = { "select_next", "fallback" },
		["<A-p>"]     = { "select_prev", "fallback" },
		["<Tab>"]     = { "snippet_forward", "fallback" },
		["<S-Tab>"]   = { "snippet_backward", "fallback" },
	},
	appearance = { nerd_font_variant = "mono" },
	completion = { menu = { auto_show = true } },
	sources    = { default = { "lsp", "path", "buffer", "snippets" } },
	snippets   = { expand = function(snippet) require("luasnip").lsp_expand(snippet) end },
	fuzzy      = { implementation = "prefer_rust", prebuilt_binaries = { download = true } },
})

-- Capabilities LSP par défaut, enrichies par blink.cmp
vim.lsp.config["*"] = {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
}

-- efm-langserver : "umbrella" qui agrège linters et formatters externes
-- (un seul client LSP pour flake8, prettier, stylua, etc.)
local efm_config
do
	local luacheck     = require("efmls-configs.linters.luacheck")
	local stylua       = require("efmls-configs.formatters.stylua")
	local flake8       = require("efmls-configs.linters.flake8")
	local black        = require("efmls-configs.formatters.black")
	local eslint_d     = require("efmls-configs.linters.eslint_d")
	local prettier_d   = require("efmls-configs.formatters.prettier_d")
	local fixjson      = require("efmls-configs.formatters.fixjson")
	local shellcheck   = require("efmls-configs.linters.shellcheck")
	local shfmt        = require("efmls-configs.formatters.shfmt")
	local cpplint      = require("efmls-configs.linters.cpplint")
	local clang_format = require("efmls-configs.formatters.clang_format")
	local rustfmt      = require("efmls-configs.formatters.rustfmt")
	local markdownlint = require("efmls-configs.linters.markdownlint")

	efm_config = {
		filetypes = {
			"c", "cpp", "css", "go", "html", "javascript", "javascriptreact",
			"json", "jsonc", "lua", "markdown", "python", "rust", "sh",
			"typescript", "typescriptreact", "vue", "svelte",
		},
		init_options = { documentFormatting = true },
		settings = {
			languages = {
				c               = { clang_format, cpplint },
				cpp             = { clang_format, cpplint },
				css             = { prettier_d },
				html            = { prettier_d },
				javascript      = { eslint_d, prettier_d },
				javascriptreact = { eslint_d, prettier_d },
				json            = { eslint_d, fixjson },
				jsonc           = { eslint_d, fixjson },
				lua             = { luacheck, stylua },
				markdown        = { markdownlint },
				rust            = { rustfmt },
				python          = { flake8, black },
				sh              = { shellcheck, shfmt },
				typescript      = { eslint_d, prettier_d },
				typescriptreact = { eslint_d, prettier_d },
				vue             = { eslint_d, prettier_d },
				svelte          = { eslint_d, prettier_d },
			},
		},
	}
end

-- Configurations LSP par langage (source de vérité unique : la table `servers`)
local servers = {
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
				telemetry   = { enable = false },
			},
		},
	},
	pyright       = {},
	bashls        = {},
	ts_ls         = {},
	rust_analyzer = {},
	clangd        = {},
	marksman      = {},
	efm           = efm_config,
}

for name, cfg in pairs(servers) do vim.lsp.config(name, cfg) end
vim.lsp.enable(vim.tbl_keys(servers))

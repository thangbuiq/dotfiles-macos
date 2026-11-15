local o = vim.opt

o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
o.termguicolors = true
o.laststatus = 3
o.showmode = false
o.shortmess:append("I")
o.cmdheight = 1
o.winborder = "rounded"
o.pumheight = 12
o.pumblend = 10
o.scrolloff = 8
o.sidescrolloff = 8
o.wrap = false
o.linebreak = true
o.breakindent = true
o.colorcolumn = "100"
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
o.fillchars = { eob = " ", fold = " ", foldopen = "▾", foldclose = "▸", foldsep = " " }

o.clipboard = "unnamedplus"
o.mouse = "a"
o.undofile = true
o.swapfile = false
o.confirm = true
o.autowrite = true
o.updatetime = 200
o.timeoutlen = 300

o.ignorecase = true
o.smartcase = true
o.inccommand = "split"
o.grepprg = "rg --vimgrep --smart-case"
o.grepformat = "%f:%l:%c:%m"

o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true
o.shiftround = true

o.splitright = true
o.splitbelow = true
o.splitkeep = "screen"

o.completeopt = "menu,menuone,noselect"
o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldlevel = 99
o.foldlevelstart = 99
o.foldtext = ""

o.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

vim.g.autoformat = true

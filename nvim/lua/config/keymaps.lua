local map = function(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Windows
map("n", "<C-h>", "<C-w>h", "Go to left window")
map("n", "<C-j>", "<C-w>j", "Go to lower window")
map("n", "<C-k>", "<C-w>k", "Go to upper window")
map("n", "<C-l>", "<C-w>l", "Go to right window")
map("n", "<C-Up>", "<cmd>resize +2<cr>", "Increase window height")
map("n", "<C-Down>", "<cmd>resize -2<cr>", "Decrease window height")
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", "Decrease window width")
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", "Increase window width")
map("n", "<leader>-", "<C-w>s", "Split below")
map("n", "<leader>|", "<C-w>v", "Split right")

-- Buffers / tabs
map("n", "<S-h>", "<cmd>bprevious<cr>", "Prev buffer")
map("n", "<S-l>", "<cmd>bnext<cr>", "Next buffer")
map("n", "<leader>bb", "<cmd>e #<cr>", "Alternate buffer")
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", "New tab")
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", "Close tab")
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", "Next tab")
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", "Prev tab")

-- Editing
map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>w<cr><esc>", "Save file")
map("n", "<esc>", "<cmd>nohlsearch<cr><esc>", "Clear search highlight")
map("n", "<A-j>", "<cmd>m .+1<cr>==", "Move line down")
map("n", "<A-k>", "<cmd>m .-2<cr>==", "Move line up")
map("v", "<A-j>", ":m '>+1<cr>gv=gv", "Move selection down")
map("v", "<A-k>", ":m '<-2<cr>gv=gv", "Move selection up")
map("v", "<", "<gv", "Indent left")
map("v", ">", ">gv", "Indent right")
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", "Down", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", "Up", { expr = true, silent = true })
map("x", "p", [["_dP]], "Paste without yanking selection")
map("n", "n", "'Nn'[v:searchforward].'zv'", "Next search", { expr = true })
map("n", "N", "'nN'[v:searchforward].'zv'", "Prev search", { expr = true })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", "Quit all")
map("n", "<leader>w", "<cmd>w<cr>", "Write")

-- Diagnostics (the rest of the LSP keys live in plugins/lsp.lua)
map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev diagnostic")
map("n", "]e", function() vim.diagnostic.jump({ count = 1, severity = "ERROR", float = true }) end, "Next error")
map("n", "[e", function() vim.diagnostic.jump({ count = -1, severity = "ERROR", float = true }) end, "Prev error")

-- Quickfix
map("n", "]q", "<cmd>cnext<cr>", "Next quickfix")
map("n", "[q", "<cmd>cprev<cr>", "Prev quickfix")

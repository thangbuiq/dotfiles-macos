return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
          explorer = { hidden = true, ignored = true },
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      terminal = { enabled = true },
      lazygit = { enabled = true },
    },
    keys = {
      -- Top level
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart find files" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command history" },
      { "<leader>e", function() Snacks.explorer() end, desc = "File explorer" },
      -- Find
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find git files" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Config files" },
      { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      -- Search
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Word / selection", mode = { "n", "x" } },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer lines" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help pages" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume last picker" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo history" },
      { "<leader>sc", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      { "<leader>s\"", function() Snacks.picker.registers() end, desc = "Registers" },
      { "<leader>sn", function() Snacks.picker.notifications() end, desc = "Notifications" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix list" },
      -- Git
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gl", function() Snacks.lazygit.log_file() end, desc = "Lazygit file log" },
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Branches" },
      { "<leader>gL", function() Snacks.picker.git_log() end, desc = "Git log" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git status" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Open in browser", mode = { "n", "v" } },
      -- LSP navigation (pickers)
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto declaration" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto type definition" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Workspace symbols" },
      -- Misc
      { "<C-/>", function() Snacks.terminal() end, desc = "Toggle terminal", mode = { "n", "t" } },
      { "<C-_>", function() Snacks.terminal() end, desc = "which_key_ignore", mode = { "n", "t" } },
      { "<leader>tt", function() Snacks.terminal() end, desc = "Terminal" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
      { "<leader>bD", function() Snacks.bufdelete.other() end, desc = "Delete other buffers" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
      { "<leader>z", function() Snacks.zen() end, desc = "Zen mode" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference", mode = { "n", "t" } },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          _G.dd = function(...) Snacks.debug.inspect(...) end
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle({
            name = "Auto format",
            get = function() return vim.g.autoformat end,
            set = function(state) vim.g.autoformat = state end,
          }):map("<leader>uf")
        end,
      })
    end,
  },
}

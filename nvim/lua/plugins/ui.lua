return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      color_overrides = {
        mocha = { base = "#0f0f17", mantle = "#0b0b12", crust = "#07070c" },
      },
      integrations = {
        blink_cmp = true,
        flash = true,
        gitsigns = true,
        mason = true,
        native_lsp = { enabled = true },
        noice = false,
        snacks = { enabled = true },
        treesitter = true,
        trouble = true,
        which_key = true,
        dap = true,
        dap_ui = true,
        diffview = true,
        bufferline = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  { "echasnovski/mini.icons", lazy = true, opts = {}, init = function()
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "catppuccin-mocha",
        globalstatus = true,
        component_separators = "",
        section_separators = "",
        disabled_filetypes = { statusline = { "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          { "diagnostics" },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1 },
        },
        lualine_x = {
          {
            function() return require("dap").status() end,
            cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
          },
          { "diff" },
        },
        lualine_y = { "lsp_status", "progress" },
        lualine_z = { "location" },
      },
      extensions = { "lazy", "mason", "trouble", "quickfix" },
    },
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "catppuccin" },
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
      { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Close unpinned buffers" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
      { "[b", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
      { "]b", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
    },
    opts = function()
      return {
        highlights = require("catppuccin.special.bufferline").get_theme(),
        options = {
          always_show_bufferline = false,
          close_command = function(n) Snacks.bufdelete(n) end,
          diagnostics = "nvim_lsp",
          offsets = {
            { filetype = "snacks_layout_box" },
          },
        },
      }
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "test/terminal" },
        { "<leader>u", group = "ui/toggle" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "<leader><tab>", group = "tabs" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "z", group = "fold" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
    },
  },
}

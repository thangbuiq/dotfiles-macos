local parsers = {
  "bash", "c", "css", "diff", "dockerfile", "go", "gomod", "html", "javascript", "jsdoc", "json",
  "lua", "luadoc", "markdown", "markdown_inline", "python", "query", "regex", "rust", "sql",
  "toml", "tsx", "typescript", "vim", "vimdoc", "yaml", "gitcommit", "git_config", "gitignore",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(ev)
          if not vim.treesitter.language.get_lang(ev.match) then return end
          if pcall(vim.treesitter.start, ev.buf) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = { max_lines = 3, mode = "cursor" },
    keys = {
      { "<leader>uc", "<cmd>TSContext toggle<cr>", desc = "Toggle sticky context" },
    },
  },
}

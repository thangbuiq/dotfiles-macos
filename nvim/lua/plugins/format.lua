return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        mode = { "n", "v" },
        desc = "Format",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        sql = { "sqlfluff" },
      },
      format_on_save = function(buf)
        if not vim.g.autoformat or vim.b[buf].autoformat == false then return end
        return { timeout_ms = 2000, lsp_format = "fallback" }
      end,
      formatters = {
        shfmt = { prepend_args = { "-i", "2", "-ci" } },
        sqlfluff = { args = { "format", "--dialect", "sparksql", "-" } },
      },
    },
  },
}

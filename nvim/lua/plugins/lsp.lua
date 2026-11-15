local servers = {
  "lua_ls", "basedpyright", "ruff", "vtsls", "jsonls", "yamlls", "bashls", "taplo",
  "marksman", "rust_analyzer", "html", "cssls", "dockerls",
}

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = { ui = { border = "rounded" } } },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      vim.diagnostic.config({
        severity_sort = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
        float = { border = "rounded", source = true },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "\u{f057} ",
            [vim.diagnostic.severity.WARN] = "\u{f071} ",
            [vim.diagnostic.severity.INFO] = "\u{f05a} ",
            [vim.diagnostic.severity.HINT] = "\u{f0eb} ",
          },
        },
      })

      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
            diagnostics = { globals = { "vim", "Snacks" } },
            hint = { enable = true },
            workspace = { checkThirdParty = false },
          },
        },
      })
      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            disableOrganizeImports = true, -- ruff handles it
            analysis = { typeCheckingMode = "standard", autoImportCompletions = true },
          },
        },
      })
      vim.lsp.config("ruff", {
        on_attach = function(client) client.server_capabilities.hoverProvider = false end,
      })
      vim.lsp.config("vtsls", {
        settings = {
          typescript = { inlayHints = { parameterNames = { enabled = "literals" } } },
          javascript = { inlayHints = { parameterNames = { enabled = "literals" } } },
        },
      })
      vim.lsp.config("yamlls", {
        settings = { yaml = { keyOrdering = false, format = { enable = true } } },
      })
      vim.lsp.config("rust_analyzer", {
        settings = { ["rust-analyzer"] = { check = { command = "clippy" } } },
      })

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = true,
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua", "prettier", "shfmt", "shellcheck", "sqlfluff",
          "debugpy", "codelldb",
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          map("n", "K", function() vim.lsp.buf.hover() end, "Hover")
          map({ "n", "i" }, "<C-k>", function() vim.lsp.buf.signature_help() end, "Signature help")
          map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
          map("n", "<leader>cA", function()
            vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } })
          end, "Source action")
          map("n", "<leader>co", function()
            vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" }, diagnostics = {} }, apply = true })
          end, "Organize imports")
          map("n", "<leader>cL", "<cmd>LspInfo<cr>", "LSP info")
          map("n", "<leader>cR", function() Snacks.rename.rename_file() end, "Rename file")

          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
          end
          if client and client:supports_method("textDocument/codeLens") then
            vim.lsp.codelens.enable(true, { bufnr = ev.buf })
          end
        end,
      })
    end,
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
  },
}

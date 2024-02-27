return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "bashls",
          -- "autotools-language-server",
          "cssls",
          "dockerls",
          "docker_compose_language_service",
          "golangci_lint_ls",
          "gopls",
          "html",
          "htmx",
          "pyright",
          "sqlls",
          "tailwindcss",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.pyright.setup({
        capabilities = capabilities,
      })
      lspconfig.gopls.setup({
        capabilities = capabilities,
      })
      lspconfig.golangci_lint_ls.setup({
        capabilities = capabilities,
      })


      -- Global mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings.
          -- See `:help vim.lsp.*` for documentation on any of the below functions
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
          vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, {})
          vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, {})
          vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, {})
          vim.keymap.set("n", "<space>wl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, {})
          vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, {})
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {})
          vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, {})
          vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
          vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
          end, {})
        end,
      })
    end,
  },
}

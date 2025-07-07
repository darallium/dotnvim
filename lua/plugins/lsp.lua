
---@type fun(capabilities?: table): nil
old_setup = function(capabilities)
   
   if vim.fn.has('nvim-0.11') == 1 then
     require("core.lsp").setup(capabilities)
     return
   end
   
   local lspconfig = require("lspconfig")

   local on_attach = function(client, buffer)
     require("lsp-status").on_attach(client, buffer)
     if client.server_capabilities.inlayHintProvider then
       vim.lsp.inlay_hint.enable(true, {bufnr = buffer})
     end
   end

   local is_node_dir = function()
     return lspconfig.util.root_pattern('package.json')(vim.fn.getcwd())
   end

   lspconfig.ts_ls.setup({
     on_attach = function(client, bufnr)
         if not is_node_dir() then
           client.stop(true)
         end
         on_attach(client, bufnr)
     end ,
     capabilities = capabilities,
     single_file_support = false,
     root_dir = lspconfig.util.root_pattern("tsconfig.json"),
     settings = {
       typescript = {
         inlayHints = {
           includeInlayParameterNameHints = "all",
           includeInlayParameterNameHintsWhenArgumentMatchesName = false,
           includeInlayFunctionParameterTypeHints = true,
           includeInlayVariableTypeHints = true,
           includeInlayVariableTypeHintsWhenTypeMatchesName = false,
           includeInlayPropertyDeclarationTypeHints = true,
           includeInlayFunctionLikeReturnTypeHints = true,
           includeInlayEnumMemberValueHints = true,
         },
       },
     },
     filetypes = {
       "javascript",
       "javascriptreact",
       "javascript.jsx",
       "typescript",
       "typescriptreact",
       "typescript.tsx",
     },
   })

   lspconfig.lua_ls.setup({
     on_attach = on_attach,
     capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
            pathStrict = true,
            path = { "?.lua", "?/init.lua" },
          },
          workspace = {
            library = require("core.lsp").library({ "lazy.nvim" }),
            checkThirdParty = "Disable",
          },
        },
      },
   })

   local function get_python_path()
     local rye_output = vim.fn.system("rye show 2>/dev/null")
     if vim.v.shell_error == 0 then
       for line in rye_output:gmatch("[^\r\n]+") do
         if line:match("^venv:") then
           local venv_path = line:match("venv:%s*(.+)")
           if venv_path then
             local python_exe = vim.fn.has("win32") == 1 
               and venv_path .. "/Scripts/python.exe"
               or venv_path .. "/bin/python"
             if vim.fn.executable(python_exe) == 1 then
               return python_exe
             end
           end
         end
       end
     end
     return nil
   end

   local python_path = get_python_path()
   lspconfig.pyright.setup({
     on_attach = on_attach,
     capabilities = capabilities,
     settings = {
       python = {
         pythonPath = python_path,
         analysis = {
           autoSearchPaths = true,
           diagnosticMode = "workspace",
           useLibraryCodeForTypes = true,
         },
       },
     },
   })

   lspconfig.ltex.setup({
     on_attach = on_attach,
     capabilities = capabilities,
   })

   lspconfig.clangd.setup({
     cmd = {'clangd', '--background-index', '--clang-tidy', '--log=verbose'},
     init_options = {
       fallbackFlags = { '-std=c++17' },
     },
   })

   lspconfig.jsonls.setup({
     on_attach = on_attach,
     capabilities = capabilities,
   })

   vim.api.nvim_create_autocmd('LspAttach', {
     group = vim.api.nvim_create_augroup('UserLspConfig', {}),
     callback = function(ev)
       vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
       
       vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = ev.buf, nowait = true })
       vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, nowait = true })
       vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = ev.buf, nowait = true })
       vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf, nowait = true })
       vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, nowait = true })
     end
   })

end


return {
  {
    "neovim/nvim-lspconfig",
    event = {
      "BufReadPost",
      "BufNewFile"
    },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "saghen/blink.cmp",
      "nvim-lua/lsp-status.nvim",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      if vim.fn.has('nvim-0.11') == 1 then
        require("core.lsp").setup(capabilities)
      else
        --old_setup(capabilities)
      end

    end,
  },
  {
    "nvimtools/none-ls.nvim",
    event = {
      "BufReadPost",
    },
    config = function()
      local null_ls = require("null-ls")
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.prettier,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ async = false })
              end,
            })
          end
        end,
      })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = {
      "VeryLazy"
    },
    opts = {
      enable = true,
      multiwindow = false,
      max_lines = 4,
      min_window_height = 15,
      line_numbers = true,
      multiline_threshold = 29,
      trim_scope = 'outer',
      mode = 'topline',
      separator = nil,
      zindex = 20,
      on_attach = nil,
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
    end
  },
  {
    "mfussenegger/nvim-dap",
    event = {
      "BufReadPost",
      "BufNewFile",
    },
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-neotest/nvim-nio",
        },
      },
      "theHamsta/nvim-dap-virtual-text",
      "nvim-telescope/telescope-dap.nvim",
    },
    config = function()
      require("dapui").setup()
      require("nvim-dap-virtual-text").setup()
      require("telescope").load_extension("dap")
    end,
  },
}

---@class CoreLspModule
---@field setup fun(capabilities?: table): nil
local M = {}

---@class LspServerConfig
---@field capabilities table LSP capabilities
---@field on_attach? fun(client: vim.lsp.Client, bufnr: integer)
---@field settings? table Server-specific settings
---@field root_markers? string[] Root directory markers
---@field single_file_support? boolean Single file support
---@field cmd? string[] Command to start the LSP server
---@field root_dir? fun(fname: string): string | nil Root directory detection function

---@type fun(mode: string|sヒカリへ オルゴールtring[], lhs: string, rhs: string|function, opts?: table)
local key = vim.keymap.set

---@type fun(client: vim.lsp.Client, bufnr: integer): nil
local function inlay_hint(client, bufnr)
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end
end

---@param names string[]
---@return string[]
function M.get_plugin_paths(names)
  local plugins = require("lazy.core.config").plugins
  local paths = {}
  for _, name in ipairs(names) do
    if plugins[name] then
      table.insert(paths, plugins[name].dir .. "/lua")
    else
      vim.notify("Invalid plugin name: " .. name)
    end
  end
  return paths
end

---@param plugins string[]
---@return string[]
function M.library(plugins)
  local paths = M.get_plugin_paths(plugins)
  table.insert(paths, vim.fn.stdpath("config") .. "/lua")
  table.insert(paths, vim.env.VIMRUNTIME .. "/lua")
  table.insert(paths, "${3rd}/luv/library")
  table.insert(paths, "${3rd}/busted/library")
  table.insert(paths, "${3rd}/luassert/library")
  return paths
end



---@return string|nil
local function get_python_path()
  local rye_output = vim.fn.system("rye show")
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

---@return boolean
local function is_node_dir()
  return vim.fs.find('package.json', { upward = true, path = vim.fn.getcwd() })[1] ~= nil
end

---@param capabilities? table LSP capabilities
function M.setup(capabilities)
  if vim.fn.has('nvim-0.11') == 0 then
    return
  end

  capabilities = capabilities or vim.lsp.protocol.make_client_capabilities()
  ---@type string|nil
  local python_path = get_python_path()

  ---@type table<string, LspServerConfig>
  local lsps = {
    lua_ls = {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        inlay_hint(client, bufnr)
      end,
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
            pathStrict = true,
            path = { "?.lua", "?/init.lua" },
          },
          workspace = {
            library = M.library({ "lazy.nvim"}),
            checkThirdParty = "Disable",
          },
        },
      },
    },
    ts_ls = {
      capabilities = capabilities,
      single_file_support = false,
      root_markers = { "tsconfig.json" },
      filetypes = {
        "javascript",
        "javascriptreact", 
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
      },
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
      on_attach= function(client, bufnr)
        if not is_node_dir() then
          client.stop(true)
        end
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
        --err inlay
      end,
    },
    pyright= {
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
      on_attach = function(client, bufnr)
        inlay_hint(client, bufnr)
      end,
    },
    ltex = {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        inlay_hint(client, bufnr)
      end,
    },
    clangd = {
      cmd = {
        'clangd', 
        '--background-index', 
        '--clang-tidy', 
        '--log=verbose'
      },
      settings = {
        init_options = {
          fallbackFlags = { '-std=c++17' },
        },
      },
      on_attach = function(client, bufnr)
        inlay_hint(client, bufnr)
      end,
    },
    rust_analyzer = {
      capabilities = capabilities,
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          checkOnSave = true,
          inlayHints = {
            chainingHints = { enable = true },
            parameterHints = { enable = true },
            typeHints = { enable = true },
          },
        },
      },
    },
    jsonls = {
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        inlay_hint(client, bufnr)
      end,
    },
  }
    -- Configure diagnostics with virtual text (ghost text)
  local Util = require('util')

  -- Set up diagnostic signs
  for name, icon in pairs(Util.icons.diagnostics) do
    local sign_name = "DiagnosticSign" .. name
    vim.fn.sign_define(sign_name, { text = icon, texthl = sign_name, numhl = "" })
  end

  -- Configure diagnostic display with virtual text
  vim.diagnostic.config({
    virtual_text = {
      prefix = function(diagnostic)
        local icons = Util.icons.diagnostics
        for d, icon in pairs(icons) do
          if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
            return icon
          end
        end
        return "●"
      end,
      severity = { min = vim.diagnostic.severity.HINT }, -- Show warnings and errors only
      spacing = 2,
      source = "if_many",
    },
    signs = {
      severity = { min = vim.diagnostic.severity.HINT },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })


  for name, config in pairs(lsps) do
    

    on_attach = function(client, bufnr)

      ---@type UtilModule
      Util = require('util')

      -- inlay warnings
      Util.on_attach(function(client, buffer)
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
        end
      end)

      for name, icon in pairs(Util.icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      
			if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
				opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.11") == 0 and "●"
					or function(diagnostic)
						local icons = Util.icons.diagnostics
						for d, icon in pairs(icons) do
							if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
								return icon
							end
						end
					end
			end
    end
    
    if config then
      vim.lsp.config(name, config)
    end
    vim.lsp.enable(name)
  end

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
      
      key('n', 'gD', vim.lsp.buf.declaration, { buffer = ev.buf, nowait = true })
      key('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, nowait = true })
      key('n', 'gi', vim.lsp.buf.implementation, { buffer = ev.buf, nowait = true })
      key('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf, nowait = true })
      key('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, nowait = true })
    end
  })

end

return M

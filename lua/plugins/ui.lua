local util = require("util")

---@type fun(): string
local function lsp_names()
  local clients = {}
  for _, client in ipairs(vim.lsp.get_active_clients { bufnr = 0 }) do
    if client.name == 'null-ls' then
      local sources = {}
      for _, source in ipairs(require('null-ls.sources').get_available(vim.bo.filetype)) do
        table.insert(sources, source.name)
      end
      table.insert(clients, 'null-ls(' .. table.concat(sources, ', ') .. ')')
    else
      table.insert(clients, client.name)
    end
  end
  return ' ' .. table.concat(clients, ', ')
end


return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
     'nvim-tree/nvim-web-devicons'
    },
    event = {
      "BufEnter",
    },
    opts = {
      options = {
        theme = "catppuccin",
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        globalstatus = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b ={
          {
            'branch',
            icon = util.icons.git.branch,
          },
          {
            'diff',
            symbols = {
              added = util.icons.git.plus,
              modified = util.icons.git.minus,
              removed = util.icons.git.removed,
            },
          },
          {
            'diagnostics',
            symbols = {
              error = util.icons.diagnostics.Error,
              warn = util.icons.diagnostics.Warn,
              info = util.icons.diagnostics.Info,
            },
          },
        },
        lualine_c = {},
        lualine_x = {
          lsp_names,
          {
            icon = '', -- f013
            symbols = {
              -- Standard unicode symbols to cycle through for LSP progress:
              spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
              -- Standard unicode symbol for when LSP is done:
              done = '✓',
              -- Delimiter inserted between LSP names:
              separator = ' ',
            },
            -- List of LSP names to ignore (e.g., `null-ls`):
            ignore_lsp = {'*'},
          }
        },
        lualine_y = {
          'encoding',
          'fileformat',
          {
            'filename',
            path = 4,
            symbols = {
              modified = '●',
              readonly = '[RO]',
              unnamed = '[No Name]',
            }
          },
          'filetype'
        },
        lualine_z = {
          'progress',
          'location',
        },
      },
    },
  },
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    ---@type BufferlinePluginOpts
    opts = {
      options = {
        mode = "buffers",
        numbers = "ordinal",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local s = " "
          local icons = util.icons.diagnostics
          for e, n in pairs(diagnostics_dict) do
            local sym = icons[e] or ""
            s = s .. n .. sym .. " "
          end
          return s
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            separator = true
          }
        },
        show_buffer_close_icons = true,
        show_close_icon = true,
        separator_style = "thin",
      }
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
  "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- Optional image support for file preview: See `# Preview Mode` for more information.
      -- {"3rd/image.nvim", opts = {}},
      -- OR use snacks.nvim's image module:
      -- "folke/snacks.nvim",
    },
    lazy = false, -- neo-tree will lazily load itself
    ---@module "neo-tree"
    opts = {
        close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = vim.fn.has("nvim-0.11") and "" or "NC", -- or "" to use 'winborder' on Neovim v0.11+
        enable_git_status = true,
        enable_diagnostics = true,
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
        open_files_using_relative_paths = false,
        sort_case_insensitive = false, -- used when sorting files and directories in the tree
        sort_function = nil, -- use a custom function for sorting files and directories in the tree
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        callback = function()
          if vim.fn.argc() > 0 then
            vim.cmd("Neotree show")
          end
        end,
      })
    end,
  },
}


return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = {
      "VeryLazy"
    },
    build = ":TSUpdate",
    dependencies = {
    },
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        sync_install = false,
        highlight = {
          enable = true,
          disable = {
          }
        },
        indent = {
          enable = true,
        },
        autotag = {
          enable = true,
        }
      })
    end,
  },
}


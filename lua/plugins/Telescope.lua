
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      lazy = true,
      {
        "nvim-telescope/telescope-file-browser.nvim",
        lazy = true,
        
      }
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      telescope.setup({
      })
      telescope.load_extension("file_browser")
      local key = vim.keymap.set
      local opts = {
        noremap = true, 
        silent = true,
      }
      key("n", ";;", "<Cmd>Telescope<CR>", opts)
    end,
  },
  {
    "nvim-telescope/telescope-frecency.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension("frecency")
    end,
  },
}

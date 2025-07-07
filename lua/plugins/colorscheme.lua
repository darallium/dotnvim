return {
  {	
		"catppuccin/nvim",
		name = "catppuccin",
		opts = true,
		lazy = false,
    opts = {
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
      },
      integrations = {
        telescope = true,
        treesitter = true,
        cmp = true,
        gitsigns = true,
        notify = true,
        mini = true,
      },
    },
		config = function(_, opts)
      require('catppuccin').setup(opts)
			vim.cmd([[ colorscheme catppuccin ]])
		end,
  },
}

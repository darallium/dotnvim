---@class SnacksDashboardItem
---@field desc string
---@field key string
---@field cmd string

---@class SnacksNotifierOpts
---@field enabled boolean

---@class SnacksPluginOpts
---@field dashboard SnacksDashboardOpts
---@field notifier SnacksNotifierOpts

return {
  {
    "folke/snacks.nvim",
    event = "VimEnter",
    lazy = false,
    priority = 1000,
    opts = {
      dashboard = {
        preset = {
          header = [=[
██████╗   █████╗  ██████╗   █████╗  ██╗   ██╗ ██╗ ███╗   ███╗
██╔══██╗ ██╔══██╗ ██╔══██╗ ██╔══██╗ ██║   ██║ ██║ ████╗ ████║
██║  ██║ ███████║ ██████╔╝ ███████║ ██║   ██║ ██║ ██╔████╔██║
██║  ██║ ██╔══██║ ██╔══██╗ ██╔══██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║
██████╔╝ ██║  ██║ ██║  ██║ ██║  ██║  ╚████╔╝  ██║ ██║ ╚═╝ ██║
╚═════╝  ╚═╝  ╚═╝ ╚═╝  ╚═╝ ╚═╝  ╚═╝   ╚═══╝   ╚═╝ ╚═╝     ╚═╝
]=],
          keys = {
            { desc = " Find file", key = "f", action = ":Telescope find_files" },
            { desc = " New file", key = "n", action = ":enew" },
            { desc = " Recent files", key = "r", action = ":Telescope oldfiles" },
            { desc = " Find text", key = "g", action = ":Telescope live_grep" },
            { desc = " Restore Session", key = "s", action = 'lua require("persistence").load()' },
            { desc = " Lazy Extras", key = "x", action = ":LazyExtras" },
            { desc = " Lazy", key = "l", action = ":Lazy" },
            { desc = " Quit", key = "q", action = ":qa" },
          },
        },
        sections = {
          {
            icon = " ",
            title = "Keymaps",
            section = "keys",
            indent = 2,
            padding = 1,
            pane = 1,
            gap = 0,
          },
          {
            section = "header",
            pane = 2,
          },
          {
            section = "startup",
            pane = 2,
          },
          {
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            indent = 2,
            padding = 1,
            height = 10,
            limit = 15,
          },
          {
            icon = " ",
            title = "Projects",
            section = "projects",
            indent = 2,
            padding = 1,
            height = 10,
            limit = 15,
          },
          {
            pane = 3,
            icon = " ",
            desc = "Browse Repo",
            padding = 1,
            key = "b",
            action = function()
              Snacks.gitbrowse()
            end,
          },
          function()
            local in_git = Snacks.git.get_root() ~= nil
            local cmds = {
              {
                title = "Open Issues",
                cmd = "gh issue list -L 10",
                key = "i",
                action = function()
                  vim.fn.jobstart("gh issue list --web", { detach = true })
                end,
                icon = " ",
                height = 15,
                pane = 3,
              },
              {
                icon = " ",
                title = "Open PRs",
                cmd = "gh pr list -L 10",
                key = "P",
                action = function()
                  vim.fn.jobstart("gh pr list --web", { detach = true })
                end,
                height = 15,
                pane = 3,
              },
              {
                icon = " ",
                title = "Git Status",
                cmd = "git --no-pager diff --stat -B -M -C",
                height = 30,
                pane = 2,
              },
            }
            return vim.tbl_map(function(cmd)
              return vim.tbl_extend("force", {
                pane = 3,
                section = "terminal",
                enabled = in_git,
                padding = 1,
                ttl = 5 * 60,
                indent = 3,
              }, cmd)
            end, cmds)
          end,
        },
      },
      notifier = {
        enabled = false,
      },
      lazy = {
        enabled = true,
        show_progress = true,
        show_debug = false,
        show_error = true,
        show_warning = true,
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "SnacksDashboardOpened",
          callback = function()
            require("lazy").show()
          end,
          once = true,
        })
      end
    end,
  },
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			views = {
				cmdline_popup = {
					position = {
						row = 5,
						col = "50%",
					},
					size = {
						width = 60,
						height = "auto",
					},
					border = {
						style = "single",
					},
				},
				popupmenu = {
					relative = "editor",
					position = {
						row = 8,
						col = "50%",
					},
					size = {
						width = 60,
						height = 10,
					},
					border = {
						style = "single",
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = { Normal = "Normal", FloatBorder = "MoreMsg" },
					},
				},
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
				},
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},

}


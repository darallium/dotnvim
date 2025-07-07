
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<C-l>",
          dismiss = "<C-h>",
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = {
        enabled = true,
      },
      filetypes = {
        markdown = false,
        yaml = false,
        json = false,
        ["."] = false,
      },
    },
  },
  {
    "yetone/avante.nvim",
    cmd = {
      "AvanteAsk",
      "AvanteBuild", 
      "AvanteChat",
      "AvanteChatNew",
      "AvanteHistory",
      "AvanteClear",
      "AvanteEdit",
      "AvanteFocus",
      "AvanteRefresh",
      "AvanteStop",
      "AvanteSwitchProvider",
      "AvanteShowRepoMap",
      "AvanteToggle",
      "AvanteModels",
      "AvanteSwitchSelectorProvider",
    },
    version = false,
    opts = {
      provider = "copilot",
      auto_suggestions_provider = "copilot",
      
      -- 動作設定
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = false,
        support_paste_from_clipboard = false,
        minimize_diff = true,
      },

      -- ウィンドウ設定
      windows = {
        position = "right",  -- サイドバーの位置
        wrap = true,        -- テキストの折り返し
        width = 30,         -- サイドバーの幅
        -- その他の詳細設定は省略
      },
    },
    -- 依存関係の設定
    dependencies = {
      -- 必須の依存関係
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- オプションの依存関係
      "hrsh7th/nvim-cmp",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      -- その他の拡張機能
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    }
  }
}

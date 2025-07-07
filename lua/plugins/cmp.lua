---@class CmpSnippetConfig
---@field expand fun(args: { body: string })

---@class CmpMappingConfig
---@field ['<C-b>'] fun()
---@field ['<C-f>'] fun()
---@field ['<C-Space>'] fun()
---@field ['<C-e>'] fun()
---@field ['<CR>'] fun()
---@field ['<Tab>'] fun(fallback: fun())
---@field ['<S-Tab>'] fun(fallback: fun())


---@class CmpFormattingConfig
---@field format fun(entry: CmpFormatEntry, vim_item: table): table
local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0
		and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

return {
  {
    "hrsh7th/nvim-cmp",
    event = {"InsertEnter", "CmdlineEnter"},
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/vim-vsnip",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      require("luasnip.loaders.from_vscode").lazy_load()

      ---@type CmpConfig
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
	  				vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
	  			winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
	  			border = "single",
	  			col_offset = -3,
	  			side_padding = 1,
        },
        completion = {
          completeopt = "menu,menuone,noinsert",
          autocomplete = { require("cmp").TriggerEvent.TextChanged },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-x><C-i>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
	  				elseif vim.fn["vsnip#available"](1) == 1 then
	  					feedkey("<Plug>(vsnip-expand-or-jump)", "")
	  				elseif has_words_before() then
	  					cmp.complete()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
	  			{ name = "vsnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
	  			fields = { "kind", "abbr", "menu" },
          format = require("lspkind").cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            show_labelDetails = true,
            before = function(entry, vim_item)
	  					local icons = require("util").icons.kinds
	  					if icons[vim_item.kind] then
	  						vim_item.menu = "    (" .. vim_item.kind .. ")"
	  						vim_item.kind = " " .. icons[vim_item.kind] .. " "
	  					end
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
                cmdline = "[Cmd]",
              })[entry.source.name]

              return vim_item
            end,
          }),
        },
        experimental = {
          ghost_text = true,
        },
	  		sorting = {
	  			priority_weight = 2,
	  			comparators = {
	  				cmp.config.compare.offset,
	  				cmp.config.compare.score,
	  				cmp.config.compare.recently_used,
	  				cmp.config.compare.locality,
	  				cmp.config.compare.kind,
	  				cmp.config.compare.sort_text,
	  				cmp.config.compare.length,
	  				cmp.config.compare.order,
	  			},
	  		},
      })

	  	cmp.setup.cmdline(":", {
	  		mapping = cmp.mapping.preset.cmdline({
	  			["<CR>"] = {
	  				c = function(fallback)
	  					fallback()
	  				end,
	  			},
	  		}),
	  		sources = cmp.config.sources({
	  			--{ name = "buffer" },
	  			{ name = "cmdline" },
	  			--{ name = "path" },
	  		}),
	  	})
      cmp.setup.cmdline("/", {
        sources = cmp.config.sources({
          { name = "buffer" },
        }),
      })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = {
      "make install_jsregexp",
    },
    event = {
      "BufReadPost",
    },
    dependencies = {
    },
    opts = {
    },
    config = function(_, opts)
      require("luasnip").setup(opts)
    end
  },
}

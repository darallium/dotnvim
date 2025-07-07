local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


require("core")

--require("keymap")

require("lazy").setup("plugins", {
  defaults = {
    lazy = true,
  },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {

    }
  },
  spec = {
    -- LazyVimのデフォルトプラグインをロード
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- 自分で追加したプラグインをロード
    { import = "plugins" },
  },
  dev = {
    enabled = true, -- devモードを有効化
    handler = function(event)
      -- "config" イベントは非常に多く発生するため、除外すると見やすいです
      if event.name == "config" then
        return
      end

      -- Snacksがロードされた後でのみ通知を実行
      if package.loaded["snacks"] then
        if event.name == "load" then
          vim.notify("⏳ Loading " .. event.plugin, vim.log.levels.INFO, { title = "LazyVim" })
        elseif event.name == "success" then
          vim.notify("✅ Loaded " .. event.plugin, vim.log.levels.INFO, { title = "LazyVim" })
          -- 成功通知は数が多くて邪魔に感じる場合は、上の行をコメントアウトしてください
        end
      end
    end,
  },

  lockfile = vim.fn.stdpath("config") .. "/.lazy-lock.json",
})


return 'hello'


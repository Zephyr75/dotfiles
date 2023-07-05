-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny


lvim.colorscheme = "tokyonight-storm"

vim.api.nvim_set_keymap('n', 'd', '"_d', { noremap = true })
vim.api.nvim_set_keymap('n', 'x', '"_x', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-f>', 'gggqG', { noremap = true })

vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true })


vim.keymap.set("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { noremap = true })

-- lvim.lsp.buffer_mappings.normal_mode['ö'] = { vim.lsp.buf.hover, "Show documentation" }



vim.opt.relativenumber = true

vim.opt.autochdir = true


vim.g.copilot_assume_mapped = true



lvim.plugins = {
  { 'github/copilot.vim' },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup {
        -- your config goes here
        -- or just leave it empty :)
      }
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  -- {
  --   'ray-x/navigator.lua',
  --   requires = {
  --       { 'ray-x/guihua.lua', run = 'cd lua/fzy && make' },
  --       { 'neovim/nvim-lspconfig' },
  --   },
  -- }
  {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {}
    end
  },
  { 'ekickx/clipboard-image.nvim' },



  -- {
  --   'filipdutescu/renamer.nvim',
  --   branch = 'master',
  --   requires = { {'nvim-lua/plenary.nvim'} }
  -- },


}

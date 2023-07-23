-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-----------------------------------------------------------------------------
--FOLD
--:set foldmethod=indent
--zR
--za
-----------------------------------------------------------------------------
--WRAP LINES
--:set wrap
-----------------------------------------------------------------------------
--REPLACE ALL
--:%s/old/new/g
-----------------------------------------------------------------------------

-- Enable Flutter snippets
require'luasnip'.filetype_extend("dart", {"flutter"})

-- Setup leap mappings
require('leap').add_default_mappings()

-- Set color scheme
lvim.colorscheme = "tokyonight-storm"

-- Do not copy when deleting
vim.api.nvim_set_keymap('n', 'd', '"_d', { noremap = true })
vim.api.nvim_set_keymap('n', 'D', '"_D', { noremap = true })
vim.api.nvim_set_keymap('n', 'x', '"_x', { noremap = true })
vim.api.nvim_set_keymap('n', 'X', '"_X', { noremap = true })
vim.api.nvim_set_keymap('n', 'c', '"_c', { noremap = true })
vim.api.nvim_set_keymap('n', 'C', '"_C', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-f>', 'gggqG', { noremap = true })

-- Preview method definition
vim.keymap.set("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { noremap = true })

-- Enable relative line numbers
vim.opt.relativenumber = true

-- Enable auto directory change
vim.opt.autochdir = true

-- Force accept Copilot suggestion when pressing Alt+Tab
vim.api.nvim_set_keymap("i", "<A-Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- Define plugins list
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
      require("auto-save").setup {}
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    'rmagatti/goto-preview',
    config = function()
      require('goto-preview').setup {}
    end
  },
  { 'ekickx/clipboard-image.nvim' },
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
        'nvim-lua/plenary.nvim',
        'stevearc/dressing.nvim',
    },
    config = true,
  },
  { 'ggandor/leap.nvim' },
  { 'mg979/vim-visual-multi' },
}



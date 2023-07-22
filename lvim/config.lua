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

require'luasnip'.filetype_extend("dart", {"flutter"})
require('leap').add_default_mappings()


-- require("flutter-tools").setup {} -- use defaults

-- require("luasnip.loaders.from_vscode").lazy_load()

lvim.colorscheme = "tokyonight-storm"

vim.api.nvim_set_keymap('n', 'd', '"_d', { noremap = true })
vim.api.nvim_set_keymap('n', 'D', '"_D', { noremap = true })
vim.api.nvim_set_keymap('n', 'x', '"_x', { noremap = true })
vim.api.nvim_set_keymap('n', 'X', '"_X', { noremap = true })
vim.api.nvim_set_keymap('n', 'c', '"_c', { noremap = true })
vim.api.nvim_set_keymap('n', 'C', '"_C', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-f>', 'gggqG', { noremap = true })

-- vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true })



vim.keymap.set("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { noremap = true })

-- lvim.lsp.buffer_mappings.normal_mode['ö'] = { vim.lsp.buf.hover, "Show documentation" }



vim.opt.relativenumber = true

vim.opt.autochdir = true


-- vim.g.copilot_assume_mapped = true

-- vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<A-Tab>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

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
        'stevearc/dressing.nvim', -- optional for vim.ui.select
    },
    config = true,
  },

  { 'ggandor/leap.nvim' },

  { 'mg979/vim-visual-multi' },
  -- {
  --   "dnlhc/glance.nvim",
  --   config = function()
  --     require('glance').setup({
  --       -- your configuration
  --     })
  --   end,
  -- }

  -- {
  --   'filipdutescu/renamer.nvim',
  --   branch = 'master',
  --   requires = { {'nvim-lua/plenary.nvim'} }
  -- },
  -- {
  --   "L3MON4D3/LuaSnip",
  --   dependencies = { "rafamadriz/friendly-snippets" },
  -- },
  -- { "rafamadriz/friendly-snippets" },

}



-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny


lvim.colorscheme = "tokyonight-storm"

vim.api.nvim_set_keymap('n', 'd', '"_d', { noremap = true })
vim.api.nvim_set_keymap('n', 'x', '"_x', { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true })
vim.api.nvim_set_keymap('n', '<C-f>', 'gggqG', { noremap = true })

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
    run = function() vim.fn["mkdp#util#install"]() end,
  },


}


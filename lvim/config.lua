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
--:set wrap! or :set invwrap
--:set linebreak to wrap at word boundaries
-----------------------------------------------------------------------------
--REPLACE ALL
--:%s/old/new/g
-----------------------------------------------------------------------------
--MULTICURSOR
--Ctrl + n = add multicursor (move with arrow keys)
-----------------------------------------------------------------------------
--PASTE IMAGE IN MARKDOWN
--:PasteImg
-----------------------------------------------------------------------------
--VIM COMMANDS
--f + char = jump to char
--F + char = jump to char backwards
--t + char = jump to char but before
--T + char = jump to char but before backwards
--; = repeat last f, F, t or T
--ct + char = change until char
--cT + char = change until char backwards
--E = jump to end of word (ignores punctuation)
--B = jump to beginning of word (ignores punctuation)
--vi + char = select inside char
--va + char = select around char
--vib = select inside brackets
--viB = select inside brackets (including brackets)
--viw = select inside word
--]m = jump to next symbol
--[m = jump to previous symbol
--* = forward search for word under cursor
--# = backward search for word under cursor
--Ctrl + r = select visually selected text
--:g/word/d = delete all lines containing word
--Ctrl + a = increment number under cursor
--Ctrl + x = decrement number under cursor
--g + Ctrl + a = increment number under cursor in visual mode
--g + Ctrl + x = decrement number under cursor in visual mode
--"0p = paste from register 0 (yanked before delete)
--Ctrl + r + = = evaluate expression in insert mode
-----------------------------------------------------------------------------
-- RANGER COMMANDS
--S = open shell
--cw = rename
--a = add to file name
--yy = copy
--dd = cut
--dD = delete
--pp = paste
--:mkdir = create directory
--:touch = create file
--v = visual mode (select files)
--V = invert selection (select all if empty)
--! = open shell command
-----------------------------------------------------------------------------

-- Enable useful snippets
require'luasnip'.filetype_extend("dart", {"flutter"})
require'luasnip'.filetype_extend("cs", {"unity"})

-- Setup leap mappings
require('leap').add_default_mappings()

-- Setup symbols tab
require("symbols-outline").setup()

-- Set color scheme
lvim.colorscheme = "tokyonight-storm"
-- require('onedark').setup {
--     style = 'darker'
-- }
-- require('onedark').load()

-- Replace visual selection with confirmation
vim.api.nvim_set_keymap('v', '<C-r>', '"hy:%s/<C-r>h//gc<left><left><left>', { noremap = true })

-- Open symbols tab
vim.api.nvim_set_keymap('n', '<C-o>', ':SymbolsOutline<Enter>', { noremap = true })

-- Paste image in markdown
vim.api.nvim_set_keymap('n', '<C-p>', ':PasteImg<Enter>', { noremap = true })

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
  { 'simrat39/symbols-outline.nvim' },
  {
    "ray-x/go.nvim",
    dependencies = {  -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup()
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },
  {
    "iamcco/markdown-preview.nvim",
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    "loctvl842/monokai-pro.nvim",
    config = function()
      require("monokai-pro").setup()
    end
  },
  { 'navarasu/onedark.nvim' },
  { 'tpope/vim-eunuch' },
  { 'tikhomirov/vim-glsl' },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    }
  },
}



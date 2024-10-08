-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-----------------------------------------------------------------------------
--ERROR MESSAGE
--:mess after running command
-----------------------------------------------------------------------------
--FOLD
--:set foldmethod=indent
--zR
--za
-----------------------------------------------------------------------------
--WRAP LINES
--:set wrap
--:set linebreak to wrap at word boundaries
--:set wrap! and :set linebreak! to revert
-----------------------------------------------------------------------------
--REPLACE ALL
--:%s/old/new/g
-----------------------------------------------------------------------------
--MULTICURSOR
--Ctrl + n = add multicursor (move with arrow keys)
-----------------------------------------------------------------------------
-- DISABLE HIGHLIGHT ON BIG FILES
--:TSBufDisable highlight
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
--U = capitalize visually selected text
--u = lowercase visually selected text
--"0p = paste from register 0 (yanked before delete)
--Ctrl + r + = = evaluate expression in insert mode
--Ctrl + r + " = paste yank register content to live grep
--m + char = mark line with char
--m + capital char = mark line across files with char
--' + char = jump to mark char
--:delmarks a = delete mark a
--:delmarks a-zA-Z0-9 = delete all marks
--z + = = spell check
--y + s + i + w + " = surround word with quotes
--c + s + " + ' = change surrounding quotes to single quotes
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
--V = visual mode (select files)
--v = invert selection (select all if empty)
--! = open shell command
-----------------------------------------------------------------------------
-- TMUX COMMANDS
--tmux new -s name = create session
--tmux a -t name = attach to session
--tmux ls = list sessions
--tmux kill-session -t name = kill session
--Ctrl + b + d = detach from session
--Ctrl + b + c = create window
--Ctrl + b + n = next window
--Ctrl + b + p = previous window
--Ctrl + b + x = kill window
--Ctrl + b + % = split vertically
--Ctrl + b + " = split horizontally
--Ctrl + b + arrow = move to pane
--Ctrl + b + z = zoom pane
--Ctrl + b + space = change pane layout
-----------------------------------------------------------------------------

-- Enable useful snippets
require 'luasnip'.filetype_extend("dart", { "flutter" })
require 'luasnip'.filetype_extend("cs", { "unity" })

-- Set color scheme
lvim.colorscheme = "catppuccin-macchiato"

vim.cmd('set clipboard+=unnamedplus')

-- Remap half page up/down to Alt+u/d
vim.api.nvim_set_keymap('n', '<A-u>', '<C-u>', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-d>', '<C-d>', { noremap = true })

-- Enable relative line numbers
vim.opt.relativenumber = true

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
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup {}
    end,
  },
  { 'chentoast/marks.nvim' },
  { 'mg979/vim-visual-multi' },
  { 'tpope/vim-eunuch' },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
  { 'eandrju/cellular-automaton.nvim' },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim"
        },
        opts = { lsp = { auto_attach = true } }
      }
    },
  },
  { 'dfendr/clipboard-image.nvim' },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
    },
  },
  { 'ggandor/leap.nvim' },
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
  { 'akinsho/git-conflict.nvim', version = "*", config = true },
  {
    'stevearc/dressing.nvim',
    opts = {},
  },
  -- {
  --   "ThePrimeagen/harpoon",
  --   branch = "harpoon2",
  --   dependencies = { "nvim-lua/plenary.nvim" }
  -- },
  {
    "otavioschwanck/arrow.nvim",
    opts = {
      show_icons = true,
      leader_key = ',' -- Recommended to be a single key
    }
  },
  { 'tpope/vim-surround' },
  { 'sindrets/diffview.nvim' },
  { 'ThePrimeagen/vim-be-good' },
}


require('leap').add_default_mappings()

require 'lspconfig'.marksman.setup {}


-- local harpoon = require("harpoon")

-- vim.keymap.set('n', 's', function ()
--   require('leap').leap { target_windows = { vim.api.nvim_get_current_win() } }
-- end)
vim.keymap.set('n', 's', function ()
  local focusable_windows = vim.tbl_filter(
    function (win) return vim.api.nvim_win_get_config(win).focusable end,
    vim.api.nvim_tabpage_list_wins(0)
  )
  require('leap').leap { target_windows = focusable_windows }
end)

-- Replace visual selection with confirmation
vim.api.nvim_set_keymap('v', '<A-r>', '"hy:%s/<C-r>h//gc<left><left><left>', { noremap = true })

-- Open symbols tab
vim.api.nvim_set_keymap('n', '<A-e>', ':Navbuddy<Enter>', { noremap = true })

-- Open marks finder in Telescope
vim.api.nvim_set_keymap('n', '<leader>sm', ":lua require'telescope.builtin'.marks{}<Enter>", { noremap = true })

-- Open TodoTrouble
vim.api.nvim_set_keymap('n', '<leader>tt', ':TodoTelescope<Enter>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>te', ':Trouble<Enter>', { noremap = true })

-- Paste image in markdown
vim.api.nvim_set_keymap('n', '<A-p>', ':cd %:h <BAR> :PasteImg<Enter>', { noremap = false })

-- Make Ctrl+f act as / (search)
vim.api.nvim_set_keymap('n', '<A-f>', '/', { noremap = true })

-- Make U act as Ctrl+r (redo)
vim.api.nvim_set_keymap('n', 'U', '<C-r>', { noremap = true })

vim.api.nvim_set_keymap('n', '<A-w>', '<C-w>', { noremap = true })

vim.api.nvim_set_keymap('n', '<A-c>', ':so /home/zeph/.config/lvim/config.lua<Enter>', { noremap = true })

-- Make kj in insert mode act as Esc
vim.api.nvim_set_keymap('i', 'kj', '<Esc>', { noremap = true })

-- Preview method definition
vim.keymap.set("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { noremap = true })

-- remove current behavior of gl
vim.api.nvim_set_keymap('n', 'H', '^', { noremap = true })
vim.api.nvim_set_keymap('n', 'L', '$', { noremap = true })


-- Lua
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)



require("nvim-navbuddy").setup {
  window = {
    size = { height = "40%", width = "80%" }
  },
}

require'marks'.setup {
  mappings = {
    set_next = "<A-m>",
    next = "<A-n>",
    preview = "m:",
    set_bookmark0 = "m0",
    prev = false -- pass false to disable only this default mapping
  }
}


-- fix clangd problem
local cmp_nvim_lsp = require "cmp_nvim_lsp"
require("lspconfig").clangd.setup {
  on_attach = on_attach,
  capabilities = cmp_nvim_lsp.default_capabilities(),
  cmd = {
    "clangd",
    "--offset-encoding=utf-16",
  },
}


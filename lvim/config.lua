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
--U = capitalize visually selected text
--u = lowercase visually selected text
--"0p = paste from register 0 (yanked before delete)
--Ctrl + r + = = evaluate expression in insert mode
--m + char = mark line with char
--m + capital char = mark line across files with char
--' + char = jump to mark char
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
-----------------------------------------------------------------------------

-- Enable useful snippets
require'luasnip'.filetype_extend("dart", {"flutter"})
require'luasnip'.filetype_extend("cs", {"unity"})

-- Set color scheme
lvim.colorscheme = "tokyonight-storm"



-- Remap half page up/down to Alt+u/d
vim.api.nvim_set_keymap('n', '<A-u>', '<C-u>', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-d>', '<C-d>', { noremap = true })


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
  { 'mg979/vim-visual-multi' },
  { 'tpope/vim-eunuch' },
  { 'tikhomirov/vim-glsl' },
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
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  { 'leoluz/nvim-dap-go' },
  { 'ekickx/clipboard-image.nvim' },
  { 'jbyuki/nabla.nvim' },
  {
      'akinsho/flutter-tools.nvim',
      lazy = false,
      dependencies = {
          'nvim-lua/plenary.nvim',
          'stevearc/dressing.nvim', -- optional for vim.ui.select
      },
      config = true,
  },
  {'iamcco/markdown-preview.nvim'},
  {
   "folke/trouble.nvim",
   dependencies = { "nvim-tree/nvim-web-devicons" },
   opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
   },
  },
}


require'lspconfig'.marksman.setup{}



-- Replace visual selection with confirmation
vim.api.nvim_set_keymap('v', '<C-r>', '"hy:%s/<C-r>h//gc<left><left><left>', { noremap = true })

-- Open symbols tab
vim.api.nvim_set_keymap('n', '<A-e>', ':Navbuddy<Enter>', { noremap = true })

-- Paste image in markdown
vim.api.nvim_set_keymap('n', '<C-p>', ':PasteImg<Enter>', { noremap = false })

-- Preview method definition
vim.keymap.set("n", "gl", "<cmd>lua require('nabla').popup()<CR>", { noremap = true })




-- require('go').setup()

-- require('dap-go').setup()

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



-- local dap = require('dap')
-- dap.adapters.cppdbg = {
--   id = 'cppdbg',
--   type = 'executable',
--   -- command = '/absolute/path/to/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
--   command = '',
-- }

-- dap.configurations.cpp = {
--   {
--     name = "Launch file",
--     type = "cppdbg",
--     request = "launch",
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--     cwd = '${workspaceFolder}',
--     stopAtEntry = true,
--   },
--   {
--     name = 'Attach to gdbserver :1234',
--     type = 'cppdbg',
--     request = 'launch',
--     MIMode = 'gdb',
--     miDebuggerServerAddress = 'localhost:1234',
--     miDebuggerPath = '/usr/bin/gdb',
--     cwd = '${workspaceFolder}',
--     program = function()
--       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--     end,
--   },
-- }

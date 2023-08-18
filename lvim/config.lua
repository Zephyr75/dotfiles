
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
-- require('leap').add_default_mappings()

-- Set color scheme
lvim.colorscheme = "tokyonight-storm"
-- require('onedark').setup {
--     style = 'darker'
-- }
-- require('onedark').load()

-- require('dap-go').setup()

-- Replace visual selection with confirmation
vim.api.nvim_set_keymap('v', '<C-r>', '"hy:%s/<C-r>h//gc<left><left><left>', { noremap = true })

-- Open symbols tab
-- vim.api.nvim_set_keymap('n', '<C-o>', ':SymbolsOutline<Enter>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-e>', ':Navbuddy<Enter>', { noremap = true })

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
  { 'mg979/vim-visual-multi' },
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
}


require('go').setup()

require('dap-go').setup()

local cmp_nvim_lsp = require "cmp_nvim_lsp"

require("lspconfig").clangd.setup {
  on_attach = on_attach,
  capabilities = cmp_nvim_lsp.default_capabilities(),
  cmd = {
    "clangd",
    "--offset-encoding=utf-16",
  },
}



local dap = require('dap')
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  -- command = '/absolute/path/to/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
  command = '',
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopAtEntry = true,
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'cppdbg',
    request = 'launch',
    MIMode = 'gdb',
    miDebuggerServerAddress = 'localhost:1234',
    miDebuggerPath = '/usr/bin/gdb',
    cwd = '${workspaceFolder}',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
  },
}

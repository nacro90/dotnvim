local plugins = {}

local fn = vim.fn

local local_plugin_dir = vim.env.HOME .. "/Projects/plugins"

local uv = vim.loop

--- Prioritise the local plugins but download if they are not exist locally
local function localized(plugin, local_path)
  local _, name = unpack(vim.split(plugin, "%/"))
  local_path = local_path or local_plugin_dir .. "/" .. name
  if not uv.fs_stat(local_path) then
    return plugin
  end
  return local_path
end

local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  print "packer not found. bootstrapping..."
  fn.system {
    "git",
    "clone",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
end

vim.cmd "packadd packer.nvim"

local packer = require "packer"

local rocks = require "packer.luarocks"
rocks.install_commands()

local plugin_table = {

  "wbthomason/packer.nvim",

  "kvrohit/substrata.nvim",
  "elvessousa/sobrio",
  "cseelus/vim-colors-lucid",
  "jacoborus/tender.vim",
  "rakr/vim-two-firewatch",
  "kyazdani42/blue-moon",
  "cseelus/vim-colors-tone",
  "seesleestak/duo-mini",
  "AhmedAbdulrahman/aylin.vim",
  "fenetikm/falcon",
  { "npxbr/gruvbox.nvim", requires = { "rktjmp/lush.nvim" } },
  "shaunsingh/nord.nvim",
  "NTBBloodbath/doom-one.nvim",
  "marko-cerovac/material.nvim",
  "tomasiser/vim-code-dark",
  "bluz71/vim-moonfly-colors",
  "tanvirtin/monokai.nvim",
  "navarasu/onedark.nvim",
  "ishan9299/nvim-solarized-lua",
  "elianiva/icy.nvim",
  "elianiva/gruvy.nvim",
  { "rose-pine/neovim", as = "rose-pine" },
  { "embark-theme/vim", as = "embark" },
  "doums/darcula",
  {
    "frenzyexists/aquarium-vim",
    branch = "vimscript_version",
  },
  "Mangeshrex/uwu.vim",
  "glepnir/zephyr-nvim",

  "freitass/todo.txt-vim",
  "rafcamlet/nvim-luapad",
  { "bfredl/nvim-luadev" },
  {
    "tjdevries/vim-inyoface",
    cmd = "Inyoface",
    config = function()
      vim.cmd "command! Inyoface call inyoface#toggle_comments()"
    end,
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require("zen-mode").setup()
    end,
  },
  {
    "folke/lsp-trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    cmd = "Trouble",
    config = function()
      require("trouble").setup {
        fold_open = "???",
        fold_closed = "???",
        action_keys = {
          -- map to {} to remove a mapping, for example:
          -- close = {},
          jump = { "<cr>" },
          open_split = { "<c-s>" },
          hover = "<C-k>",
        },
        use_lsp_diagnostic_signs = true,
      }

      vim.api.nvim_set_keymap(
        "n",
        "<leader>dd",
        "<Cmd>LspTroubleToggle<CR>",
        { silent = true, noremap = true }
      )
    end,
  },
  {
    "mfussenegger/nvim-jdtls",
    config = function()
      require("nacro.lsp").setup_jdtls()
    end,
  },
  "nanotee/luv-vimdocs",
  "milisims/nvim-luaref",
  {
    "famiu/nvim-reload",
    cmd = "Reload",
    config = function()
      require "nvim-reload"
    end,
  },
  {
    "szw/vim-maximizer",
    setup = function()
      vim.g.maximizer_set_default_mapping = 0
      vim.api.nvim_set_keymap("n", "<leader>m", "<Cmd>MaximizerToggle<CR>", { noremap = true })
    end,
    cmd = "MaximizerToggle",
  },
  {
    -- Easy text exchange operator for Vim
    "tommcdo/vim-exchange",
    config = function()
      -- Starting with 'g' is more conveninent and vimish
      vim.api.nvim_set_keymap("n", "gx", "<Plug>(Exchange)", {})
      vim.api.nvim_set_keymap("x", "gx", "<Plug>(Exchange)", {})
      vim.api.nvim_set_keymap("n", "gxc", "<Plug>(ExchangeClear)", {})
      vim.api.nvim_set_keymap("n", "gxx", "<Plug>(ExchangeLine)", {})
      -- 'gX' should be like 'C' or 'D'
      vim.api.nvim_set_keymap("n", "gX", "gx$", {})
    end,
  },
  {
    -- Put text from string without yank the previous text
    "vim-scripts/ReplaceWithRegister",
    config = function()
      -- 'gR' should be like 'C' or 'D'
      vim.api.nvim_set_keymap("n", "gR", "gr$", {})
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "blackCauldron7/surround.nvim",
    config = function()
      require("surround").setup { mappings_style = "surround" }
    end,
  },
  {
    "junegunn/vim-easy-align",
    disable = false,
    config = function()
      -- Start interactive EasyAlign in visual mode (e.g. vipga)
      vim.api.nvim_set_keymap("x", "ga", "<Plug>(EasyAlign)", {})
      -- Start interactive EasyAlign for a motion/text object (e.g. gaip)
      vim.api.nvim_set_keymap("n", "ga", "<Plug>(EasyAlign)", {})
    end,
  },
  "kana/vim-textobj-user",
  "kana/vim-textobj-entire",
  "kana/vim-textobj-indent",
  "glts/vim-textobj-comment",
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = "maintained",
        highlight = { enable = true },
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["at"] = "@class.outer",
              ["it"] = "@class.inner",
              ["ig"] = "@block.inner",
              ["ag"] = "@block.outer",
              ["io"] = "@call.inner",
              ["ao"] = "@call.outer",
              ["ij"] = "@conditional.inner",
              ["aj"] = "@conditional.outer",
              ["il"] = "@loop.inner",
              ["al"] = "@loop.outer",
              ["ia"] = "@parameter.inner",
              ["aa"] = "@parameter.outer",
              ["as"] = "@statement.outer",
            },
          },
        },
        indent = { enable = true },
        autotag = { enable = true },
      }
    end,
    requires = {
      "nvim-treesitter/playground",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
  },
  {
    "NTBBloodbath/rest.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local autopairs = require "nvim-autopairs"

      autopairs.setup {
        enable_move_right = false,
      }
      require("nvim-autopairs.completion.cmp").setup {
        map_cr = true,
        map_complete = true,
        auto_select = true,
        insert = false,
        map_char = {
          all = "(",
          tex = "{",
        },
      }
      autopairs.add_rules(require "nvim-autopairs.rules.endwise-lua")
    end,
  },
  {
    "stevearc/aerial.nvim",
    config = function()
      vim.g.aerial = {
        max_width = 60,
      }
    end,
  },
  "tpope/vim-repeat",
  "tpope/vim-eunuch",
  "jose-elias-alvarez/null-ls.nvim",
  "justinmk/vim-dirvish",
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    requires = "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip").snippets = require "nacro.snippet"
      vim.cmd [[
        imap <silent><expr> <C-k> '<Plug>luasnip-expand-or-jump'
        inoremap <silent> <C-j> <cmd>lua require'luasnip'.jump(-1)<CR>

        snoremap <silent> <C-k> <cmd>lua require('luasnip').jump(1)<Cr>
        snoremap <silent> <C-j> <cmd>lua require('luasnip').jump(-1)<Cr>

        imap <silent><expr> <C-e> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-e>'
        smap <silent><expr> <C-e> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-e>'
      ]]
      require("luasnip/loaders/from_vscode").load()
    end,
  },
  {
    "hkupty/iron.nvim",
    disable = true,
    setup = function()
      vim.g.iron_map_defaults = 0
      vim.g.iron_map_extended = 0
      vim.api.nvim_set_keymap("n", "<leader>i", "<Cmd>IronFocus<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>I", "<Cmd>IronReplHere<CR>", { noremap = true })
    end,
    config = function()
      local iron = require "iron"
      iron.core.add_repl_definitions {
        python = { ipy = { command = { "ipython" } } },
        clojure = {
          lein_connect = { command = { "lein", "repl", ":connect" } },
        },
        haskell = { ghci = { command = { "ghci" } } },
        lua = { lua = { command = { "luajit" } } },
        java = { jshell = { command = { "jshell" } } },
      }
      iron.core.set_config {
        preferred = { python = "ipython", clojure = "lein" },
      }
    end,
    cmd = { "IronReplHere", "IronRepl", "IronFocus" },
  },
  {
    "jghauser/mkdir.nvim",
    config = function()
      require "mkdir"
    end,
  },
  "nvim-lua/plenary.nvim",
  "vim-test/vim-test",
  {
    "rcarriga/vim-ultest",
  },
  { "nvim-telescope/telescope-dap.nvim", requires = "nvim-lua/telescope.nvim" },
  {
    "nvim-lua/telescope.nvim",
    disable = false,
    requires = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-packer.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      { "nvim-telescope/telescope-frecency.nvim", requires = "tami5/sqlite.lua" },
      "jvgrootveld/telescope-zoxide",
      "dhruvmanila/telescope-bookmarks.nvim",
      "mrjones2014/tldr.nvim",
    },
  },
  { "tweekmonster/startuptime.vim", cmd = "StartupTime" },
  {
    "nvim-lualine/lualine.nvim",
    requires = { "SmiteshP/nvim-gps", { "kyazdani42/nvim-web-devicons", opt = true } },
  },
  {
    "ironhouzi/starlite-nvim",
    keys = { "*", "g*" },
    config = function()
      print "osman"
      local nnoremap = require("nacro.utils.map").nnoremap
      local starlite = require "starlite"
      nnoremap("*", starlite.star)
      nnoremap("g*", starlite.g_star)
      nnoremap("#", starlite.hash)
      nnoremap("g#", starlite.g_hash)
    end,
  },
  { "petobens/poet-v", disable = false, cmd = "PoetvActivate" },
  {
    "plasticboy/vim-markdown",
    config = function()
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_strikethrough = 1
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_conceal = 2
      vim.g.vim_markdown_conceal_code_blocks = 0
    end,
  },
  {
    "SmiteshP/nvim-gps",
    requires = "nvim-treesitter/nvim-treesitter",
  },
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup {
        start_in_insert = false,
      }
    end,
  },
  "tami5/sqlite.lua",
  {
    "kyazdani42/nvim-tree.lua",
    requires = { "kyazdani42/nvim-web-devicons" },
  },
  {
    "famiu/bufdelete.nvim",
    setup = function()
      vim.g.bclose_no_plugin_maps = 1
      vim.api.nvim_set_keymap("n", "<leader>x", "<Cmd>Bdelete<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>X", "<Cmd>Bdelete!<CR>", { noremap = true })
    end,
    cmd = { "Bdelete", "Bwipeout" },
  },
  "ahmedkhalf/project.nvim",
  "mfussenegger/nvim-dap",
  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
  { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } },
  {
    "lewis6991/gitsigns.nvim",
    requires = "nvim-lua/plenary.nvim",
  },
  "tpope/vim-scriptease",
  {
    "tpope/vim-fugitive",
    cmd = "Git",
    setup = function()
      vim.api.nvim_set_keymap("n", "<leader>G", "<Cmd>Git commit<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>g", "<Cmd>Git<CR>", { noremap = true })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-emoji",
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-cmdline",
      "dmitmel/cmp-cmdline-history",
    },
  },
  {
    "TimUntersberger/neogit",
    disable = true,
    config = function()
      require("neogit").setup {
        disable_context_highlighting = true,
        disable_commit_confirmation = true,
        signs = {
          section = { "???", "-" },
          item = { "???", "-" },
          hunk = { "???", "-" },
        },
      }
    end,
  },
  -- A git commit browser in Vim which displays a git graph
  { "junegunn/gv.vim", requires = "tpope/vim-fugitive", cmd = "GV" },
  {
    -- Visualize undo steps as a tree
    "mbbill/undotree",
    setup = function()
      -- Set the undotree window layout
      vim.g.undotree_WindowLayout = 3
    end,
    cmd = "UndotreeToggle",
  },
  {
    localized "nacro90/numb.nvim",
    disable = false,
    event = "CmdlineEnter",
    config = function()
      require("numb").setup()
    end,
  },
  localized "nacro90/omen.nvim",
  {
    localized "nacro90/turkishmode.nvim",
    config = function()
      vim.cmd [[command! DeasciifyBuffer lua require('turkishmode').deasciify_buffer()]]
    end,
    cmd = "DeasciifyBuffer",
  },
  "neovim/nvim-lspconfig",
}

function plugins.setup()
  local num_cpus = #vim.loop.cpu_info()
  packer.startup {
    function()
      for _, value in ipairs(plugin_table) do
        packer.use(value)
      end
    end,
    config = {
      max_jobs = num_cpus,
      display = {
        open_fn = function()
          return require("packer.util").float { border = "single" }
        end,
      },
    },
  }
end

return plugins

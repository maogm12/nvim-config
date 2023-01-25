local api = vim.api
local fn = vim.fn

local utils = require("utils")

-- The root dir to install all plugins. Plugins are under opt/ or start/ sub-directory.
vim.g.plugin_home = fn.stdpath("data") .. "/site/pack/packer"

--- Install packer if it has not been installed.
--- Return:
--- true: if this is a fresh install of packer
--- false: if packer has been installed
local function packer_ensure_install()
  -- Where to install packer.nvim -- the package manager (we make it opt)
  local packer_dir = vim.g.plugin_home .. "/opt/packer.nvim"

  if fn.glob(packer_dir) ~= "" then
    return false
  end

  -- Auto-install packer in case it hasn't been installed.
  vim.api.nvim_echo({ { "Installing packer.nvim", "Type" } }, true, {})

  local packer_repo = "https://github.com/wbthomason/packer.nvim"
  local install_cmd = string.format("!git clone --depth=1 %s %s", packer_repo, packer_dir)
  vim.cmd(install_cmd)

  return true
end

local fresh_install = packer_ensure_install()

-- Load packer.nvim
vim.cmd("packadd packer.nvim")

local packer = require("packer")
local packer_util = require("packer.util")

packer.startup {
  function(use)
    -- it is recommended to put impatient.nvim before any other plugins
    use { "lewis6991/impatient.nvim", config = [[require('impatient')]] }

    -- package manager
    use { "wbthomason/packer.nvim", opt = true }

    -- vscode-like pictograms in neovim built-in lsp popup items
    use { "onsails/lspkind-nvim", event = "VimEnter" }

    -- auto-completion engine
    use { "hrsh7th/nvim-cmp", after = "lspkind-nvim", config = [[require('config.nvim-cmp')]] }

    -- nvim-cmp completion sources
    use { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" }
    use { "hrsh7th/cmp-path", after = "nvim-cmp" }
    use { "hrsh7th/cmp-buffer", after = "nvim-cmp" }
    use { "hrsh7th/cmp-omni", after = "nvim-cmp" }
    use { "quangnguyen30192/cmp-nvim-ultisnips", after = { "nvim-cmp", "ultisnips" } }
    if vim.g.is_mac then
      use { "hrsh7th/cmp-emoji", after = "nvim-cmp" }
    end

    -- nvim-lsp configuration (it relies on cmp-nvim-lsp, so it should be loaded after cmp-nvim-lsp).
    use { "neovim/nvim-lspconfig", after = "cmp-nvim-lsp", config = [[require('config.lsp')]] }

    -- treesitter
    if vim.g.is_mac then
      use {
        "nvim-treesitter/nvim-treesitter",
        event = "BufEnter",
        run = ":TSUpdate",
        config = [[require('config.treesitter')]],
      }
    end

    -- Python indent (follows the PEP8 style)
    use { "Vimjas/vim-python-pep8-indent", ft = { "python" } }

    -- Python-related text object
    use { "jeetsukumaran/vim-pythonsense", ft = { "python" } }

    -- swap delimited items
    use { "machakann/vim-swap", event = "VimEnter" }

    -- Super fast buffer jump
    use {
      "phaazon/hop.nvim",
      event = "VimEnter",
      config = function()
        vim.defer_fn(function()
          require("config.nvim_hop")
        end, 2000)
      end,
    }

    -- Show `[1/n]` style match number and index for searching
    use {
      "kevinhwang91/nvim-hlslens",
      branch = "main",
      keys = { { "n", "*" }, { "n", "#" }, { "n", "n" }, { "n", "N" } },
      config = [[require('config.hlslens')]],
    }

    -------------------------------------------------------------------------------------------------------------------
    -- Telescope
    -------------------------------------------------------------------------------------------------------------------
    -- File search, tag search and more
    use {
      "nvim-telescope/telescope.nvim",
      cmd = "Telescope",
      requires = { "nvim-lua/plenary.nvim", "BurntSushi/ripgrep" },
    }

    use {
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      config = function()
        require"telescope".load_extension("fzf")
      end,
      after = "telescope.nvim"
    }

    -- telescope plugin for searching emoji and other symbols
    use {
      "nvim-telescope/telescope-symbols.nvim",
      after = "telescope.nvim"
    }

    -- telescope plugin for showing editing history
    use {
      "kkharji/sqlite.lua",
      setup = [[require('setup.sqlite')]],
      requires = "nvim-lua/plenary.nvim",
    }

    use {
      "nvim-telescope/telescope-frecency.nvim",
      config = function()
        require"telescope".load_extension("frecency")
      end,
      requires = {"kkharji/sqlite.lua"},
      after = "telescope.nvim"
    }

    -- devicons, need a patched NERD font
    use { "nvim-tree/nvim-web-devicons", event = "VimEnter" }

    -- statusline
    use {
      "nvim-lualine/lualine.nvim",
      event = "VimEnter",
      config = [[require('config.statusline')]],
    }

    -- better buffer delete
    use "famiu/bufdelete.nvim"

    -- render buffers as tabs
    use { "akinsho/bufferline.nvim",
      event = "VimEnter",
      config = [[require('config.bufferline')]],
      requires = "famiu/bufdelete.nvim",
      after = 'bufdelete.nvim'
    }

    -- fancy start screen
    use { "glepnir/dashboard-nvim",
      event = "VimEnter",
      config = [[require('config.dashboard-nvim')]]
    }

    -- indent |
    use {
      "lukas-reineke/indent-blankline.nvim",
      event = "VimEnter",
      config = [[require('config.indent-blankline')]],
    }

    -- Highlight URLs inside vim
    use { "itchyny/vim-highlighturl", event = "VimEnter" }

    -- notification plugin
    use {
      "rcarriga/nvim-notify",
      event = "BufEnter",
      config = function()
        vim.defer_fn(function()
          require("config.nvim-notify")
        end, 2000)
      end,
    }

    -- For Windows and Mac, we can open an URL in the browser. For Linux, it may
    -- not be possible since we maybe in a server which disables GUI.
    if vim.g.is_win or vim.g.is_mac then
      -- open URL in browser
      use { "tyru/open-browser.vim", event = "VimEnter" }
    end

    -- Only install these plugins if ctags are installed on the system
    if utils.executable("ctags") then
      -- show file tags in vim window
      use { "liuchengxu/vista.vim", cmd = "Vista" }
    end

    -- Snippet engine and snippet template
    use { "SirVer/ultisnips", event = "InsertEnter" }
    use { "honza/vim-snippets", after = "ultisnips" }

    -- Automatic insertion and deletion of a pair of characters
    use { "Raimondi/delimitMate", event = "InsertEnter" }

    -- Comment plugin
    use {
      'numToStr/Comment.nvim',
      config = [[require('config.Comment')]] 
    }

    -- Autosave files on certain events
    use { "907th/vim-auto-save", event = "InsertEnter" }

    -- Show undo history visually
    use { "simnalamburt/vim-mundo", cmd = { "MundoToggle", "MundoShow" } }

    -- better UI for some nvim actions
    use {'stevearc/dressing.nvim'}

    -- Repeat vim motions
    use { "tpope/vim-repeat", event = "VimEnter" }

    -- better escaping with kj
    use {
      "max397574/better-escape.nvim",
      event = { "InsertEnter" },
      config = function() require("better_escape").setup { mapping = {"kj" } } end
    }

    -- Auto format tools
    use { "sbdchd/neoformat", cmd = { "Neoformat" } }

    ------------------ Git ---------------------
    -- Git command inside vim
    use { "tpope/vim-fugitive", event = "User InGitRepo", config = [[require('config.fugitive')]] }

    -- Better git log display
    use { "rbong/vim-flog", requires = "tpope/vim-fugitive", cmd = { "Flog" } }

    use { "christoomey/vim-conflicted", requires = "tpope/vim-fugitive", cmd = { "Conflicted" } }

    use {
      "ruifm/gitlinker.nvim",
      requires = "nvim-lua/plenary.nvim",
      event = "User InGitRepo",
      config = [[require('config.git-linker')]],
    }

    -- Show git change (change, delete, add) signs in vim sign column
    use { "lewis6991/gitsigns.nvim", config = [[require('config.gitsigns')]] }

    -- Better git commit experience
    use { "rhysd/committia.vim", opt = true, setup = [[vim.cmd('packadd committia.vim')]] }
    -----------------------------------------------

    -- Another markdown plugin
    use { "preservim/vim-markdown", ft = { "markdown" } }

    -- Faster footnote generation
    use { "vim-pandoc/vim-markdownfootnotes", ft = { "markdown" } }

    -- Vim tabular plugin for manipulate tabular, required by markdown plugins
    use { "godlygeek/tabular", cmd = { "Tabularize" } }

    -- Markdown previewing (only for Mac and Windows)
    if vim.g.is_win or vim.g.is_mac then
      use { "iamcco/markdown-preview.nvim", ft = { "markdown" } }
    end

    -- handling unicode and digraphs characters
    use { "chrisbra/unicode.vim", event = "VimEnter" }

    -- Additional powerful text object for vim, this plugin should be studied
    -- carefully to use its full power
    use { "wellle/targets.vim", event = "VimEnter" }

    -- Plugin to manipulate character pairs quickly
    use { "machakann/vim-sandwich", event = "VimEnter" }

    -- Add indent object for vim (useful for languages like Python)
    use { "michaeljsmith/vim-indent-object", event = "VimEnter" }

    -- Only use these plugin on Windows and Mac and when LaTeX is installed
    if utils.executable("latex") then
      use {
        "lervag/vimtex",
        ft = { "tex" },
        -- config = [[require('config.vimtex')]]
      }
    end

    -- Since tmux is only available on Linux and Mac, we only enable these plugins
    -- for Linux and Mac
    if utils.executable("tmux") then
      -- .tmux.conf syntax highlighting and setting check
      use { "tmux-plugins/vim-tmux", ft = { "tmux" } }
    end

    -- Modern matchit implementation
    use { "andymass/vim-matchup", event = "VimEnter" }

    use { "tpope/vim-scriptease", cmd = { "Scriptnames", "Message", "Verbose" } }

    -- Asynchronous command execution
    use { "skywind3000/asyncrun.vim", opt = true, cmd = { "AsyncRun" } }

    use { "cespare/vim-toml", ft = { "toml" }, branch = "main" }

    -- Debugger plugin
    if vim.g.is_win or vim.g.is_linux then
      use {
        "sakhnik/nvim-gdb",
        run = { "bash install.sh" },
        opt = true,
        setup = [[vim.cmd('packadd nvim-gdb')]] }
    end

    -- Session management plugin
    use { "tpope/vim-obsession", cmd = "Obsession" }

    if vim.g.is_linux then
      use { "ojroques/vim-oscyank", cmd = { "OSCYank", "OSCYankReg" } }
    end

    -- The missing auto-completion for cmdline!
    use {
      "gelguy/wilder.nvim",
      opt = true,
      event = "VimEnter",
      config = [[require('config.wilder')]],
    }

    -- showing keybindings
    use {
      "folke/which-key.nvim",
      event = "VimEnter",
      config = function()
        vim.defer_fn(function()
          require("config.which-key")
        end, 2000)
      end,
    }

    -- show and trim trailing whitespaces
    use { "jdhao/whitespace.nvim", event = "VimEnter" }

    -- file explorer
    use {
      "nvim-tree/nvim-tree.lua",
      requires = { "nvim-tree/nvim-web-devicons" },
      config = [[require('config.nvim-tree')]],
    }

    -- Neovim completion library for sumneko/lua-language-server
    use { "ii14/emmylua-nvim", ft = "lua" }

    use { "j-hui/fidget.nvim", after = "nvim-lspconfig", config = [[require('config.fidget-nvim')]] }

    -- colorscheme onedark
    use "navarasu/onedark.nvim"

    -- auto dark mode
    if vim.g.is_mac then
      use {
        'f-person/auto-dark-mode.nvim',
        after = 'onedark.nvim',
        config = [[require('config.auto-dark-mode')]]
      }
    end

    -- measure startup time
    use "dstein64/vim-startuptime"

    -- floating window for terminal
    use "voldikss/vim-floaterm"

  end,
  config = {
    max_jobs = 16,
    compile_path = packer_util.join_paths(fn.stdpath("data"), "site", "lua", "packer_compiled.lua"),
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    },
  },
}

-- For fresh install, we need to install plugins. Otherwise, we just need to require `packer_compiled.lua`.
if fresh_install then
  -- We run packer.sync() here, because only after packer.startup, can we know which plugins to install.
  -- So plugin installation should be done after the startup process.
  packer.sync()
else
  local status, _ = pcall(require, "packer_compiled")
  if not status then
    local msg = "File packer_compiled.lua not found: run PackerSync to fix!"
    vim.notify(msg, vim.log.levels.ERROR, { title = "nvim-config" })
  end
end

-- Auto-generate packer_compiled.lua file
api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = "*/nvim/lua/plugins.lua",
  group = api.nvim_create_augroup("packer_auto_compile", { clear = true }),
  callback = function(ctx)
    local cmd = "source " .. ctx.file
    vim.cmd(cmd)
    vim.cmd("PackerCompile")
    vim.notify("PackerCompile done!", vim.log.levels.INFO, { title = "Nvim-config" })
  end,
})

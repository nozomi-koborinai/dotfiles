return {
  -- Color scheme
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = "hard"
      vim.g.gruvbox_material_foreground = "material"
      vim.cmd.colorscheme("gruvbox-material")
    end,
  },

  -- Syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "dart",
        "dockerfile",
        "go",
        "hcl",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "tsx",
        "typescript",
        "yaml",
      },
    },
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local map = function(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc }) end
        map("n", "]c", function() gs.nav_hunk("next") end, "Next hunk")
        map("n", "[c", function() gs.nav_hunk("prev") end, "Prev hunk")
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>hd", gs.diffthis, "Diff this")
      end,
    },
  },

  -- Buffer line (tabs)
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {
      options = {
        always_show_bufferline = true,
        offsets = {
          { filetype = "neo-tree", text = "Explorer", text_align = "left", separator = true },
        },
        show_close_icon = false,
        separator_style = "thin",
      },
    },
  },

  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    cmd = "Neotree",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({
            source = "filesystem",
            position = "left",
            action = "show",
            toggle = true,
          })
        end,
        desc = "Toggle file explorer",
      },
      {
        "<leader>o",
        function()
          require("neo-tree.command").execute({
            source = "filesystem",
            position = "left",
            action = "show",
            reveal = true,
          })
        end,
        desc = "Reveal in explorer",
      },
    },
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        width = 35,
      },
      default_component_configs = {
        indent = {
          with_markers = true,
          with_expanders = true,
        },
      },
    },
  },

  -- Auto close brackets
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Accelerated j/k
  {
    "rainbowhxch/accelerated-jk.nvim",
    keys = {
      { "j", "<Plug>(accelerated_jk_gj)", desc = "Accelerated j" },
      { "k", "<Plug>(accelerated_jk_gk)", desc = "Accelerated k" },
    },
  },

  -- Treesitter context (show current function at top)
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      max_lines = 3,
    },
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
  },

  -- Breadcrumb bar
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },

  -- Keybinding help
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Markdown render in editor
  {
    "OXY2DEV/markview.nvim",
    ft = "markdown",
    opts = {},
  },

  -- snacks.nvim (replaces: dashboard, telescope, toggleterm, lazygit, hlchunk)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        preset = {
          header = [[
                        _
  _ __   ___  _____   _(_)_ __ ___
 | '_ \ / _ \/ _ \ \ / / | '_ ` _ \
 | | | |  __/ (_) \ V /| | | | | | |
 |_| |_|\___|\___/ \_/ |_|_| |_| |_|]],
          keys = {
            { icon = "  ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = "  ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('recent')" },
            { icon = "  ", key = "g", desc = "Live Grep", action = ":lua Snacks.dashboard.pick('grep')" },
            { icon = "  ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
      image = { enabled = false },
      gitbrowse = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      lazygit = { enabled = true },
      notifier = { enabled = true },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      -- Picker
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Live grep" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fs", function() Snacks.picker.grep_word() end, desc = "Grep word under cursor" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent files" },
      -- Terminal
      { "<leader>t", function() Snacks.terminal.toggle() end, desc = "Toggle terminal" },
      { "<Esc><Esc>", "<C-\\><C-n>", mode = "t", desc = "Exit terminal mode" },
      -- Git
      { "<leader>gg", function() Snacks.lazygit() end, desc = "LazyGit" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Open in browser" },
      -- Notification
      { "<leader>un", function() Snacks.notifier.show_history() end, desc = "Notification history" },
      -- Keymaps
      { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Search keymaps" },
    },
  },
}

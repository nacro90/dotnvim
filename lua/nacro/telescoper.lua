local telescoper = {}

local err_writeln = vim.api.nvim_err_writeln

local map = require "nacro.utils.map"
local nnoremap = map.nnoremap

local telescope = require "telescope"
local builtin = require "telescope.builtin"
local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local previewers = require "telescope.previewers"
local action_state = require "telescope.actions.state"
local conf = require("telescope.config").values

local function find(cwd, only_dir)
  if 1 ~= vim.fn.executable "fd" then
    err_writeln "fd not found in the system"
    return
  end

  local find_command = {
    "fd",
    "--no-ignore-vcs",
    "--exclude",
    "*.class",
    "--exclude",
    "target",
    "--type",
    only_dir and "d" or "f",
    ".",
  }

  builtin.find_files {
    cwd = cwd or vim.loop.cwd(),
    find_command = find_command,
    -- previewer = false,
    layout_strategy = "flex",
    shorten_path = false,
  }
end

telescoper.find_files = find

function telescoper.find_dirs(cwd)
  find(cwd, true)
end

function telescoper.find_zettel(zettelkasten_dir)
  zettelkasten_dir = zettelkasten_dir or vim.env.HOME .. "/zettelkasten"
  builtin.find_files { cwd = zettelkasten_dir }
end

local function load_extensions()
  local exts = {
    "fzy_native",
    "frecency",
    "fzf",
    "dap",
    "projects",
    "zoxide",
    "tldr",
    "bookmarks",
  }

  for _, ext in ipairs(exts) do
    telescope.load_extension(ext)
  end
end

local function set_keymaps()
  nnoremap("<leader>N", function()
    builtin.git_files { previewer = false, layout_strategy = "vertical" }
  end)
  nnoremap("<leader>n", telescoper.find_files)

  nnoremap("<leader>en", function()
    telescoper.find_files(vim.fn.stdpath "config")
  end)
  nnoremap("<leader>eN", function()
    telescoper.find_files(vim.fn.stdpath "data")
  end)
  nnoremap("<leader>o", function()
    builtin.live_grep { path_display = { "tail" } }
  end)

  local extensions = telescope.extensions
  nnoremap("<leader>O", builtin.current_buffer_fuzzy_find)
  nnoremap("<leader>:", builtin.command_history)
  nnoremap("<leader>b", builtin.buffers)
  nnoremap("<leader>H", telescope.extensions.frecency.frecency)
  nnoremap("<leader>p", telescope.extensions.projects.projects)
  nnoremap("<leader>eh", builtin.help_tags)
  nnoremap("<leader>c", extensions.zoxide.list)
end

function telescoper.setup()
  telescope.setup {
    defaults = { layout_strategy = "flex" },
    extensions = {
      frecency = {
        show_scores = true,
        ignore_patterns = { "*.git/*" },
        workspaces = {
          ["conf"] = "/home/orcan/.config",
          ["data"] = "/home/orcan/.local/share",
          ["prod"] = "/home/orcan/prod",
        },
      },
    },
  }

  load_extensions()
  set_keymaps()
end

return telescoper

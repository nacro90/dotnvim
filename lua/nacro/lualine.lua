local n_lualine = {}

local lualine = require "lualine"
local gps = require "nvim-gps"

local function setup_gps()
  gps.setup {
    icons = {
      ["class-name"] = " ", -- Classes and class-like objects
      ["function-name"] = " ", -- Functions
      ["container-name"] = "{} ", -- Containers (example: lua tables)
      ["tag-name"] = "<> ", -- Tags (example: html tags)
    },
    languages = { -- You can disable any language individually here
      ["c"] = true,
      ["cpp"] = true,
      ["go"] = true,
      ["java"] = true,
      ["javascript"] = true,
      ["lua"] = true,
      ["python"] = true,
      ["rust"] = true,
    },
    separator = " > ",
  }
end

function n_lualine.setup()
  setup_gps()
  lualine.setup {
    options = {
      theme = "codedark",
      component_separators = { "│", "│" },
      section_separators = { "", "" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "filename" },
      lualine_c = {
        {
          "diagnostics",
          sources = { "nvim_lsp" },
          sections = { "error", "warn", "info", "hint" },
          color_error = "#F44747",
          color_warn = "#CE9178",
          color_info = "#BBBBBB",
          color_hint = "#BBBBBB",
          symbols = { error = "▪", warn = "▴", info = "›", hint = "▸" },
        },
        { gps.get_location, cond = gps.is_available },
      },
      lualine_x = {
        "branch",
        "encoding",
        "fileformat",
        "filetype",
      },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { "filename" },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    extensions = { "nvim-tree", "fugitive" },
  }
end

return n_lualine

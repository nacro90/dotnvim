----------------------------
--- Lsp Configuration Module
----------------------------
local lsp = {}

local lspconfig = require "lspconfig"
local telescope_builtin = require "telescope.builtin"
local map = require "nacro.utils.map"

local common = require "nacro.lsp.common"
local lua = require "nacro.lsp.lua"

local cmd = vim.cmd
local fn = vim.fn
local api = vim.api
local nnoremap = map.nnoremap
local inoremap = map.inoremap
local vnoremap = map.vnoremap

function lsp.setup()
  local capabilities = common.create_lsp_capabilities()

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      virtual_text = false,
      signs = true,
      update_in_insert = false,
    }
  )

  lua.setup()

  local null_ls = require "null-ls"
  local null_ls_helpers = require "null-ls.helpers"
  local FORMATTING = require("null-ls.methods").internal.FORMATTING

  local formatters = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics

  -- local jq = null_ls_helpers.make_builtin{
  --   method=FORMATTING,
  --   filetypes = {"json"},
  --   generator_opts = {
  --     command = "jq",
  --     to_stdin = true
  --   },
  --   factory = null_ls_helpers.formatter_factory,
  -- }

  null_ls.config {
    sources = {
      formatters.stylua.with {
        args = { "--config-path", vim.fn.stdpath "config" .. "/stylua.toml", "-" },
      },
      formatters.black,
      formatters.isort,
      formatters.shfmt,

      diagnostics.shellcheck,
      diagnostics.vint,
    },
  }

  local languages = {
    "hls",
    "dockerls",
    "clangd",
    "pyright",
    "flow",
    "svelte",
    "gopls",
    "null-ls",
    "yamlls",
  }

  for _, language in ipairs(languages) do
    lspconfig[language].setup {
      capabilities = capabilities,
      on_attach = common.on_attach,
    }
  end
end

local jdtls = require "jdtls"
local jdtls_setup = require "jdtls.setup"
local jdtls_dap = require "jdtls.dap"

local function on_jdtls_attached(client, bufnr)
  common.on_attach_common(client, bufnr)

  ---Create a function that calls the function with true as its first parameter
  ---@param func function(param: bool)
  ---@return function()
  local function w_true(func)
    return function()
      return func(true)
    end
  end

  nnoremap("<leader>a", jdtls.code_action, bufnr)
  vnoremap("<leader>a", w_true(jdtls.code_action), bufnr)
  nnoremap("go", jdtls.organize_imports, bufnr)
  nnoremap("<leader>ev", jdtls.extract_variable, bufnr)
  vnoremap("<leader>ev", w_true(jdtls.extract_variable), bufnr)
  nnoremap("<leader>ec", jdtls.extract_constant, bufnr)
  vnoremap("<leader>ec", w_true(jdtls.extract_constant), bufnr)
  nnoremap("<leader>em", jdtls.extract_method, bufnr)
  vnoremap("<leader>em", w_true(jdtls.extract_method), bufnr)

  jdtls.setup_dap { hotcodereplace = "auto" }
  -- jdtls_dap.setup_dap_main_class_configs()

  jdtls_setup.add_commands()
end

function lsp.on_java_opened()
  local share = fn.stdpath "data"
  jdtls.start_or_attach {
    cmd = {
      "java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xms1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",
      "-jar",
      "/Users/orcan.tiryakioglu/Downloads/jdt-language-server-1.5.0-202110191539/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
      "-configuration",
      "/Users/orcan.tiryakioglu/Downloads/jdt-language-server-1.5.0-202110191539/config_mac",
      "-data",
      "/Users/orcan.tiryakioglu/workspace",
    },
    on_attach = on_jdtls_attached,
  }
end

function lsp.setup_jdtls()
  local has_jdtls = pcall(require, "jdtls")
  if vim.fn.has "nvim-0.5" and has_jdtls then
    vim.cmd [[
    augroup lsp
      au!
      au FileType java lua require('nacro.lsp').on_java_opened()
    augroup end
  ]]
  end
end

return lsp

local colorscheme = {}

local cmd = vim.cmd
local fn = vim.fn

function colorscheme.setup(name)
  cmd [[
    augroup colorscheme_tweaks
      autocmd!
      autocmd ColorScheme * lua require('nacro.colorscheme').on_colorscheme()
    augroup END
   ]]

  name = name or "codedark"
  vim.cmd("colorscheme " .. name)

  fn.sign_define("DiagnosticSignError", { text = "▪", texthl = "DiagnosticSignError" })
  fn.sign_define("DiagnosticSignWarning", { text = "▴", texthl = "DiagnosticSignWarning" })
  fn.sign_define(
    "DiagnosticSignInformation",
    { text = "›", texthl = "DiagnosticSignInformation" }
  )
  fn.sign_define("DiagnosticSignHint", { text = "▸", texthl = "DiagnosticSignHint" })
end

function colorscheme.on_colorscheme()
  local exists, tweak = pcall(require, "nacro.colorscheme." .. vim.g.colors_name)

  if not exists then
    return
  end

  local t = type(tweak)
  if t == "string" then
    cmd(tweak)
  elseif t == "function" then
    tweak()
  end
end

return colorscheme

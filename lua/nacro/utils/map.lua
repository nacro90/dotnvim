---@type map
local map = {}

---@class map_attrs
---@field public nowait boolean
---@field public silent boolean
---@field public script boolean
---@field public expr boolean
---@field public unique boolean

---@class map
---@field public nnoremap function(lhs:string, rhs:string, bufnr:integer|nil, attrs:map_attrs)
---@field public vnoremap function(lhs:string, rhs:string, bufnr:integer|nil, attrs:map_attrs)
---@field public inoremap function(lhs:string, rhs:string, bufnr:integer|nil, attrs:map_attrs)
---@field public xnoremap function(lhs:string, rhs:string, bufnr:integer|nil, attrs:map_attrs)
---@field public tnoremap function(lhs:string, rhs:string, bufnr:integer|nil, attrs:map_attrs)
---@field public cnoremap function(lhs:string, rhs:string, bufnr:integer|nil, attrs:map_attrs)
---@field public nmap function(lhs:string, rhs:string, bufnr:integer|nil, attrs:map_attrs)
---@field public vmap function(lhs:string, rhs:string, bufnr:integer|nil, attrs:map_attrs)
---@field public imap function(lhs:string, rhs:string, bufnr:integer|nil, attrs:map_attrs)
---@field public xmap function(lhs:string, rhs:string, bufnr:integer|nil, attrs:map_attrs)
---@field public tmap function(lhs:string, rhs:string, bufnr:integer|nil, attrs:map_attrs)
---@field private _callbacks function[]

local api = vim.api
local keymap = api.nvim_set_keymap
local bufkeymap = api.nvim_buf_set_keymap

map._callbacks = {}

---@param mode string @map mode
---@param noremap boolean
---@return function(lhs:string, rhs:string|function, bufnr:integer|nil)
local function create_mapper_func(mode, noremap)
  return function(lhs, rhs, bufnr, attrs)
    local action = rhs
    if type(rhs) == "function" then
      local callback_index = #map._callbacks + 1
      map._callbacks[callback_index] = rhs
      action = "<Cmd>lua require'nacro.utils.map'._callbacks[" .. callback_index .. "]()<CR>"
    end

    local final_attrs = { noremap = noremap }
    if attrs then
      vim.tbl_extend("force", final_attrs, attrs)
    end

    if bufnr then
      bufkeymap(bufnr, mode, lhs, action, final_attrs)
    else
      keymap(mode, lhs, action, final_attrs)
    end
  end
end

local modes = { "n", "i", "v", "!", "x", "t", "c" }

for _, mode in ipairs(modes) do
  map[mode .. "noremap"] = create_mapper_func(mode, true)
  map[mode .. "map"] = create_mapper_func(mode, false)
end

return map

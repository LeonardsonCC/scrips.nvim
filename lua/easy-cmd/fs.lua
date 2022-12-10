local Path = require('plenary.path')

local M = {
  path = "",
}

M.setup_folder = function(path)
  local expanded_path = vim.fn.expand(path)

  M.path = path

  Path:new(expanded_path):mkdir({})
end

local function new_file(name)
  local expanded_file = vim.fn.expand(M.path .. name)
  local file = Path:new(expanded_file)
  if not file:exists() then
    file:write("", "w")
  end
end

local function open_file(name)
  local expanded_file = vim.fn.expand(M.path .. name)
  vim.cmd('e ' .. expanded_file)
end

M.open_or_create_file = function(name)
  new_file(name)
  open_file(name)
end

return M

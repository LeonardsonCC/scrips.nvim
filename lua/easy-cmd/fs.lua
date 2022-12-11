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
  vim.cmd('set syntax=sh')
end

M.open_or_create_file = function(name)
  new_file(name)
  open_file(name)
end

M.list_files = function()
  local scan = require "plenary.scandir"
  local scripts_folder = Path:new(vim.fn.expand(M.path))

  local scripts_file = scan.scan_dir(scripts_folder:absolute(), { hidden = true })

  local list = {}
  for _, filepath in pairs(scripts_file) do
    local t = {}
    for str in string.gmatch(filepath, '([^/]+)') do
      table.insert(t, {
        filepath = filepath,
        name = str,
      })
    end
    table.insert(list, t[#t])
  end

  print(vim.inspect(list))


  return list
end

return M

local Path = require('plenary.path')

local M = {}

M.setup_folder = function(path)
  local expanded_path = vim.fn.expand(path)

  Path:new(expanded_path):mkdir({})
end

return M

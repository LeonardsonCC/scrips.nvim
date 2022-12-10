local ui = require('easy-cmd.ui')

M = {}

M.run_command = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, nil)

  local win_info = ui.open_window()

  local cmd = ""
  for _, line in pairs(lines) do
    cmd = cmd .. "\n" .. line
  end

  vim.api.nvim_buf_set_lines(win_info.bufnr, -1, -1, false, lines)

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = M.output_to_buf(win_info.bufnr),
    on_stderr = M.output_to_buf(win_info.bufnr),
  })
end

M.output_to_buf = function(bufnr)
  return function(_, data)
    if data then
      vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
    end
  end
end

return M

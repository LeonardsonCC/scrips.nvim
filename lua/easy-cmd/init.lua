local ui = require('easy-cmd.ui')
local fs = require('easy-cmd.fs')

M = {
  path = "~/.scripts/"
}

local function output_to_buf(bufnr)
  return function(_, data)
    if data then
      vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
    end
  end
end

local function get_visual_selection()
  local s_start = vim.fn.getpos("'<")
  local s_end = vim.fn.getpos("'>")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)

  if #lines == 0 then
    return {}
  end

  lines[1] = string.sub(lines[1], s_start[3], -1)
  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end
  return lines
end

M.setup = function()
  fs.setup_folder(M.path)
end

M.run = function()
  local bufnr = vim.api.nvim_get_current_buf()

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, nil)
  local visual_selection = get_visual_selection()
  print(vim.inspect(visual_selection), #visual_selection)
  if #visual_selection > 0 then
    lines = visual_selection
  end

  local win_info = ui.open_window()

  local cmd = ""
  for _, line in pairs(lines) do
    cmd = cmd .. "\n" .. line
  end

  vim.api.nvim_buf_set_lines(win_info.bufnr, -1, -1, false, lines)

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = output_to_buf(win_info.bufnr),
    on_stderr = output_to_buf(win_info.bufnr),
    on_exit = function(_, _)
      vim.api.nvim_buf_set_lines(win_info.bufnr, -1, -1, false, {
        "Done!",
      })
    end
  })
end

return M

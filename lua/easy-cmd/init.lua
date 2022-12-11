local buf = require('easy-cmd.buf')
local ui = require('easy-cmd.ui')
local fs = require('easy-cmd.fs')

M = {
  path = "~/.scripts/"
}

M.setup = function()
  fs.setup_folder(M.path)
  buf.setup_syntax(M.path)
end

M.run = function()
  local bufnr = vim.api.nvim_get_current_buf()

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, nil)
  local visual_selection = Get_visual_selection()
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
    on_stdout = Output_to_buf(win_info.bufnr),
    on_stderr = Output_to_buf(win_info.bufnr),
    on_exit = function(_, _)
      vim.api.nvim_buf_set_lines(win_info.bufnr, -1, -1, false, {
        "Done!",
      })
    end
  })
end

M.new_script = function()
  local name = vim.fn.input("File name: ")
  if name == "" then
    name = "scratch"
  end
  fs.open_or_create_file(name)
end

M.list_scripts = function()
  return fs.list_files()
end

return M

local buf = require('scrips.buf')
local ui = require('scrips.ui')
local fs = require('scrips.fs')

local Job = require('plenary.job')
local a = require('plenary.async')
local ns_id = vim.api.nvim_create_namespace("")

M = {
  path = "~/.scripts/",
  loading_symbol = "→",
}

local function run(shebang, lines)
  local win_info = ui.open_window()

  local cmd = table.concat(lines, "\n")

  if shebang == "" then
    shebang = "/bin/bash"
  end

  local start_time = os.clock()

  local mark_id = nil
  vim.api.nvim_buf_set_lines(win_info.bufnr, 0, 2, false, {
    "running...",
    "",
  })
  mark_id = vim.api.nvim_buf_set_extmark(win_info.bufnr, ns_id, 0, 0, {
    hl_group = "ScripsHighlight",
    sign_text = M.loading_symbol,
    sign_hl_group = "ScripsSign",
  })

  Job:new({
    command = shebang,
    args = { '-c', cmd },
    on_stdout = vim.schedule_wrap(Output_to_buf(win_info.bufnr)),
    on_stderr = vim.schedule_wrap(Output_to_buf(win_info.bufnr)),
    on_exit = vim.schedule_wrap(function(j, _)
      vim.api.nvim_buf_set_lines(win_info.bufnr, -1, -1, false, {
        "",
        "exited with status " .. j.code,
        string.format("elapsed time: %.2fs", os.clock() - start_time),
      })

      vim.api.nvim_buf_set_lines(win_info.bufnr, 0, 2, false, {
        "done!",
        "",
      })
      if mark_id ~= nil then
        vim.api.nvim_buf_del_extmark(win_info.bufnr, ns_id, mark_id)
      end
    end)
  }):start()
end

M.setup = function()
  fs.setup_folder(M.path)
  buf.setup_syntax(M.path)
end

M.run_paragraph = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local shebang = Get_shebang(bufnr)
  local lines = Get_current_paragraph(bufnr)

  run(shebang, lines)
end

M.run_file = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local shebang = Get_shebang(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, nil)

  run(shebang, lines)
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

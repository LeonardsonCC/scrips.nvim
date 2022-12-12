local M = {
  win_id = nil,
  bufnr = nil,
  num = 0,
}

local function create_window()
  local bufnr = vim.api.nvim_create_buf(true, true)

  -- TODO refactor this using lua
  vim.cmd("set splitright")
  vim.cmd("vert sb" .. bufnr)
  local win_id = vim.api.nvim_get_current_win()

  return {
    bufnr = bufnr,
    win_id = win_id,
  }
end

local function close_menu()
  vim.api.nvim_win_close(M.win_id, true)

  M.win_id = nil
  M.bufnr = nil
end

function M.open_window()
  if M.win_id ~= nil and vim.api.nvim_win_is_valid(M.win_id) then
    vim.api.nvim_buf_set_lines(M.bufnr, -1, -1, false, {
      "",
      "",
      "running another command",
      "",
    })
    return {
      win_id = M.win_id,
      bufnr = M.bufnr,
    }
  end

  local win_info = create_window()

  M.win_id = win_info.win_id
  M.bufnr = win_info.bufnr

  M.num = M.num + 1
  vim.api.nvim_buf_set_name(M.bufnr, "Scrips-" .. M.num)

  vim.api.nvim_win_set_option(M.win_id, "number", true)
  vim.api.nvim_buf_set_option(M.bufnr, "filetype", "Scrips")
  vim.api.nvim_buf_set_keymap(
    M.bufnr,
    "n",
    "q",
    "<CMD>lua require('scrips.ui').close_window()<CR>",
    { silent = true }
  )
  vim.api.nvim_buf_set_keymap(
    M.bufnr,
    "n",
    "<ESC>",
    "<CMD>lua require('scrips.ui').close_window()<CR>",
    { silent = true }
  )

  return {
    win_id = M.win_id,
    bufnr = M.bufnr,
  }
end

function M.close_window()
  if M.win_id ~= nil and vim.api.nvim_win_is_valid(M.win_id) then
    close_menu()
  end
end

return M

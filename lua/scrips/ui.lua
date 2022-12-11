local popup = require("plenary.popup")

local M = {
  win_id = nil,
  bufnr = nil,
  num = 0,
}

local function create_window()
  local width = 100
  local height = 30
  local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

  local bufnr = vim.api.nvim_create_buf(true, true)

  local win_id, win = popup.create(bufnr, {
    title = "EasyCmd",
    highlight = "EasyCmdWindow",
    line = math.floor(((vim.o.lines - height) / 2) - 1),
    col = math.floor((vim.o.columns - width) / 2),
    minwidth = width,
    minheight = height,
    borderchars = borderchars,
  })

  vim.api.nvim_win_set_option(
    win.border.win_id,
    "winhl",
    "Normal:EasyCmdBorder"
  )

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
    return {
      win_id = M.win_id,
      bufnr = M.bufnr,
    }
  end

  local win_info = create_window()

  M.win_id = win_info.win_id
  M.bufnr = win_info.bufnr

  M.num = M.num + 1
  vim.api.nvim_buf_set_name(M.bufnr, "EasyCmd-" .. M.num)

  vim.api.nvim_win_set_option(M.win_id, "number", true)
  vim.api.nvim_buf_set_option(M.bufnr, "filetype", "easycmd")
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

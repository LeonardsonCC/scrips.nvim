local function setup_syntax(path)
  local easy_cmd_augroup = vim.api.nvim_create_augroup("EasyCmdGroup", { clear = true })
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    command = "set syntax=sh",
    pattern = vim.fn.expand(path) .. "*",
    group = easy_cmd_augroup,
  })
end

function Output_to_buf(bufnr)
  return function(_, data)
    if data then
      vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
    end
  end
end

function Get_visual_selection()
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

function Get_current_paragraph(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, nil)
  local curr_line = vim.api.nvim_win_get_cursor(0)[1]

  local paragraph = {}
  local paragraph_start = 0
  -- goes back
  for idx = curr_line - 1, 0, -1 do
    local line = lines[idx]
    if line == '' then
      paragraph_start = idx
      break
    end
  end

  -- and forth
  for idx = paragraph_start + 1, #lines, 1 do
    local line = lines[idx]
    if line == '' then
      break
    end
    table.insert(paragraph, line)
  end

  return paragraph
end

function Reverse_table(x)
  local rev = {}
  for i = #x, 1, -1 do
    rev[#rev + 1] = x[i]
  end
  x = rev
end

return {
  setup_syntax = setup_syntax,
}

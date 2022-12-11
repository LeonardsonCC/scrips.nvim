local has_easy_cmd, easy_cmd = pcall(require, 'cshell')
if not has_easy_cmd then
  error('This plugin requires LeonardsonCC/cshell')
end

local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local previewers = require('telescope.previewers')
local sorters = require('telescope.sorters')
local conf = require("telescope.config").values

return function(opts)
  opts = opts or {}

  local file_list = easy_cmd.list_scripts()
  local items = {}

  if file_list ~= nil then
    for idx = 1, #file_list do
      local file = file_list[idx]
      if file ~= nil then
        table.insert(items, file)
      end
    end
  end

  opts.finder = finders.new_table({
    results = items,
    entry_maker = function(entry)
      return {
        value = entry.filepath,
        ordinal = entry.filepath,
        display = function()
          return entry.name
        end,
      }
    end
  })
  pickers.new(opts, {
    results_title = 'Find Script',
    sorter = conf.generic_sorter(opts),
    previewer = conf.grep_previewer(opts),
  }):find()
end

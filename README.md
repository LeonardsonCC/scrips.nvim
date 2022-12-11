# Scrips
A plugin that just runs the current file or selection in shell.

Also creates a folder to easily create and open scripts

## Install
Using Packer
```lua
use {
    "LeonardsonCC/scrips.nvim",
    requires = "nvim-lua/plenary.nvim"
}
```

Setup plugin
```lua
require('scrips').setup()
```

Setup the Telescope extensions
```lua
require('telescope').load_extension('scrips')
```

## Keymaps
You must set your own keymaps. This is what I personally use:
```lua
-- scrips
local scrips = require('scrips')
vim.keymap.set('n', '<Leader>en', scrips.new_script, { noremap = true })
vim.keymap.set('n', '<Leader>se', require('telescope').extensions.scrips.find_file, { noremap = true })

-- Idk why, but the visual selection only works this way atm
vim.keymap.set('v', '<Leader>en', ':lua require("scrips").run()<CR>', { noremap = true })
```

## Next steps
- [X] Run selection
- [X] Folder to manage scripts in plugin
- [X] Telescope to find scripts managed by the plugin
- [ ] Better buffer names

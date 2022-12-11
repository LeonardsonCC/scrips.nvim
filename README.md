# EasyCmd
A plugin that just run the current file to the shell and shows the output in a popup

## Install
Using Packer
```lua
use {
    "LeonardsonCC/easy-cmd.nvim",
    requires = "nvim-lua/plenary.nvim"
}
```

Setup plugin
```lua
require('easy-cmd').setup()
```

Setup the Telescope extensions
```lua
require('telescope').load_extension('easy_cmd')
```

## Keymaps
You must set your own keymaps. This is what I personally use:
```lua
-- Easy Cmd
local ec = require('easy-cmd')
vim.keymap.set('n', '<Leader>en', ec.new_script, { noremap = true })
vim.keymap.set('n', '<Leader>se', require('telescope').extensions.easy_cmd.find_file, { noremap = true })

-- Idk why, but the visual selection only works this way atm
vim.keymap.set('v', '<Leader>en', ':lua require("easy-cmd").run()<CR>', { noremap = true })
```

## Next steps
- [X] Run selection
- [X] Folder to manage scripts in plugin
- [X] Telescope to find scripts managed by the plugin
- [ ] Better buffer names

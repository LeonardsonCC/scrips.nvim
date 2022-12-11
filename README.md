# scrips.nvim
Yep, this is just scrips without the `t`. I know, it's dumb.

## What this plugin can do for me?
At the moment, it'll help you to manage scripts.
- Create a folder to store scripts;
- Create scripts;
- Run the script file;
- Run selection;
- Telescope your script;

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

Setup the Telescope extension
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

## What I pretend to do
- [X] Run selection
- [X] Folder to manage scripts in plugin
- [X] Telescope to find scripts managed by the plugin
- [ ] Better buffer names
- [ ] Run the file based on his header e.g. `#! /bin/bash`
- [ ] Run paragraph
- [ ] Subfolders to help manage the scripts

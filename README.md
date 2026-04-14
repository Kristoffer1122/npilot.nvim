# npilot.nvim 
This plugin is my solution to the problem of using GitHub Copilot in Neovim. 
It's meant to be more of a convenient way to use Copilot. It allows you to quickly accept or reject suggestions without using the ugly inline suggestions.

## Usage
To use npilot, obviously you will need a GitHub Copilot subscription, and have it configured.

### Configuration
You can configure the model to use by setting the `model` option in the setup function (Defaults to gpt-4.1). Any model supported by GitHub Copilot Chat can be used (e.g., `gpt-4o`, `claude-sonnet-4`, `gpt-4.1`, etc.).

### Keybindings
The default keybindings are as follows:
- `<leader>np` - prompts your selection in the chat and opens the chat window, then press y/n to accept/reject the suggestion.


## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

npilot.nvim
```lua
return {
  'Kristoffer1122/npilot.nvim',
  dependencies = {
    'CopilotC-Nvim/CopilotChat.nvim',
    'github/copilot.vim',
  },
  config = function()
    require('npilot').setup {
      model = 'gpt-4.1',
    }
  end,
}
```

CopilotChat.nvim
```lua
return {
  'CopilotC-Nvim/CopilotChat.nvim',
  dependencies = {
    'github/copilot.vim',
    'nvim-lua/plenary.nvim',
  },
  opts = {},
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

npilot.nvim
```lua
use {
    "Kristoffer1122/npilot.nvim",
    requires = {
        "CopilotC-Nvim/CopilotChat.nvim",
        "github/copilot.vim",
    },
    config = function()
        require("npilot").setup {
            model = "gpt-4.1",
        }
    end,
}
```

CopilotChat.nvim
```lua
use {
  'CopilotC-Nvim/CopilotChat.nvim',
  dependencies = {
    'github/copilot.vim',
    'nvim-lua/plenary.nvim',
  },
  opts = {},
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

npilot.nvim
```vim
Plug 'github/copilot.vim'
Plug 'CopilotC-Nvim/CopilotChat.nvim'
Plug 'Kristoffer1122/npilot.nvim'

" After plug#end():
lua require("npilot").setup {
    model = "gpt-4.1",
}
```

CopilotChat.nvim
```vim
" CopilotChat.nvim
Plug 'github/copilot.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'CopilotC-Nvim/CopilotChat.nvim'

" After plug#end():
lua require("copilot-chat").setup {}
```

### [mini.deps](https://github.com/echasnovski/mini.deps)

npilot.nvim
```lua
MiniDeps.add({
    source = "Kristoffer1122/npilot.nvim",
    depends = {
        "CopilotC-Nvim/CopilotChat.nvim",
        "github/copilot.vim",
    },
})
require("npilot").setup {
    model = "gpt-4.1",
}
```

CopilotChat.nvim
```lua
MiniDeps.add({
    source = "CopilotC-Nvim/CopilotChat.nvim",
    depends = {
        "github/copilot.vim",
        "nvim-lua/plenary.nvim",
    },
})
require("copilot-chat").setup {}
```

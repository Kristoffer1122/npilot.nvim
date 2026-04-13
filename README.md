# npilot.nvim 
This plugin is my solution to the problem of using GitHub Copilot in Neovim. 
It's meant to be more of a convinient way to use Copilot. It allows you to quickly accept or reject suggestions without to use the ugly inline suggestions.

## Usage
To use npilot, obviously you will need a github copilot subscription, and have it configured.
The default keybindings are as follows:
- `<leader>np` - prompts your selection in the chat and opens the chat window, then press y/n to accept/reject the suggestion.

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "Kristoffer1122/npilot.nvim",
    dependencies = {
        "CopilotC-Nvim/CopilotChat.nvim",
        "github/copilot.vim",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("npilot")
    end,
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
    "Kristoffer1122/npilot.nvim",
    requires = {
        "CopilotC-Nvim/CopilotChat.nvim",
        "github/copilot.vim",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("npilot")
    end,
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'nvim-lua/plenary.nvim'
Plug 'github/copilot.vim'
Plug 'CopilotC-Nvim/CopilotChat.nvim'
Plug 'Kristoffer1122/npilot.nvim'

" After plug#end():
lua require("npilot")
```

### [mini.deps](https://github.com/echasnovski/mini.deps)

```lua
MiniDeps.add({
    source = "Kristoffer1122/npilot.nvim",
    depends = {
        "CopilotC-Nvim/CopilotChat.nvim",
        "github/copilot.vim",
        "nvim-lua/plenary.nvim",
    },
})
require("npilot")
```

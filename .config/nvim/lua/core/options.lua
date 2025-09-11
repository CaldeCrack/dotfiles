vim.cmd("let g:netrw_liststyle = 3")
vim.cmd("let g:python_recommended_style = 0")

local opt = vim.opt

-- numbering
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smarttab = true
opt.si = true
opt.linebreak = true

-- search settings
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true

-- backspace
opt.backspace = "indent,eol,start"
opt.whichwrap:append("<>hl")

-- clipboard
opt.clipboard:append("unnamedplus")

-- turn off swapfile
opt.swapfile = false

vim.g.mapleader = " "

require("core")
require("lazy").setup({
	{ import = "plugins" },
	{ import = "plugins.lsp" },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "nvim-tree/nvim-web-devicons", opts = {} },
	{ "echasnovski/mini.nvim", version = "*" },
}, {
	rocks = { hererocks = true },
})
require("nvim-treesitter.configs").setup({
	indent = { enable = true },
})
require("lualine").setup({
	options = { theme = "auto" },
})
require("toggleterm").setup({
	open_mapping = [[<c-7>]],
})
require("bufferline").setup({
	options = { diagnostics = "nvim_lsp", numbers = "ordinal" },
})

vim.cmd.highlight("CursorLineNr guifg=#EB6F92")
local lastplace = vim.api.nvim_create_augroup("LastPlace", {})
vim.api.nvim_clear_autocmds({ group = lastplace })
vim.api.nvim_create_autocmd("BufReadPost", {
	group = lastplace,
	pattern = { "*" },
	desc = "remember last cursor place",
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

require("core")
require("lazy").setup({
	{ import = "plugins" },
	{ import = "plugins.lsp" },
	{ "nvim-treesitter/nvim-treesitter", branch = "main", lazy = false, build = ":TSUpdate" },
	{ "nvim-tree/nvim-web-devicons", opts = {} },
	{ "echasnovski/mini.nvim", version = "*" },
}, {
	rocks = { hererocks = true },
})
require("lualine").setup({
	options = { theme = "base16" },
})
require("toggleterm").setup({
	open_mapping = [[<c-7>]],
})
require("bufferline").setup({
	options = { diagnostics = "nvim_lsp", numbers = "ordinal" },
})
vim.lsp.config("qmlls", {
	cmd = { "/usr/lib/qt6/bin/qmlls" },
})
vim.lsp.enable("qmlls")

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

local function source_matugen()
	-- Update this with the location of your output file
	local matugen_path = os.getenv("HOME") .. "/.config/nvim/matugen.lua"

	local file, err = io.open(matugen_path, "r")
	-- If the matugen file does not exist (yet or at all), we must initialize a color scheme ourselves
	if err ~= nil then
		-- Some placeholder theme, this will be overwritten once matugen kicks in
		vim.cmd("colorscheme catppuccin")

		-- Optionally print something to the user
		vim.print(
			"A matugen style file was not found, but that's okay! The colorscheme will dynamically change if matugen runs!"
		)
	else
		dofile(matugen_path)
		io.close(file)
	end
end

-- Main entrypoint on matugen reloads
local function auxiliary_function()
	-- Load the matugen style file to get all the new colors
	source_matugen()

	-- Because reloading base16 overwrites lualine configuration, just source lualine here
	dofile(os.getenv("HOME") .. "/.config/nvim/lua/plugins/lualine.lua")

	-- Any other options you wish to set upon matugen reloads can also go here!
	vim.api.nvim_set_hl(0, "Comment", { italic = true })
end

-- Register an autocmd to listen for matugen updates
vim.api.nvim_create_autocmd("Signal", {
	pattern = "SIGUSR1",
	callback = auxiliary_function,
})

-- Additionally call this function once on startup to query for matugen's theme
-- or set a default
auxiliary_function()

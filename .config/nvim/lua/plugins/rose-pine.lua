-- lua/plugins/rose-pine.lua
return {
	"rose-pine/neovim",
	priority = 1000,
	name = "rose-pine",
	config = function()
		vim.cmd("colorscheme rose-pine")
	end
}

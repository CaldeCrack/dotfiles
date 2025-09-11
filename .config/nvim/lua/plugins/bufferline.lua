return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",

	config = function()
		local keymap = vim.keymap

		keymap.set("n", "<Tab>", "<Cmd>BufferLineCycleNext<CR>", {})
		keymap.set("n", "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", {})
		for i = 1, 9 do
			vim.keymap.set("n", "<leader>" .. i, "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>", {})
		end
		keymap.set("n", "<leader>q", ":bp | bd #<CR>", {})
	end,
}

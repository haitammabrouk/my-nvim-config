return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		local autopairs = require("nvim-autopairs")
		autopairs.setup({
			check_ts = true, -- Enable treesitter
			ts_config = {
				lua = { "string" }, -- Don't add pairs in lua string treesitter nodes
				javascript = { "template_string" },
				java = false, -- Don't check treesitter on java
			},
			disable_filetype = { "TelescopePrompt", "vim" },
			fast_wrap = {
				map = "<M-e>", -- Alt+e to fast wrap
				chars = { "{", "[", "(", '"', "'" },
				pattern = [=[[%'%"%>%]%)%}%,]]=],
				end_key = "$",
				keys = "qwertyuiopzxcvbnmasdfghjkl",
				check_comma = true,
				highlight = "Search",
				highlight_grey = "Comment",
			},
		})

		-- Integration with nvim-cmp (if you use it)
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp_status_ok, cmp = pcall(require, "cmp")
		if cmp_status_ok then
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end
	end,
}

local jdtls = require("jdtls")

-- Get Java home from SDKMAN
local java_home = vim.fn.expand("~/.sdkman/candidates/java/current")
local home = os.getenv("HOME")

-- Function to set up keymaps when LSP attaches
local function on_attach(client, bufnr)
	local opts = { buffer = bufnr, noremap = true, silent = true }

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
end

-- Get capabilities from nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_lsp_ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_lsp_ok then
	capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- Workspace directory
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

local config = {
	cmd = {
		java_home .. "/bin/java", -- Explicitly use Java 21
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar",
		"-jar",
		vim.fn.glob(
			vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
		),
		"-configuration",
		vim.fn.expand("~/.local/share/nvim/mason/packages/jdtls/config_linux"),
		"-data",
		workspace_dir,
	},

	root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),

	on_attach = on_attach,
	capabilities = capabilities,

	settings = {
		java = {
			home = java_home,
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
		},
	},

	init_options = {
		bundles = {},
	},
}

jdtls.start_or_attach(config)

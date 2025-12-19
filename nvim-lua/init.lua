require("config.lazy")

vim.cmd[[colorscheme tokyonight]]

require('lualine').setup({
    options = {
        theme = 'auto',
    },
    sections = {
        lualine_x = {
            "encoding", "fileformat", "filetype",
            {
            'lsp_status',
            icon = '', -- f013
            symbols = {
                spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                done = '✓',
                separator = ' ',
            },
            ignore_lsp = {},
            }
        }
    }
})

vim.lsp.config("clangd", {
    cmd = { "clangd", "--background-index" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_dir = require("lspconfig").util.root_pattern("compile_commands.json", "compile_flags.txt", ".git", ".clangd", ".clang-format", ".clang-tidy"),
})
vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy"
            }
        }
    }
})
vim.lsp.config("pyright", {
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true
            }
        }
    }
})

vim.wo.number = true
vim.wo.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.encoding = "utf-8"
vim.opt.termguicolors = true

vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>f", "<cmd>Files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>b", "<cmd>Buffers<CR>", { noremap = true, silent = true })


vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function(args)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format {async = false, id = args.data.client_id }
      end,
    })
  end
})

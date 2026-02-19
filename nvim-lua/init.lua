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

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "objc", "objcpp" },
    callback = function(ev)
        local fname = vim.api.nvim_buf_get_name(ev.buf)
        if fname == "" then return end

        local cmd = { "clangd", "--background-index" }
        local root = nil

        -- Walk upward from the file looking for a directory that contains a
        -- build-* or cmake-build-* subdirectory with compile_commands.json.
        -- That directory is the strongest project root indicator and also tells
        -- us where to point --compile-commands-dir.
        local dir = vim.fn.fnamemodify(fname, ":h")
        while dir and dir ~= "/" do
            for name, ftype in vim.fs.dir(dir) do
                if (ftype == "directory" or ftype == "link") and (
                    name == "build" or
                    name:match("^build%-") or
                    name:match("^cmake%-build")
                ) then
                    if vim.uv.fs_stat(dir .. "/" .. name .. "/compile_commands.json") then
                        root = dir
                        table.insert(cmd, "--compile-commands-dir=" .. dir .. "/" .. name)
                        break
                    end
                end
            end
            if root then break end
            local parent = vim.fn.fnamemodify(dir, ":h")
            if parent == dir then break end
            dir = parent
        end

        -- Fall back to .git / .clangd root when no build directory was found
        if not root then
            root = vim.fs.root(fname, { ".git", ".clangd" })
                or vim.fn.fnamemodify(fname, ":h")
        end

        vim.lsp.start({
            name = "clangd",
            cmd = cmd,
            root_dir = root,
            capabilities = vim.tbl_deep_extend("force",
                vim.lsp.protocol.make_client_capabilities(),
                {
                    offsetEncoding = { "utf-8", "utf-16" },
                    textDocument = { completion = { editsNearCursor = true } },
                }
            ),
            on_init = function(client, result)
                if result.offsetEncoding then
                    client.offset_encoding = result.offsetEncoding
                end
            end,
        })
    end,
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

vim.lsp.enable({ "rust_analyzer", "pyright" })

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

require('overseer').setup()

return {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {"nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons"},
    init = function()
        require('aerial').setup({
            on_attach = function(bufnr)
                -- Optional keymaps
                vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", {
                    buffer = bufnr
                })
                vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", {
                    buffer = bufnr
                })
            end
        })

        vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
    end
}

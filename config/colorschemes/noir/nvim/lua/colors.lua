return {
    'dzfrias/noir.nvim',
    config = function()
        vim.cmd.colorscheme "noir"
        vim.opt.background = "dark"
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
}

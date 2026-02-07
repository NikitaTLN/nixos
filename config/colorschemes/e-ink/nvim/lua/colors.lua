return {
      vim.cmd.colorscheme "e-ink"
      vim.opt.background = "light"
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
}

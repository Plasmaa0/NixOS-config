return {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    priority = 1000,
    config = function()
-- asndansldnalnds 123
      require("monokai-pro").setup()
      vim.cmd([[MonokaiPro spectrum]])
    end
}

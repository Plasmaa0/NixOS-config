local map = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

map('n', '<C-s>', ':w <CR>', default_opts)
map('n', '<C-w> Q', ':bd <CR>', default_opts)

map('', '<up>', ':echoe "Use hjkl, bro"<CR>', { noremap = true, silent = false })
map('', '<down>', ':echoe "Use hjkl, bro"<CR>', { noremap = true, silent = false })
map('', '<left>', ':echoe "Use hjkl, bro"<CR>', { noremap = true, silent = false })
map('', '<right>', ':echoe "Use hjkl, bro"<CR>', { noremap = true, silent = false })

map('n', '<leader>f', "<cmd>Telescope find_files<cr>", default_opts)
map('n', '<leader>b', "<cmd>Telescope buffers<cr>", default_opts)
map('n', '<leader>S', "<cmd>Telescope live_grep<cr>", default_opts)
map('n', '<leader>s', "<cmd>Telescope lsp_workspace_symbols<cr>", default_opts)
map('n', '<leader>d', "<cmd>lua require('telescope.builtin').diagnostics()<cr>", default_opts)

map('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<cr>', default_opts)
map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', default_opts)
map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', default_opts)
map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', default_opts)
map('n', 'gi', "<cmd>lua require('telescope.builtin').lsp_implementations()<cr>", default_opts)
map('n', 'gr', "<cmd>lua require('telescope.builtin').lsp_references()<cr>", default_opts)

map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', default_opts)
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', default_opts)
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', default_opts)
map('n', '<leader>ee', '<cmd>NvimTreeToggle<cr>', default_opts)
map('n', '<leader>ef', '<cmd>NvimTreeFindFile<cr>', default_opts)
map('n', '<leader>eu', '<cmd>NvimTreeRefresh<cr>', default_opts)

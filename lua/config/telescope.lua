local keymap = vim.keymap
local builtin = require("telescope.builtin")
local default_opts = { noremap = true, silent = true }

-- shortcuts for telescope
-- keymap.set("n", "<leader>ff", builtin.find_files)
-- keymap.set("n", "<leader>fg", builtin.live_grep)
-- keymap.set("n", "<leader>fb", builtin.buffers)
-- keymap.set("n", "<leader>fh", builtin.help_tags)
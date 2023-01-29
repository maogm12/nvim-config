local keymap = vim.keymap

-- Map s to nop since s in used by vim-sandwich. Use cl instead of s.
keymap.set({"n", "o"}, "s", "<Nop>", { desc = "disable s, use cl instead" })
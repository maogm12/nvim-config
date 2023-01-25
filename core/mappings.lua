local keymap = vim.keymap
local api = vim.api
local uv = vim.loop
local default_opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, expr = true, silent = true }

-- Better escape using jk in insert and terminal mode
keymap.set("i", "kj", "<ESC>", default_opts)
keymap.set("t", "kj", "<C-\\><C-n>", default_opts)

-- Use <space> to search
keymap.set("", "<space>", "/")

-- Center search results
keymap.set("n", "n", "nzz", default_opts)
keymap.set("n", "N", "Nzz", default_opts)
keymap.set("n", "*", "*zz", default_opts)
keymap.set("n", "#", "#zz", default_opts)
keymap.set("n", "g*", "g*zz", default_opts)

-- Visual line wraps
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", expr_opts)
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", expr_opts)

--Shift-h/l to the line head/end
keymap.set("n", "<S-h>", "0", default_opts)
keymap.set("n", "<S-l>", "$", default_opts)

-- Ctrl-A/E to the line head/end in insert mode
keymap.set("i", "<C-A>", "<HOME>")
keymap.set("i", "<C-E>", "<END>")

-- Cancel search highlighting with ESC
keymap.set("n", "<ESC>", ":nohlsearch<Bar>:echo<CR>", default_opts)

-- Paste non-linewise text above or below current line, see https://stackoverflow.com/a/1346777/6064933
keymap.set("n", "<leader>p", "m`o<ESC>p``", { desc = "paste below current line" })
keymap.set("n", "<leader>P", "m`O<ESC>p``", { desc = "paste above current line" })

-- Shortcut for faster save and quit
keymap.set("n", "<leader>w", "<cmd>update<cr>", { silent = true, desc = "save buffer" })

-- Saves the file if modified and quit
keymap.set("n", "<leader>q", "<cmd>x<cr>", { silent = true, desc = "quit current window" })

-- Move the cursor based on physical lines, not the actual lines.
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", expr_opts)
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", expr_opts)
keymap.set("n", "^", "g^", default_opts)
keymap.set("n", "0", "g0", default_opts)

-- Do not include white space characters when using $ in visual mode,
-- see https://vi.stackexchange.com/q/12607/15292
keymap.set("x", "$", "g_")

-- Go to start or end of line easier
keymap.set({ "n", "x" }, "H", "g0", default_opts)
keymap.set({ "n", "x" }, "L", "g_", default_opts)

-- Continuous visual shifting (does not exit Visual mode), `gv` means
-- to reselect previous visual area, see https://superuser.com/q/310417/736190
keymap.set("x", "<", "<gv", default_opts)
keymap.set("x", ">", ">gv", default_opts)

-- Edit and reload nvim config file quickly
keymap.set("n", "<leader>ev", "<cmd>tabnew $MYVIMRC <bar> tcd %:h<cr>", {
  silent = true,
  desc = "open init.lua",
})

keymap.set("n", "<leader>sv", function()
  vim.cmd([[
      update $MYVIMRC
      source $MYVIMRC
    ]])
  vim.notify("Nvim config successfully reloaded!", vim.log.levels.INFO, { title = "nvim-config" })
end, {
  silent = true,
  desc = "reload init.lua",
})

-- Reselect the text that has just been pasted, see also https://stackoverflow.com/a/4317090/6064933.
keymap.set("n", "<leader>v", "printf('`[%s`]', getregtype()[0])", {
  expr = true,
  desc = "reselect last pasted area",
})

-- Change current working directory locally and print cwd after that,
-- see https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
keymap.set("n", "<leader>cd", "<cmd>lcd %:p:h<cr><cmd>pwd<cr>", { desc = "change cwd" })

-- Use Esc to quit builtin terminal
keymap.set("t", "<Esc>", [[<c-\><c-n>]])

-- check the syntax group of current cursor position
keymap.set("n", "<leader>st", "<cmd>call utils#SynGroup()<cr>", { desc = "check syntax group" })

-- Copy entire buffer.
keymap.set("n", "<leader>y", "<cmd>%yank<cr>", { desc = "yank entire buffer" })

-- Toggle cursor column
keymap.set("n", "<leader>cl", "<cmd>call utils#ToggleCursorCol()<cr>", { desc = "toggle cursor column" })

-- Replace visual selection with text in register, but not contaminate the register,
-- see also https://stackoverflow.com/q/10723700/6064933.
keymap.set("x", "p", '"_c<Esc>p')

-- Shift-arrows to resize panes
keymap.set("", "<S-left>", ":vertical resize +2<CR>", default_opts)
keymap.set("", "<S-right>", ":vertical resize -2<CR>", default_opts)
keymap.set("", "<S-up>", ":resize -2<CR>", default_opts)
keymap.set("", "<S-down>", ":resize +2<CR>", default_opts)

-- Move between windows
keymap.set("", "<C-j>", "<C-w>j", default_opts)
keymap.set("", "<C-k>", "<C-w>k", default_opts)
keymap.set("", "<C-h>", "<C-w>h", default_opts)
keymap.set("", "<C-l>", "<C-w>l", default_opts)

-- Do not move my cursor when joining lines.
keymap.set("n", "J", function()
  vim.cmd([[
      normal! mzJ`z
      delmarks z
    ]])
end, {
  desc = "join line",
})

keymap.set("n", "gJ", function()
  -- we must use `normal!`, otherwise it will trigger recursive mapping
  vim.cmd([[
      normal! zmgJ`z
      delmarks z
    ]])
end, {
  desc = "join visual lines",
})

-- Break inserted text into smaller undo units when we insert some punctuation chars.
local undo_ch = { ",", ".", "!", "?", ";", ":" }
for _, ch in ipairs(undo_ch) do
  keymap.set("i", ch, ch .. "<c-g>u")
end

-- Keep cursor position after yanking
keymap.set("n", "y", "myy")

api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  group = api.nvim_create_augroup("restore_after_yank", { clear = true }),
  callback = function()
    vim.cmd([[
      silent! normal! `y
      silent! delmarks y
    ]])
  end,
})

-- F1 for command
keymap.set("", "<F1>", ":")

-- Save some keystrokes
keymap.set("", ";", ":")

-- Ctrl-j/k to look command history
keymap.set("c", "<C-j>", "<Home>", default_opts)
keymap.set("c", "<C-k>", "<End>", default_opts)

-- Ctrl-a/e to line head/end
keymap.set("c", "<C-a>", "<Home>", default_opts)
keymap.set("c", "<C-e>", "<End>", default_opts)

-- Delete the character to the right of the cursor
keymap.set("i", "<C-D>", "<DEL>")

-- Flash cursorline and cursorcolumn
keymap.set("n", "<leader>cb", function()
  local cnt = 0
  local blink_times = 7
  local timer = uv.new_timer()

  timer:start(0, 100, vim.schedule_wrap(function()
    vim.cmd[[
      set cursorcolumn!
      set cursorline!
    ]]

    if cnt == blink_times then
      timer:close()
    end

    cnt = cnt + 1
  end))
end, {
  silent = true,
  desc = "find my cursor"
})

-------------------------------------------------------------------------------
--------------------------------{ Plugins }------------------------------------
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--------------------{ vim-strip-trailing-whitespace }--------------------------
-------------------------------------------------------------------------------
-- Remove trailing whitespace characters
keymap.set("n", "<leader><space>", "<cmd>StripTrailingWhitespace<cr>", { desc = "remove trailing space" })

-------------------------------------------------------------------------------
-------------------------------{ Telescope }-----------------------------------
-------------------------------------------------------------------------------
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { silent = true, desc = "telescope find files" })
keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { silent = true, desc = "telescope live grep" })
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { silent = true, desc = "telescope find buffers" })
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { silent = true, desc = "telescope find help tags" })
keymap.set("n", "<leader>fr", "<cmd>Telescope frecency<cr>", { silent = true, desc = "telescope recent files" })

-------------------------------------------------------------------------------
---------------------------{ Floating terminal }-------------------------------
-------------------------------------------------------------------------------
keymap.set("n", "<leader>`", "<cmd>FloatermToggle<cr>", { silent = true, desc = "toggle float terminal" })
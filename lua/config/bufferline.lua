local keymap = vim.keymap

require('bufferline').setup {
  options = {
    mode = "buffers", -- show buffer
    numbers = "ordinal", -- show ordinal numbers for buffers
    close_command = function(bufnum) -- delete the buffer
      require('bufdelete').bufdelete(bufnum, true)
    end,
    right_mouse_command = function(bufnum) -- delete the buffer
      require('bufdelete').bufdelete(bufnum, true)
    end,
    left_mouse_command = "buffer %d", -- left click to choose the buffer
    middle_mouse_command = nil, -- not handling middle mouse click
    indicator = {
      style = 'underline'
    },
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = "",
    right_trunc_marker = "",
    --- name_formatter can be used to change the buffer's label in the bufferline.
    name_formatter = function(buf) -- buf contains a "name", "path" and "bufnr"
      -- remove extension from markdown files for example
      if buf.name:match('%.md') then
        return vim.fn.fnamemodify(buf.name, ':t:r')
      end
    end,
    max_name_length = 18,
    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
    tab_size = 18,
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        local sym = e == "error" and " "
        or (e == "warning" and " " or "")
        s = s .. sym
      end
      return s
    end,
    -- NOTE: this will be called a lot so don't do any heavy processing here
    custom_filter = function(buf_number, buf_numbers)
      -- filter out filetypes you don't want to see
      if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
        return true
      end
      -- filter out by buffer name
      if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
        return true
      end
      -- filter out based on arbitrary rules
      -- e.g. filter out vim wiki buffer from tabline in your work repo
      if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
        return true
      end
      -- filter out by it's index number in list (don't show first buffer)
      if buf_numbers[1] ~= buf_number then
        return true
      end
    end,
    offsets = { { filetype = "bufferlist", text = "Explorer", text_align = "center" } },
    color_icons = true,
    show_buffer_icons = true, -- disable filetype icons for buffers
    show_buffer_close_icons = true,
    show_buffer_default_icon = true, -- default icon
    show_close_icon = true,
    show_tab_indicators = true,
    persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
    -- can also be a table containing 2 custom separators
    -- [focused and unfocused]. eg: { '|', '|' }
    separator_style = "thin",
    enforce_regular_tabs = false,
    always_show_bufferline = true,
    sort_by = 'id'
  }
}

-- go to left/right
keymap.set("n", "<right>", '<cmd>BufferLineCycleNext<cr>', { desc = 'go to next buffer' })
keymap.set("n", "<left>", '<cmd>BufferLineCyclePrev<cr>', { desc = 'go to previous buffer' })

-- fast way to navigate to a specific buffer in normal mode
keymap.set("n", "<leader>1", "<cmd>lua require('bufferline').go_to_buffer(1, true)<cr>", { desc = 'go to buffer 1' })
keymap.set("n", "<leader>2", "<cmd>lua require('bufferline').go_to_buffer(2, true)<cr>", { desc = 'go to buffer 2' })
keymap.set("n", "<leader>3", "<cmd>lua require('bufferline').go_to_buffer(3, true)<cr>", { desc = 'go to buffer 3' })
keymap.set("n", "<leader>4", "<cmd>lua require('bufferline').go_to_buffer(4, true)<cr>", { desc = 'go to buffer 4' })
keymap.set("n", "<leader>5", "<cmd>lua require('bufferline').go_to_buffer(5, true)<cr>", { desc = 'go to buffer 5' })
keymap.set("n", "<leader>6", "<cmd>lua require('bufferline').go_to_buffer(6, true)<cr>", { desc = 'go to buffer 6' })
keymap.set("n", "<leader>7", "<cmd>lua require('bufferline').go_to_buffer(7, true)<cr>", { desc = 'go to buffer 7' })
keymap.set("n", "<leader>8", "<cmd>lua require('bufferline').go_to_buffer(8, true)<cr>", { desc = 'go to buffer 8' })
keymap.set("n", "<leader>9", "<cmd>lua require('bufferline').go_to_buffer(9, true)<cr>", { desc = 'go to buffer 9' })

-- '\x' to close other buffers
keymap.set("n", [[\x]], function()
  vim.cmd([[
    BufferLineCloseRight
    BufferLineCloseLeft
  ]])
end, { 
  silent = true,
  desc = "close other buffers"
})
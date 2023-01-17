local keymap = vim.keymap

keymap.set("n", "<c-P>", function()
  require('fzf-lua').fzf_exec("rg --files", {
    preview = "bat --style=numbers --color=always --line-range :500 {}",
    fzf_opts = { ['--preview-window'] = 'nohidden,down,50%' },
  })
end, {
  silent = true,
  desc = "Fuzzy finding files"
})

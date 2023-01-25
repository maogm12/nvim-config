local wilder = require('wilder')

wilder.setup({modes = {':', '/', '?'}})

wilder.set_option('pipeline',{
    wilder.branch(
        wilder.cmdline_pipeline({
            language = 'python',
            fuzzy = 1,
            sorter = wilder.python_difflib_sorter(),
            debounce = 30
        }),
        wilder.python_search_pipeline({
            pattern = wilder.python_fuzzy_pattern(),
            sorter = wilder.python_difflib_sorter(),
            engine = 're',
            debounce = 30
        }
    ))
})

wilder.set_option('renderer', wilder.popupmenu_renderer(
  wilder.popupmenu_border_theme({
    border = 'rounded',
    highlighter = wilder.basic_highlighter(),
    highlights = {
        accent = wilder.make_hl('WilderAccent', 'Pmenu', {{a = 1}, {a = 1}, {foreground = '#d19a66'}}),
        border = 'Normal', -- highlight to use for the border
    },
    max_height = 15,
    left = {' ', wilder.popupmenu_devicons()},
    right = {' ', wilder.popupmenu_scrollbar()},
    apply_incsearch_fix = 0
})))
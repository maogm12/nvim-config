local auto_dark_mode = require('auto-dark-mode')
local onedark = require('onedark')

auto_dark_mode.setup({
	update_interval = 1000,
	set_dark_mode = function()
    onedark.setup {
        style = 'dark'
    }
    onedark.load()
    vim.o.background = 'dark'
	end,
	set_light_mode = function()
    onedark.setup {
        style = 'light'
    }
    onedark.load()
    vim.o.background = 'light'
	end,
})
auto_dark_mode.init()

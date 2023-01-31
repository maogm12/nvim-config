local dap = require("dap")

require ('mason-nvim-dap').setup({
  ensure_installed = {'stylua', 'python', 'codelldb'},
  automatic_installation = true,
  automatic_setup = true,
})

require 'mason-nvim-dap'.setup_handlers {
  function(source_name)
    -- all sources with no handler get passed here
    -- Keep original functionality of `automatic_setup = true`
    require('mason-nvim-dap.automatic_setup')(source_name)
  end
}

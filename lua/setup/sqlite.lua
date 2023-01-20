if 1 == vim.fn.executable "brew" then
  local Job = require("plenary.job")
  local sqlite_root, ret = Job:new({
    command = 'brew',
    args = { "--prefix", "sqlite" },
  }):sync()

  if ret == 0 then
    vim.g.sqlite_clib_path = sqlite_root[1] .. "/lib/libsqlite3.dylib"
  end
end
local default_system_sqlite_clib_path = "/usr/lib/libsqlite3.dylib"
local default_brew_sqlite_clib_path = "/opt/homebrew/opt/sqlite/lib/libsqlite3.dylib"

if vim.fn.filereadable(default_system_sqlite_clib_path) then
  -- default system sqlite3 lib
  vim.g.sqlite_clib_path = default_system_sqlite_clib_path
elseif vim.fn.filereadable(default_brew_sqlite_clib_path) then
  -- default brew installed sqlite3 lib
  vim.g.sqlite_clib_path = default_brew_sqlite_clib_path
elseif 1 == vim.fn.executable "brew" then
  -- query brew for the sqlite3 lib path
  local Job = require("plenary.job")
  local sqlite_root, ret = Job:new({
    command = 'brew',
    args = { "--prefix", "sqlite" },
  }):sync()

  if ret == 0 then
    vim.g.sqlite_clib_path = sqlite_root[1] .. "/lib/libsqlite3.dylib"
  end
end
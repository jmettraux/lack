
--
-- run me with
--
--   lua test_raw_2.lua
--

package.path = package.path .. ';lib/?.lua'

require 'luarocks.require'
require 'lack'

local app = {}
app.call = function (env)
  return { 200, {}, "tables or functions" }
end

lack.run('0.0.0.0', 8080, app)


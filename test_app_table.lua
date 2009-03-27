
--
-- app is a table with a 'call' key (pointing to a function(self, env))
--

package.path = package.path .. ';lib/?.lua'

require 'luarocks.require'
require 'lack'

local app = {}
app.call = function (self, env)
  return { 200, {}, "tables or functions" }
end

lack.run('0.0.0.0', 8080, app)


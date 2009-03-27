
--
-- app is a simple function
--

package.path = package.path .. ';lib/?.lua'

require 'luarocks.require'
require 'lack'

local app = function (env)

  lack.hprint(env)
  lack.hprint(env.headers)

  return { 200, {}, 'hey, whatever...' }
end

lack.run('0.0.0.0', 8080, app)


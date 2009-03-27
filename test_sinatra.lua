
--
-- app is a sinatra table
--

package.path = package.path .. ';lib/?.lua'

require 'luarocks.require'
require 'lack'
require 'lack.sinatra'

app = lack.sinatra.new()

app:get('/books', function (self, env)
  return "some books"
end)
app:get('/cars', function (self, env)
  return "your car and my car"
end)

lack.run('0.0.0.0', 8080, app)


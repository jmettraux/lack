--
-- Copyright (c) 2009, John Mettraux, jmettraux@gmail.com
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
-- Made in Japan.
--

module('lack.sinatra', package.seeall)

local Sinatra = {}

function Sinatra:new (t)

  t = t or {}

  t.gets = {}
  t.posts = {}
  t.puts = {}
  t.deletes = {}

  setmetatable(t, self) -- metatable is Sinatra
  self.__index = self

  return t
end

function Sinatra:get (pattern, func)

  self.gets[#self.gets + 1] = { pattern, func }
end

function Sinatra:__tostring ()

  local s = { '= a sinatra' }

  for i, v in ipairs({ 'get', 'post', 'put', 'delete' }) do
    s[#s + 1] = s .. '== ' .. v
    for ii, vv in ipairs(self[v]) do
      s[#s + 1] = "'" .. vv[1] .. "' --> " .. vv[2]
    end
  end

  return table.concat(s, "\n")
end

function Sinatra:call (env)

  local routes = self[env.request_method:lower() .. 's']

  for i, v in ipairs(routes) do
    if env.path:find(v[1]) then return v[2](self, env) end
  end

  return { 404, {}, 'not found' }
end


--
-- the public 'new' function

new = function (sinatra_table)

  return Sinatra:new(sinatra_table)
end


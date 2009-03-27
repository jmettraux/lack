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

module('lack', package.seeall)

require('copas') -- require('luarocks.require')


local ret_codes = {
  [200] = 'OK',
  [404] = 'not found',
  [500] = 'internal server error'
}

local format_response = function (ret)

  if type(ret) == 'string' then ret = { 200, {}, ret } end

  res = {} 
  res[#res + 1] = 'HTTP/1.1 ' .. ret[1] .. ' ' .. ret_codes[ret[1]]
 
  for k, v in pairs(ret[2]) do res[#res] = k .. ': ' .. v; end

  if ret[2]['Content-Type'] == nil then
    res[#res + 1] = 'Content-Type: text/plain'
  end

  res[#res + 1] = 'Content-Length: ' .. string.len(ret[3])
  res[#res + 1] = ''
  res[#res + 1] = ret[3]

  return table.concat(res, "\r\n")
end

local prepare_env = function (socket)

  local raw = {}

  while true do
    local line = copas.receive(socket, '*l')
    if line == '' or line == nil then break end
    raw[#raw + 1] = line
  end

  local method, full_path = raw[1]:match('^(.-) (.-) .-')
  local path, query_string = full_path:match('^(.-)?(.-)$')
  path = path or full_path

  -- TODO parse queries

  local headers = {}
  for i = 2, #raw do
    k, v = raw[i]:match('^(.-): (.-)$')
    headers[k] = v
  end

  -- TODO do something if there is 'Content-Length'

  return {
    ['raw'] = raw,
    ['full_path'] = full_path,
    ['path'] = path,
    ['request_method'] = method,
    ['query_string'] = query_string,
    ['headers'] = headers
  }
end

local make_handler = function (middleware)

  local mid = middleware
  if type(middleware) == 'function' then
    mid = { ['call'] = function(self, env) return middleware(env) end }
  end

  return function (socket)
    local env = prepare_env(socket)
    local ret = mid:call(env)
    copas.send(socket, format_response(ret))
  end
end

--
-- the 'run' method

-- TODO : allow to wire stuff into the loop

run = function (host, port, middleware)

  server = socket.bind(host, port)
  copas.addserver(server, make_handler(middleware))

  copas.loop()
end

--
-- debugging stuff

hprint = function (h)
  print "==h"
  for k, v in pairs(h) do print(k, v) end
end
aprint = function (a)
  print "==a"
  for i, v in ipairs(a) do print(i, v) end
end


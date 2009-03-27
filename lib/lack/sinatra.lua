
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


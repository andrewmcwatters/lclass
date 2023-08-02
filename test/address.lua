-- address.lua
-- simple memory location __tostring metamethod

require("class")

local getmetatable = getmetatable
local setmetatable = setmetatable
local tostring     = tostring
local string       = string
local print        = print

class("container")

function container:__tostring ()
  local t = getmetatable(self)
  setmetatable(self, {})
  local s = string.gsub(tostring(self), "table", "container")
  setmetatable(self, t)
  return s
end

local c = container()
print(c)

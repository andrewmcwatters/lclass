-- class.lua
-- defines C++ style classes using the same behavior as luaL_register
-- All classes are stored in the LUA_REGISTRYINDEX, support single
-- inheritance, metamethod inheritance, and implicit mixin support with
-- a user-defined table.merge.
-- distributed under the MIT license

local setmetatable = setmetatable
local package = package
local type = type
local error = error
local pcall = pcall
local unpack = unpack
local newproxy = newproxy
local gsub = string.gsub
local rawget = rawget
local ipairs = ipairs
local module = module
local _G = _G
local _R = debug.getregistry()

local function new( metatable )
  local object = {}
  setmetatable( object, metatable )
  return object
end

local function getbaseclass( metatable )
  local base = metatable.__base
  return package.loaded[ base ]
end

_G.getbaseclass = getbaseclass

local eventnames = {
  "__gc",
  "__add", "__sub", "__mul", "__div", "__mod",
  "__pow", "__unm", "__len", "__lt", "__le",
  "__concat", "__call",
  "__tostring"
}

local function metamethod( metatable, eventname )
  return function( ... )
    local event = nil
    local base = getbaseclass( metatable )
    while ( base ~= nil ) do
      if ( base[ eventname ] ) then
        event = base[ eventname ]
        break
      end
      base = getbaseclass( base )
    end
    local type = type( event )
    if ( type ~= "function" ) then
      error( "attempt to call metamethod '" .. eventname .. "' " ..
             "(a " .. type .. " value)", 2 )
    end
    local returns = { pcall( event, ... ) }
    if ( returns[ 1 ] ~= true ) then
      error( returns[ 2 ], 2 )
    else
      return unpack( returns, 2 )
    end
  end
end

local function setproxy( object )
  local __newproxy = newproxy( true )
  local metatable = getmetatable( __newproxy )
  metatable.__gc = function()
    object:__gc()
  end
  object.__newproxy = __newproxy
end

_G.setproxy = setproxy

local function classinit( module )
  module.__index = module
  module.__type = gsub( module._NAME, module._PACKAGE, "" )
  -- Override modinit from loadlib.c
  module._M = nil
  module._NAME = nil
  module._PACKAGE = nil
  -- Create a shortcut to name()
  setmetatable( module, {
    __call = function( self, ... )
      -- Create an instance of this object
      local object = new( self )
      -- Call its constructor (function name:name( ... ) ... end) if it
      -- exists
      local constructor = rawget( self, self.__type )
      if ( constructor ~= nil ) then
        local type = type( constructor )
        if ( type ~= "function" ) then
          error( "attempt to call constructor '" .. name .. "' " ..
                 "(a " .. type .. " value)", 2 )
        end
        constructor( object, ... )
      end
      -- Return the instance
      return object
    end
  } )
end

local function inherit( base )
  return function( metatable )
    -- Set our base class
    metatable.__base = base
    -- Overwrite our existing __index value with a metamethod which checks
    -- table fields, metatable, and base class, in that order, per behavior
    -- via the Lua 5.1 manual's illustrative code for indexing access
    metatable.__index = function(table, key)
      local h
      -- if type(table) == "table" then
        local v = rawget(metatable, key)
        if v ~= nil then return v end
        local baseclass = getbaseclass(metatable)
        if baseclass == nil then
          error("attempt to index base class '" .. base .. "' " ..
               "(a nil value)", 2)
        end
        h = baseclass.__index
        if h == nil then return nil end
      -- else
      --   h = getmetatable(table).__index
      --   if h == nil then
      --     error(...)
      --   end
      -- end
      if type(h) == "function" then
        return (h(table, key))     -- call the handler
      else return h[key]           -- or repeat operation on it
      end
    end
    -- Create inheritable metamethods
    for _, event in ipairs( eventnames ) do
      metatable[ event ] = metatable[ event ] or metamethod( metatable, event )
    end
  end
end

function class( modname )
  local function setmodule( modname )
    module( modname, classinit )
  end setmodule( modname )
  _R[ modname ] = package.loaded[ modname ]
  -- For syntactic sugar, return a function to set inheritance
  return function( base )
    local metatable = package.loaded[ modname ]
    inherit( base )( metatable )
  end
end

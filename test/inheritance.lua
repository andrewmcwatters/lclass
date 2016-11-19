-- inheritance.lua
-- simple class inheritance test

require( "class" )

local print = print

-------------------------------------------------------------------------------
-- animal
-------------------------------------------------------------------------------
module( "animal", package.class )

function _M:animal()
	self.kingdom = "Animalia"
end

function _M:getKingdom()
	return self.kingdom
end

local a = _M()
print( a:getKingdom() )

-------------------------------------------------------------------------------
-- amphibian
-- Base Class: animal
-------------------------------------------------------------------------------
module( "amphibian", package.class, package.inherit( "animal" ) )

function _M:amphibian()
	self.kingdom = "Animalia"
	self.class = "Amphibia"
end

function _M:getClass()
	return self.class
end

local a = _M()
print( a:getKingdom(), a:getClass() )

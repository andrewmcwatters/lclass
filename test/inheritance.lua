-- inheritance.lua
-- simple class inheritance test

require( "class" )

local print = print

-------------------------------------------------------------------------------
-- animal
-------------------------------------------------------------------------------
class( "animal" )

function animal:animal()
	self.kingdom = "Animalia"
end

function animal:getKingdom()
	return self.kingdom
end

local a = animal()
print( a:getKingdom() )

-------------------------------------------------------------------------------
-- amphibian
-- Base Class: animal
-------------------------------------------------------------------------------
class "amphibian" ( "animal" )

function amphibian:amphibian()
	self.kingdom = "Animalia"
	self.class = "Amphibia"
end

function amphibian:getClass()
	return self.class
end

local a = amphibian()
print( a:getKingdom(), a:getClass() )

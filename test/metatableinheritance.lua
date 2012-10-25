-- metatableinheritance.lua
-- metatable inheritance test

require( "class" )

-------------------------------------------------------------------------------
-- vehicle
-------------------------------------------------------------------------------
class "vehicle"

function vehicle:vehicle()
	self.name = "none"
end

function vehicle:__tostring()
	return "vehicle: " .. self.name
end

local v = vehicle()
print( v )

-------------------------------------------------------------------------------
-- car
-- Base Class: vehicle
-------------------------------------------------------------------------------
class "car" ( "vehicle" )

function car:car()
	self.name = "car"
end

local c = car()
print( c )

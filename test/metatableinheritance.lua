-- metatableinheritance.lua
-- metatable inheritance test

require( "class" )

local print = print

-------------------------------------------------------------------------------
-- vehicle
-------------------------------------------------------------------------------
function defineVehicle()
	module( "vehicle", package.class )

	function _M:vehicle()
		self.name = "none"
	end

	function _M:__tostring()
		return "vehicle: " .. self.name
	end

	local v = _M()
	print( v )
end defineVehicle()

-------------------------------------------------------------------------------
-- car
-- Base Class: vehicle
-------------------------------------------------------------------------------
function defineCar()
	module( "car", package.class, package.inherit "vehicle" )

	function _M:car()
		self.name = "car"
	end

	local c = _M()
	print( c )
end defineCar()

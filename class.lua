-------------------------------------------------------------------------------
-- Lua with Classes
-- lclass
-- Author: Andrew McWatters
-------------------------------------------------------------------------------
local setmetatable = setmetatable
local type = type
local error = error
local pcall = pcall
local unpack = unpack
local rawget = rawget
local getfenv = getfenv
local ipairs = ipairs

-------------------------------------------------------------------------------
-- new()
-- Purpose: Creates a new object
-- Input: metatable
-- Output: object
-------------------------------------------------------------------------------
local function new( metatable )
	local object = {}
	setmetatable( object, metatable )
	return object
end

-------------------------------------------------------------------------------
-- eventnames
-- Purpose: Provide a list of all inheritable internal event names
-------------------------------------------------------------------------------
local eventnames = {
	"__add", "__sub", "__mul", "__div", "__mod",
	"__pow", "__unm", "__len", "__lt", "__le",
	"__concat", "__call",
	"__tostring"
}

-------------------------------------------------------------------------------
-- metamethod()
-- Purpose: Creates a filler metamethod for metamethod inheritance
-- Input: class - Class metatable
--        eventname - Event name
-- Output: function
-------------------------------------------------------------------------------
local function metamethod( class, eventname )
	return function( ... )
		local event = nil
		local base = getbaseclass( class )
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

-------------------------------------------------------------------------------
-- classes
-- Purpose: Store classes for real-time class redefining
-------------------------------------------------------------------------------
classes = {}

-------------------------------------------------------------------------------
-- getbaseclass()
-- Purpose: Get a base class
-- Input: class - Class metatable
-- Output: class
-------------------------------------------------------------------------------
function getbaseclass( class )
	local name = class.__base
	return classes[ name ]
end

-------------------------------------------------------------------------------
-- class()
-- Purpose: Creates a new class
-- Input: name - Name of new class
-------------------------------------------------------------------------------
function class( name )
	local metatable = classes[ name ]
	if ( metatable ) then
		for k in pairs( metatable ) do
			metatable[ k ] = nil
		end
	else
		metatable = {}
		classes[ name ] = metatable
	end

	metatable.__index = metatable
	metatable.__type = name
	-- Create a shortcut to name()
	setmetatable( metatable, {
		__call = function( _, ... )
			-- Create a new instance of this object
			local metatable = classes[ name ]
			local object = new( metatable )
			-- Call its constructor (function name:name( ... ) ... end) if it
			-- exists
			local v = rawget( metatable, name )
			if ( v ~= nil ) then
				local type = type( v )
				if ( type ~= "function" ) then
					error( "attempt to call constructor '" .. name .. "' " ..
					       "(a " .. type .. " value)", 2 )
				end
				v( object, ... )
			end
			-- Return the new instance
			return object
		end
	} )
	-- Make the class available to the environment from which it was defined
	getfenv( 2 )[ name ] = metatable
	-- For syntactic sugar, return a function to set inheritance
	return function( base )
		-- Set our base class to the class definition in the function
		-- environment we called from
		local metatable = classes[ name ]
		if ( type( base ) == "string" ) then
			metatable.__base = getfenv( 2 )[ base ].__type
		else
			-- Otherwise set the base class directly
			metatable.__base = base.__type
		end
		-- Overwrite our existing __index value with a metamethod which checks
		-- our members, metatable, and base class, in that order, a la behavior
		-- via the Lua 5.1 manual's illustrative code for indexing access
		metatable.__index = function( table, key )
			local metatable = classes[ name ]
			local v = rawget( metatable, key )
			if ( v ~= nil ) then return v end
			local h = rawget( getbaseclass( metatable ), "__index" )
			if ( h == nil ) then return nil end
			if ( type( h ) == "function" ) then
				return h( table, key )
			else
				return h[ key ]
			end
		end
		-- Create inheritable metamethods
		for _, event in ipairs( eventnames ) do
			metatable[ event ] = metamethod( metatable, event )
		end
	end
end

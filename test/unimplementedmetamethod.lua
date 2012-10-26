-- unimplementedmetamethod.lua
-- unimplemented inherited metamethod test

require( "class" )

-------------------------------------------------------------------------------
-- number
-------------------------------------------------------------------------------

-- Create a bognus number class for the sake of testing
class "number"

-------------------------------------------------------------------------------
-- bignum
-- Base Class: number
-------------------------------------------------------------------------------
class "bignum" ( "number" )

function bignum:bignum( n )
	if ( type( n ) ~= "string" ) then
		error( "attempt to create a bignum using a non-string value", 2 )
	end
	self.number = n
end

function bignum:__tostring()
	return self.number
end

local n = bignum( "17976931348623157000000000000000000000000000000000000000" ..
"00000000000000000000000000000000000000000000000000000000000000000000000000" ..
"00000000000000000000000000000000000000000000000000000000000000000000000000" ..
"00000000000000000000000000000000000000000000000000000000000000000000000000" ..
"0000000000000000000000000000001" )

print( n / 0 )

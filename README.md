lclass
======

Lua with Classes

Usage
=====

Creating a class
----------------

	class( "upperclass" )

...or

	class "upperclass"

...or with inheritance!

	-- Inherit from existing class "power"
	class "upperclass" ( "power" )

Creating a constructor
----------------------

	function upperclass:upperclass()
		self.better = true
		self.simple = "very yes"
	end

Creating metamethods
--------------------

	function upperclass:__tostring()
		return "upperclass: the best class implementation in Lua. ever."
	end

Creating an instance of a class
-------------------------------

	local uc = upperclass()

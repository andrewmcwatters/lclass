lclass
======

Lua with Classes

Usage
=====

Creating a class
----------------

	class( "highclass" )

or

	class "highclass"

Creating a constructor
----------------------

	function highclass:highclass()
		self.better = true
		self.simple = "very yes"
	end

Creating metamethods
--------------------

	function highclass:__tostring()
		return "highclass: the best class implementation in Lua. ever."
	end

Creating an instance of a class
-------------------------------

	local hc = highclass()

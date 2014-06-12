lclass
======

Lua with Classes

About lclass
============

lclass is a class implementation for Lua 5.1. It has been designed to be the simplest, most comprehensive, and smallest class implementation for Lua. lclass accomplishes these goals without fluff. The source also conveniently provides thorough documentation and commenting to explain each piece of functionality, from how creating instances of classes works, down to inheritable metamethods.

Usage
=====

Creating a class
----------------

	class( "amphibian" )

...or

	class "amphibian"

...or with inheritance

	-- Inherit from existing class "animal"
	class "amphibian" ( "animal" )

Creating a constructor
----------------------

	function amphibian:amphibian()
		self.kingdom = "Animalia"
		self.class = "Amphibia"
	end

Creating metamethods
--------------------

	function amphibian:__tostring()
		return "amphibian: " .. self.class
	end

Creating an instance of a class
-------------------------------

	local a = amphibian()

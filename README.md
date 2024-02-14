# lclass
Lua with Classes

**lclass** has been in production environments for over a decade. It was
designed specifically for use with PUC-Rio Lua 5.1 and LuaJIT and to be used
alongside C++. It differs from all other known Lua class scripts in that classes
created with it behave like classes bound and created with `luaL_register`.

You are encouraged to read class.lua to understand its features. It is only 155
lines.

## Usage
### Creating a class
```lua
class("amphibian")
```

...or

```lua
class "amphibian"
```

...or with inheritance

```lua
-- inherit from existing class "animal"
class "amphibian" ("animal")
```

### Creating a constructor
```lua
function amphibian:amphibian ()
  -- call the base class constructor
  animal.animal(self)
  self.kingdom = "Animalia"
  self.class   = "Amphibia"
end
```

### Creating methods
```lua
function amphibian:swim ()
  print("Splash!")
end
```

### Creating metamethods
```lua
function amphibian:__tostring ()
  return "amphibian: " .. self.class
end
```

### Creating an instance of a class
```lua
local a = amphibian()
```

### Creating a garbage-collection metamethod
```lua
function amphibian:amphibian ()
  setproxy(self)
end

function amphibian:__gc()
  -- ...
end
```

## License
MIT License

Copyright (c) 2024 Andrew McWatters

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

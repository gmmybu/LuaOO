function WrapMethod(self, f)
  local obj = {}
  setmetatable(obj, {__call = function(_, ...)
    return f(self, ...)
  end})
  return obj
end

function Class(...)
  local class = {}
  local proto = arg
  setmetatable(class, {__index = function(self, key)
    --disable __index
    for i = 1, #proto do
      local value = rawget(proto[i], key)
      if value then
        return value
      end
    end
    
    --enable __index
    for i = 1, #proto do
        local value = proto[i][key]
        if value then
        return value
      end
  end,
  
  __call = function(_, ...)
    local obj = {}
    if class.__init__ then
      obj.__init__ = class.__init__
      obj:__init__(...)
      obj.__init__ = nil
    end
    
    setmetatable(obj, {__index = function(self, key)
      local value = class[key]
      if type(value) == 'function' then
        self[key] = WrapMethod(self, value)
      else
        self[key] = value
      end
      return self[key]
    end})
    return obj
  end})
  return class
end

Shape = Class()
Shape.getArea = function(self)
  error('NotImplementException')
end

Drawable = Class()
Drawable.draw = function(self)
  print('override please')
end

Circle = Class(Shape)
Circle.__init__ = function(self, radius)
  self.radius = radius
end

Circle.getArea = function(self)
  return math.pi * self.radius * self.radius
end

Rectangle = Class(Shape, Drawable)
Rectangle.__init__ = function(self, width, height)
  self.width  = width
  self.height = height
end

Rectangle.getArea = function(self)
  return self.width * self.height
end

Rectangle.k = 8

local circle    = Circle(8)
local rectangle = Rectangle(3, 2)
local callback  = {circle.getArea, rectangle.getArea}

for i, v in ipairs(callback) do
  print(v())
end

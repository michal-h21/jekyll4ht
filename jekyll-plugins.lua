-- Plugin infrastructure. Idea is to make for every backend plugin
-- This is the base plugin. Object with basic settings will be defined here. 
-- Derived plugins will use inheritance to modify only methods, which needs
-- to be redefined

-- Simple prototype based inheritance
-- source: http://lua-users.org/wiki/InheritanceTutorial
local function clone( base_object, clone_object )
  if type( base_object ) ~= "table" then
    return clone_object or base_object 
  end
  clone_object = clone_object or {}
  clone_object.__index = base_object
  return setmetatable(clone_object, clone_object)
end

local function isa( clone_object, base_object )
  local clone_object_type = type(clone_object)
  local base_object_type = type(base_object)
  if clone_object_type ~= "table" and base_object_type ~= table then
    return clone_object_type == base_object_type
  end
  local index = clone_object.__index
  local _isa = index == base_object
  while not _isa and index ~= nil do
    index = index.__index
    _isa = index == base_object
  end
  return _isa
end

local object = clone( table, { clone = clone, isa = isa } )

local Plugin = object:clone()
Plugin.sss="hhh"
function Plugin:getParams()
	print ("Get params"..self.sss)
end

Plugin["getParams"](Plugin)


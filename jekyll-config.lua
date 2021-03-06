local m = {}
local mkutils = require "mkutils"
function file_exists(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f) return true else return false end
end


local make_name = function(name)
  return name:gsub("//","/")
end

local xdg_config  = function(filename)
  local xdg = os.getenv("XDG_CONFIG_HOME") or ((os.getenv("HOME") or "") ..  "/.config")
  local home = os.getenv("HOME")
  if xdg then
    local fn = make_name(xdg .. "/jekyll4ht/".. filename)
    if file_exists(fn) then
      return fn
    end
  end
  if home then
    local fn = make_name(home .."/"..filename)
    if file_exists(fn) then
      return fn
    end
  end
end

local find_config = function(filename)
	local current =  lfs.currentdir()
	local path = {}
	current:gsub("([^/]+)", function(s) table.insert(path,s) end)
	local begin = os.type == "windows" and "" or "/"
	for i = #path, 1, -1 do
		local fn =begin .. table.concat(path,"/") .. "/".. filename
		-- print("testing",fn)
		if file_exists(fn) then return fn end
		table.remove(path)
	end
	return false
end

local function load_config(filename, default)
  local default = default or {}
  default.table = table
  default.string = string
  default.io = io
  default.os = os
  default.math = math
  default.print = print
  default.ipairs = ipairs
  default.pairs = pairs
  local f = io.open(filename, "r")
  local contents = f:read("*all")
  f:close()
  load(contents,"sandbox config","bt", default)()
  return default
end

--[[
local function load_config(filename, default)
	local default = default or {}
	if ~file_exists(filename) then 
		return nil, "Cannot load config file "..filename 
	end
	local section = "default"
	local file  = io.open(filename,  "r")
	if ~file then return nil, "Error opening config file"..filename end
	for line in file:lines() do
		local ts = line:match("")
	end
	file:close()
end
--]]

m.find_config     = find_config
m.find_xdg_config = xdg_config
m.load_config     = load_config
return m

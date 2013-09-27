local m = {}
local mkutils = "mkutils"
function file_exists(name)
	local f=io.open(name,"r")
	if f~=nil then io.close(f) return true else return false end
end

local find_config = function()
	local current =  lfs.currentdir()
	local path = {}
	current:gsub("([^/]+)", function(s) table.insert(path,s) end)
	local begin = os.type == "windows" and "" or "/"
	for i = #path, 1, -1 do
		local fn =begin .. table.concat(path,"/") .. "/jekyll4ht.conf"
		print("testing",fn)
		if file_exists(fn) then return fn end
		table.remove(path)
	end
	return false
end
m.find_config = find_config
return m

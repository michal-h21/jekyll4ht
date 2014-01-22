kpse.set_program_name "luatex"
local lapp = require "lapp-mk4"

local make_cmd = function(parrent, name)
	local m = {
		parrent = parrent,
		description = "",
		name = name,
		aliases = function(self, aliases)
			local parrent = self.parrent
			for _, v in pairs(aliases) do
				parrent:add_alias(v, self)
			end
			return self
		end,
		action = function(self, func)
			self.func = func
			return self
		end
	}
	print("Make command: "..name)
	print("Parrent: "..parrent.name)
	m.__index = m
	return setmetatable({},m)
end

local make_app = function(name)
	local name = name
	local m = {
		name = name,
		commands = {},
		aliases = {},
		command = function(self,cmd_name) 
			local obj = make_cmd(self,cmd_name)
			self.commands[cmd_name] = obj
			return obj
		end,
		add_alias= function(self, alias, obj)
			self.aliases[alias] = obj.name
		end,
		run = function(self,args)
			local args = args or {}
			local command = args[1] or "empty"
			local commands = self.commands
			local aliases = self.aliases
			command = aliases[command] or command		
			print("Příkaz: "..command)
		end
	}
	m.__index = m
	return setmetatable({},m)
end

local j = make_app("staticsite")
j:command("hello")
 :aliases{"pokus","ble"}
 :action(function()
  	print "hello" 
 end
)
j:command "nazdar":aliases{"jej"}:action(function(a,b)
	print("Nazdar")
end)
j:run(arg)

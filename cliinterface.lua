kpse.set_program_name "luatex"
local lapp = require "lapp-mk4"

local make_cmd = function(parent, name)
	local m = {
		parent = parent,
		description = "",
		name = name,
		aliases = function(self, aliases)
			local parent = self.parent
			for _, v in pairs(aliases) do
				parent:add_alias(v, self)
			end
			return self
		end,
		desc = function(self,text)
			self.description = text
			return self
		end,
		argtext = function(self,text)
			self.argument_text = text
			return self
		end,
		action = function(self, func)
			self.func = func
			return self
		end
	}
	print("Make command: "..name)
	print("Parent: "..parent.name)
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
		get_command = function(self, cmd)
			local command = cmd 
			local commands = self.commands
			local aliases = self.aliases
			command = aliases[command] or command	
			return commands[command]
		end,
		help = function(self, name)
			local buf = {}
			buf[#buf + 1] = self.desc
			buf[#buf + 1] = "Available commands:"
			for cmd, obj in pairs(self.commands) do
				local desc = obj.description or ""
				buf[#buf + 1] = string.format("  %s\t%s", cmd, desc)
			end
			return table.concat(buf,"\n")
		end,
		run = function(self,args)
			local args = args or {}
			local command = self:get_command(args[1]) or {}
			local name = command.name
			if name then
			  print("Příkaz: "..name)
				local fn = command.func
				fn(self, args)
			else
				print(self:help())
			end
		end
	}
	m.__index = m
	m:command "help":desc "Print help message":action(
		function(self, args)
			local parent = self.parent
			local name = self.name
			print(self:help(name))
		end
	)
	return setmetatable({},m)
end

local j = make_app("staticsite")
j:command("hello")
 :aliases{"pokus","ble"}
 :desc "řekne hello"
 :action(function()
  	print "hello" 
 end
)
j:command "nazdar":aliases{"jej"}
:desc "Vytiskne nazdar"
:action(function(a,b)
	print("Nazdar")
end)
j:run(arg)

return make_app

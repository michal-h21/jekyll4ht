-- module jekyll-commands
-- declare list of commands
-- each command can have own command line arguments
-- each command has: name, comment and argument list
local lapp = require "lapp-mk4"
lapp.show_usage_error = false
local m = {}

local commands = {}
local add_command = function(name)
	local name = name
	return function(comment)
		local comment = comment
		return function(optionstr)
			commands[name] = {comment = comment, option = optionstr}
		end
	end
end

add_command "new" "create new post" ""
add_command "draft" "compile draft" ""
add_command "final" "build final document" ""
add_command "push" "post document to the server" ""

local get_commands = function()
	local c = {}
	for k,w in pairs(commands) do
		c[#c+1]= k .. "\t-\t"..w.comment
	end
	return table.concat(c,"\n")
end

local find_command = function(args)
	local mode = false -- 
	local s = {"-m","--mode","-c","--config"}
	local skip = {}
	for _,w in pairs(s) do skip[w] = w end
	for _, a in pairs(args) do
		if a:match("^[^%-]+") then 
			if not mode and commands[a] then
				-- return if command exists and it is not argumment to mode option
				return a 
			end
			mode = false
		elseif skip[a] then
			mode = true
		else mode = false
		end
	end
end

m.get_commands = get_commands
m.find_command = find_command
return m

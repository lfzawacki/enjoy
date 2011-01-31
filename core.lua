-- commands are indexed by a string representing the button code
-- for now

local function new_command_table()

	local utilities = {
		-- inserts a command in the current button
		insert = function (self, cmd_table)

			-- check for errors
			assert(self.current , 'Set a current button first!')

			--local button_name = 'Button ' .. self.current.name .. ': '
			assert( cmd_table.down or cmd_table.up , 'Set at least one command (down/up)!')

			-- setups null objects (empty functions) if methods are absent
			if not cmd_table.down then cmd_table.down = function () end end
			if not cmd_table.up then cmd_table.up = function () end end

			table.insert(self.current, cmd_table)
		end
	}

	local meta = {
		-- the call metamethod will execute in sequence all the commands for a button
		-- state is either down or up (indicating a press or release repectively)
		__call = function (t,button,state)
			for _,cmd in ipairs(t[button]) do
				cmd[state]()
			end
		end ,

		__index = utilities
	}

	-- a new command table with no current button
	local cmd_table = { current = nil }

	return setmetatable(  cmd_table , meta )
end

-- TODO should be moved to some kind of config file
base_dir = 'mapping/'
current_file = base_dir .. 'example.lua'
commands = new_command_table()

local function do_event(x,state)
	x = tostring(x)
	if commands[x] ~= nil  then
		commands(x,state)
	else
		-- dont crash
	end

end

-- called from C
-- receives joystick events and performs actions
function __event_button(x,down)
	do_event(x, down and 'down' or 'up')
end

-- TODO: document the API

function button(b)
	-- creates the command table for this button
	-- and sets as the current one
	commands[b] = { }
	commands.current = commands[b]
end

-- cmd is polymorphic and stuff
-- it can receive strings, tables and functions
local function construct_cmd(param)
	local ret = nil

	if type(param) == 'table' then
		-- already ready and formated like a
		-- table with button (down|up) functions, we hope
		ret = param

	elseif type(param) == 'function' then
		-- a function to be executed,
		-- just need to make a button down table
		ret = {
			down = param
		}
	elseif type(param) == 'string' then
		-- a string is an os command,
		-- we encapsulate it in a function
		ret = {
			down = function ()
				print(param)
				os.execute(param)
			end
		}
	end

	return ret
end

local function execute_cmd(param)
	construct_cmd(param)['down']()
end

function cmd(param)
	commands:insert( construct_cmd(param) )
end

-- TODO
-- for now this uses xdotool to send the commands
-- in the future I want to have a portable module
-- that sends the keypresses
function key(k)
	cmd {
		down = function ()
			print(k .. ' down')
			execute_cmd('xdotool keydown ' .. k)
			--__send_key_event(k,true)
		end ,
		up = function()
			print(k .. ' up')
			execute_cmd('xdotool keyup ' .. k)
			--__send_key_event(k,false)
		end
	}
end

function toggle(cmd_table)

	-- TODO assert for errors

	-- closures rock
	local on = true

	cmd( function ()
			if on then
				execute_cmd(cmd_table.on)
				on = false
			else
				execute_cmd(cmd_table.off)
				on = true
			end
		end
	)

end

-- loads the commands stored in a file and displays a visual confirmation
-- the nodoc param should tell it not to display
-- the visual, but for now it does nothing
function load(filename,nodoc)

	cmd ( function ()
			commands = new_command_table()

			if filename ~= 'self' then current_file = base_dir .. filename end
			dofile(current_file)
			print('Loaded ' .. current_file)

			report(commands)
		end
	)

end

function explain(str)
	commands.current.explain = str
end

-- TODO modularize this to work everywhere
-- quick and dirty visual notification
-- works only where libnotify-bin package is available (ubuntu...)
local function notify_impl(t)

	t.icon = t.icon or "`pwd`/awesome.png"
	t.title = t.title or 'Empty'
	t.message = t.message or ''
	t.timeout = t.timeout or 1000
	return ('notify-send ' .. '"' .. t.title .. '" "' ..
		 '\n' .. t.message .. '" -i ' .. t.icon .. ' -t ' .. t.timeout  )

end

local function notify_real(t)
	os.execute(notify_impl(t))
end

function notify(t)
	cmd( notify_impl(t) )
end

-- crafts a notification message with the contents of a file
-- and displays it
function report(commands)
	local note = { title = current_file, message = '', timeout = 2000 }

	for i,cmd in pairs(commands) do
		if i ~= 'current' then
			note.message = note.message .. i .. ': ' .. (cmd.explain or 'Nothing') .. '\n'
		end
	end

	notify_real(note)
end


dofile(current_file)


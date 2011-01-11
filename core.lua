-- commands are indexed by a string representing the button code
-- for now

local function new_command_table()

	utilities = {
		-- inserts in the current button
		insert = function (self, cmd_table)

			-- check for errors
			assert(self.current , 'Set a current button first!')
			--local button_name = 'Button ' .. self.current.name .. ': '
			assert( cmd_table.down or cmd_table.up , 'Set at least one command (down/up)!')

			-- kind of setups null objects if methods are absent
			if not cmd_table.down then cmd_table.down = function () end end
			if not cmd_table.up then cmd_table.up = function () end end

			table.insert(self.current, cmd_table)
		end
	}

	meta = {
		-- batch_exec will execute in sequence all the commands for button
		-- state is either down or up (press or release)
		__call = function (t,button,state)
			for _,cmd in ipairs(t[button]) do
				cmd[state]()
			end
		end ,

		__index = utilities
	}

	return setmetatable( { current = nil } , meta )
end

current_file = 'commands.lua'
commands = new_command_table()

local function do_event(x,state)
	x = tostring(x)
	if commands[x] ~= nil  then
		print('not poof')
		commands(x,state)
	else
		-- dont crash
		print('poof')
	end

end

function event_button_down(x) do_event(x,'down') end
function event_button_up(x) do_event(x,'up') end

-- the 'API' are the button and exec functions

function button(b)
	commands[b] = { }
	commands.current = commands[b]
end

function exec(cmd)
	commands:insert { down = function ()
			print('exec ' .. cmd)
			os.execute(cmd)
		end
	}
end

function key(k)
	commands:insert {
		down = function ()
			     print(k .. ' down')
				 __send_key_down_event(k)
			   end ,
		up = function()
				print(k .. ' up')
				__send_key_up_event(k)
		end
	}
end

function load(filename,nodoc)

	commands:insert {

		down = function ()
			commands = new_command_table()

			if filename ~= 'self' then current_file = filename end
			dofile(current_file)
			print('Loaded ' .. current_file)

			report(commands)
		end
	}


end


function explain(str)
	commands.current.explain = str
end

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
	exec( notify_impl(t) )
end

function report(commands)
	note = { title = current_file, message = '', timeout = 2000 }

	for i,cmd in pairs(commands) do
		if i ~= 'current' then
			note.message = note.message .. i .. ': ' .. cmd.explain .. '\n'
		end
	end

	notify_real(note)
end


dofile(current_file)


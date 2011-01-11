-- commands are indexed by a string representing the button code
-- for now

local function new_command_table()

	utilities = {
		-- inserts in the current button
		insert = function (self, cmd_table)
			assert(self.current , 'Set a current button first!')
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
	commands[b] = {}
	commands.current = commands[b]
end

function exec(cmd)
	commands:insert { down = function () os.execute(cmd) end }
end

function key(k)
	commands:insert {
		down = function () __send_key_down_event(k) end ,
		up = function() __send_key_up_event(k) end
	}
end

function explain(str)
	commands.current.explain = str
end

function reset(filename,nodoc)

	f = function ()
		commands = new_command_table()

		if filename == 'self' then
			dofile(current_file)
		else
			dofile(filename)
			current_file = filename
		end

		report(commands)
	end

	table.insert( commands.current, { 'Loading ' .. filename , f } )
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


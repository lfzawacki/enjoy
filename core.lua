-- commands are indexed by a string representing the button code
-- for now

local function new_command_table()

	-- batch_exec will execute in sequence all the commands asked
	local function batch_exec(t,button)
		for _,cmd in ipairs(t[button]) do
			print(cmd[1])
			cmd[2]()
		end
	end

	return setmetatable({}, { __call = batch_exec } )
end

current_file = 'commands.lua'
commands = new_command_table()

-- the 'API' are the button and exec functions

function button(b)
	commands[b] = {}
	commands.current = commands[b]
end

function exec(cmd)
	table.insert(commands.current, { cmd , function () os.execute(cmd) end } )
end

function key(k)
	table.insert(commands.current , { 'k', function () __send_key_event(k) end } )
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


function event(x)
	x = tostring(x)
	if commands[x] ~= nil  then
		commands(x)
	else
		-- dont crash
		print('poof')
	end
end


dofile(current_file)


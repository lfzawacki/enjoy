button '1'
	explain 'Next commands'
	key 'BackSpace'

button '2'
	explain 'Previous commands'
	key 'a'

button '3'
	explain 'Play akinator'
	toggle { on = function () print('foo') end , off = function () print('bar') end }
	key 'Return'
	--cmd 'firefox www.akinator.com'

button '4'
	explain 'Ataque das Corujas'
	cmd 'aplay todo &'

button '8'
	explain 'Test toggle'
	notify { message = 'Compiled this shit' }
	toggle { on = 'make' , off = 'make love' }

button '9'
	explain 'Reload file'
	load 'self'


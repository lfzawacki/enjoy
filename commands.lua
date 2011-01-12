button '1'
	explain 'Next commands'
	key 'backspace'

button '2'
	explain 'Previous commands'
	key 'A'

button '3'
	explain 'Play akinator'
	toggle { on = function () print('foo') end , off = function () print('bar') end }
	key 'Return'
	--cmd 'firefox www.akinator.com'

button '4'
	explain 'Ataque das Corujas'
	cmd 'aplay todo &'

button '4'
	explain 'Test toggle'
	toggle { on = 'ls' , off = 'ls -al' }

button '9'
	explain 'Reload file'
	load 'self'

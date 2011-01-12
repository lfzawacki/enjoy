button '1'
	explain 'Next commands'
	key '1'

button '2'
	explain 'Previous commands'

button '3'
	explain 'Play akinator'
	exec 'firefox www.akinator.com'

button '4'
	explain 'Ataque das Corujas'
	exec 'aplay todo &'

button '8'
	explain 'Test toggle'
	toggle { on = 'ls' , off = 'ls -al' }

button '9'
	explain 'Reload file'
	load 'self'


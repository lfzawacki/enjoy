button '1'
	explain 'Go to menu'
	load 'menu.lua'

button '2'
	explain 'Go to exaile controls'
	load 'exaile.lua'

button '3'
	cmd 'firefox www.lua.org'

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


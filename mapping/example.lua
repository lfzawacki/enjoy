button '1'
	explain 'Go to menu'
	load 'menu.lua'

button '3'
	explain 'Open Firefox'
	cmd 'firefox www.lua.org'

button '4'
	explain 'Play a soundfile'
	cmd 'aplay -N ryu.wav'

button '0'
	explain 'Testing toggle'
	toggle { on = 'ls' , off = 'ls -al' }

button '8'
	explain 'Compile it (I used it while developing) ;)'
	notify { message = 'Compiled it!' }
	cmd 'make'

button '9'
	explain 'Reload file'
	load 'self'


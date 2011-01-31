button '4'
	explain 'Record'
	toggle { on = 'xdotool key r' , off = 'xdotool key space' }

button '1'
	explain 'Play'
	cmd 'xdotool key space'


button '8'
	explain 'Reload'
	load 'self'


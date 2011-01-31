button '4'
	explain 'Record'
	toggle { on = 'xdotool key r' , off = 'xdotool key space' }

button '1'
	explain 'Play'
	cmd 'xdotool key space'

button '0'
	explain 'Undo'
	cmd 'xdotool key Ctrl+Z'

button '3'
	explain 'Redo'
	cmd 'xdotool key Shift+Ctrl+Z'


button '8'
	explain 'Reload'
	load 'self'


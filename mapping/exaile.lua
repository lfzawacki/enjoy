button '1'
	explain 'Next track'
	cmd 'exaile -n'

button '2'
	explain 'Previous track'
	cmd 'exaile -p'

button '0'
	explain 'Volume++'
	cmd 'exaile -i 10'

button '3'
	explain 'Volume--'
	cmd 'exaile -l 10'

button '12'
	explain 'Show/Hide GUI'
	cmd 'exaile --toggle-visible'

button '4'
	explain 'Play/Pause'
	cmd 'exaile --play-pause'

button '8'
	explain 'Reload and show instructions'
	load 'self'

button '9'
	explain 'Go to menu'
	load 'menu.lua'


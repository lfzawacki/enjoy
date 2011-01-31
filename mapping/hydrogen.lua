
local function drum(wav)
	local map = {
		snare = 'c',
		kick = 'z',
		hihat = 'j',
		tomlow = 'b',
		tommid = 'n',
		crash = '2'
	}

	key(map[wav])

end

button '2'
	explain 'Snare'
	drum 'snare'

button '0'
	explain 'Tom Mid'
	drum 'tommid'

button '1'
	explain 'Tom Low'
	drum 'tomlow'


button '3'
	explain 'Hi-Hat'
	drum 'hihat'

button '4'
	explain 'Kick'
	drum 'kick'

button '8'
	explain 'Crash'
	drum 'crash'

button '9'
	explain 'Reload file'
	load 'self'


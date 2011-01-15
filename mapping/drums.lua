
-- this assumes you have hydrogen drumbeat installed
local function drum(wav)
	local map = {
		snare = 'Snare_Rock.wav',
		kick = 'Kick_Reg_1b.wav',
		hihat = 'HH_2_open.wav',
		tomlow = 'Tom_Low.wav',
		tommid = 'Tom_Mid.wav'
	}
	local path = '/usr/share/hydrogen/data/drumkits/UltraAcousticKit/'

	cmd('aplay ' .. path .. map[wav] .. '&')

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
	explain 'None'

button '9'
	explain 'Reload file'
	load 'self'


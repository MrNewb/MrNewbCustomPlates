fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_fxv2_oal 'yes'
name "MrNewbCustomPlates"
author "MrNewb"
version "1.0.5"
shared_scripts {
	'@ox_lib/init.lua',
	'shared/config.lua',
	'shared/lang.lua',
}

client_scripts {
	'bridge/**/client.lua',
	'client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'bridge/**/server.lua',
	'server/*.lua',
}

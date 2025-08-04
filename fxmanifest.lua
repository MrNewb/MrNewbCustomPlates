fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name "MrNewbCustomPlatesV2"
author "MrNewb"
version "2.1.1"
description "Custom Plates for FiveM with support for multiple frameworks and community bridge."

shared_scripts {
	'src/shared/config.lua',
	'src/shared/init.lua',
}

client_scripts {
	'src/client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'src/server/*.lua',
}

files {
	'locales/*.json',
}

dependencies {
	'/server:6116',
	'/onesync',
	'oxmysql',
	'community_bridge',
}

escrow_ignore {
	'src/**/*.lua',
}
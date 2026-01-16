fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name "MrNewbCustomPlatesV2"
author "MrNewb"
version "2.1.3"
description "MrNewbsCustomPlates is a custom license plate for fivem that supports multiple frameworks and features a bad word filter."

shared_scripts {
	'core/init.lua',
	'data/config.lua',
	'modules/**/shared/*.lua',
}

client_scripts {
	'modules/**/client/*.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'modules/**/server/*.lua',
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
	'core/*.lua',
	'data/*.lua',
	'modules/**/*.lua',
}
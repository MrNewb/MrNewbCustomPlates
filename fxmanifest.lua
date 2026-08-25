fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'MrNewbCustomPlates'
description 'Custom license plate item with bad-word filter and multi-framework support'
author 'MrNewb'
version '3.0.1'

shared_scripts {
    '@ox_lib/init.lua',
    '@Newb_Bridge/import.lua',
    'configs/config.lua',
    'resource/shared/plate_helpers.lua',
}

client_scripts {
    'resource/client/plate.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'resource/server/plates.lua',
    'resource/server/ox_inventory.lua',
}

ui_page 'web/build/index.html'

files {
    'locales/*.json',
    'web/build/index.html',
    'web/build/**/*',
}

dependencies {
    '/server:6116',
    '/onesync',
    'ox_lib',
    'oxmysql',
    'Newb_Bridge',
}

escrow_ignore {
    'configs/*.lua',
    'locales/*.json',
    'resource/**/*.lua',
    'web/**/*',
}
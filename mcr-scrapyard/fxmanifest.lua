fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'MCore Development'
description 'MCORE - Advanced Scrapyard System'
version '1.0.0'

shared_script {
    '@ox_lib/init.lua',
    'config/config.lua'
}

client_scripts {
    'client/client.lua',
    'config/cl_edits.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

dependency 'ox_target'
--dependency 'qb-target'
dependency 'ox_lib' 

escrow_ignore {
    'config/config.lua',
    'config/cl_edits.lua',
    'install/*',
    'README.md'
} 
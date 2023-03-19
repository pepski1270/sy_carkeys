fx_version 'cerulean'

game 'gta5' 

name 'sy_carkeys'

author 'Symbiote#3027'

repository 'https://github.com/Mono-94/sy_carkeys'

shared_scripts{
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
} 


client_scripts{
    'client/*.lua'
} 

server_scripts{
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
} 


files {
    'locales/*.json'
}

lua54 'yes'

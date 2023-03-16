
#
# <center>**SY_CARKEYS**</center>
<center><img src="https://i.imgur.com/45ygmFr.png"></center>

#
#
# <center>**Features**</center>
* Turn on and off the vehicle engine using the corresponding assigned key to the vehicle (optional).
* Retrieve lost keys through an NPC that can be easily added in the Config.lua file.
* Administrators can create keys for the vehicle they are in, as well as for other players using their ID.
* NPC-owned vehicles will be parked with their doors closed, and will be turned off if opened (optional).
* Lockpicking system with skill check, allowing players to force entry into vehicles (includes a function in the Config.lua file to optionally add a dispatch system).
* Includes a tool called "Wire Cutters" with skill check, allowing players to hotwire previously forced vehicles (optional).
* Keybind to open/close the vehicle. (Default key is U, can be changed in the Config.lua file.)
* Keybind to turn on/off the engine. (Default key is M, can be changed in the Config.lua file.)
#
#
#  <center>**Commands Admins**</center>
* /givekey [ID] - With this command, you can obtain a key for the vehicle you are currently in, or you can use the ID of a player who is in a vehicle to give them a key to that vehicle.

* /delkey [ID] - With this command, you can delete the key for the vehicle you are currently in.

# 
#


# <center> **Events y exports**</center>

* To obtain a key for a nearby vehicle with a progress bar:
```LUA
exports['sy_carkeys']:CarKey()
```
* To generate a key with a wait time for the player to enter the vehicle and obtain its license plate:
```LUA
exports['sy_carkeys']:CarKeyBuy() 
```
* To delete the key of a player in their current vehicle (useful for when a player returns a work vehicle):
```LUA
TriggerEvent('sy_carkeys:DeleteClientKey', count)
```
* To delete specific keys:
```LUA
local model = GetEntityModel(playerVehicle)
local name = GetDisplayNameFromVehicleModel(model)
TriggerServerEvent('sy_carkeys:DeleteKey', count, plate, name)  
```
* To open the key recovery menu:
```LUA
TriggerEvent('sy_carkeys:obtenerLlaves')
```

#
#
#  <center>**Ox inventory ITEM's**</center>
```LUA
['carkeys'] = {
	label = 'Car Key',
	weight = 5,
	stack = true
},

['ganzua'] = {
	label = 'Lockpick',
	weight = 25,
	stack = true
},

['alicates'] = {
	label = 'Wire Cutters',
	weight = 50,
	stack = true
},

 ```
#
#
# <center> **Dependencies**</center>
 - ox_lib  -  https://github.com/overextended/ox_lib/releases  
 - ox_inventory  -  https://github.com/overextended/ox_inventory/releases  
 - ox_target  -  https://github.com/overextended/ox_target/releases  

  #
  <sub> <center> Discord https://discord.gg/AscBqDbZNb </center></sub>
  #




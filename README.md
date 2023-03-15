
Discord  https://discord.gg/AscBqDbZNb



* Create a copy of the keys of the nearby vehicle. (This can be used in some job's menu.)
```LUA

exports['sy_carkeys']:CarKey() 

```
* On buy car
```LUA
--Client

local ped = cache.ped
local pedcords = GetEntityCoords(ped)
local car = lib.getClosestVehicle(pedcords, 5, true)
local model = GetEntityModel(car)
local name = GetDisplayNameFromVehicleModel(model)
local plate = GetVehicleNumberPlateText(car)
TriggerServerEvent('sy_carkeys:KeyOnBuy', plate, model) 

--Or you can use this export without having to check the model or the plate.
exports['sy_carkeys']:CarKeyBuy() 



--Server
TriggerEvent('sy_carkeys:KeyOnBuy', plate, model)

```
* Open buy menu 
```LUA
TriggerEvent('sy_carkeys:obtenerLlaves')
```
* Ox inventory ITEM
```LUA
	['carkeys']                  = {
		label = 'Car Key',
		weight = 5,
		stack = true,
		client = {
			event = 'sy_carkeys:llavesindatos'
		}
	},
 ```

 * Dependencies
 - ox_lib  -  https://github.com/overextended/ox_lib/releases  
 - ox_inventory  -  https://github.com/overextended/ox_inventory/releases  

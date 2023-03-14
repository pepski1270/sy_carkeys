
  <img src="https://forum.cfx.re/uploads/default/original/4X/f/f/f/fff19d1a25351b571a6d597fd8128ff511bd6558.png"/>
Hello community!

This is the first script I'm sharing on the forum. I'm not an expert in programming, I do it as a hobby. If you find any errors or see something strange in the code, let me know.

The script is basically a key system for vehicles that works with the key as an item using metadata.

**Features**

* Creation of NPCs in different positions on the map to buy keys for owned vehicles.

* Prevents the player from breaking the vehicle window to access it if the vehicle is locked.
* Keybind - (U)
* Event to claim keys when a player buys a vehicle.


**Added**
* Command to receive the keys of the vehicle in which you are sitting, ONLY FOR ADMINISTRATORS. ( /givekey  or /givekey ID Player , the player will have to be seated in the vehicle.
 
* Your self

<img src="https://forum.cfx.re/uploads/default/original/4X/2/2/6/226611814b70f4b62c24cfdd2ad01d1f7c18f207.png"/>

* Player Id

<img src="https://forum.cfx.re/uploads/default/original/4X/7/2/c/72c4da7fefda569ee4aa5281117b8a94d99bb5e9.png"/>


Ox Inventory Item

```
['carkeys'] = {
		label = 'Car Key',
		weight = 5,
		stack = true,
		client = {
			event = 'sy_carkeys:llavesindatos'
		}
},

```
* *carkey.png*

<img src="https://forum.cfx.re/uploads/default/original/4X/c/9/e/c9eb2c8bf3d52f15a6cc095ec2053a353e0d35a6.png"/>


Create a copy of the keys of the nearby vehicle. (This can be used in some job's menu.)
> exports['sy_carkeys']:CarKey()

 You can use this export without having to check the model or  plate.
> exports['sy_carkeys']:CarKeyBuy()

Buy car ( example, model = sultan )
> TriggerServerEvent('sy_carkeys:KeyOnBuy', plate, model)

Preview 
https://streamable.com/akf84k

Download
 - https://github.com/Mono-94/sy_carkeys

Dependencies
 - ox_lib  -  https://github.com/overextended/ox_lib/releases  
 - ox_inventory  -  https://github.com/overextended/ox_inventory/releases
 - ox_target   -   https://github.com/overextended/ox_target/releases

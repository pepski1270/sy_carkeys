![image|673x500](upload://AwbppBx02Ic5aIYUbH3q3xCpC6k.png)


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
    Your self
![image|522x138](upload://4UiUHikTC0tSC9IhiVB6r8yTOxp.png)
 Player Id
![image|534x149](upload://gnibFYZnryYLWICIfIwoftn1vN7.png)



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
*carkey.png*
![carkeys|100x100](upload://sOfPqNWCnNfFfw8rCwuNglnhTkG.png)

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

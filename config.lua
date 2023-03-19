lib.locale()
Keys = {}

Keys.Debug = false              -- Prints and commands for developers.

Keys.Distance = 5               -- Distance to open or close.

Keys.DistanceCreate = 5         -- Distance to create key.

Keys.CreateKeyTime = 1000       -- progressBar time.

Keys.ItemName = 'carkeys'       -- Name item.

Keys.CopyPrice = 50             -- Price to buy copy keys.

Keys.KeyOpenClose = 'U'         -- KeyBind Open / Close.

Keys.KeyToggleEngine = 'M'      -- KeyBind Open / Close.

Keys.CommandGiveKey = 'givekey' -- Command onfly admins .

Keys.CommandDelKey = 'delkey'   -- Command onfly admins .

Keys.Engine = true              -- With this you will maintain control of the engine in the vehicle and you will only be able to start the engine with the keys.

Keys.OnExitCar = false          -- (Experimental) Its purpose is to allow, if the vehicle is running and the "F" key is held down, the engine will continue running. If the "F" key is pressed once and released, the engine will turn off. Initially, this function should only work if the vehicle is running.
-- NPC

Keys.NpcReclameKey = {
    {
        hash = 'a_m_y_beachvesp_02',
        pos = vector3(-56.4195, -1098.47, 25.422),
        heading = 25.75,
        icon = 'fas fa-key',
        label = locale('cerrajero'),
        blip = true
    },
    {
        hash = 'a_m_y_beachvesp_01',
        pos = vector3(1702.8302, 4917.1963, 41.2240),
        heading = 151.1461,
        icon = 'fas fa-key',
        label = locale('cerrajero'),
        blip = true
    },

}


Keys.CloseDoorsNPC = true      -- Close All NPC Cars Doors on create Entity.

Keys.DoorProbability = true    -- Probability of finding an open door. (Netx Update)

Keys.OpenDoorProbability = 1.0 --  Min 0.0 , Max 1.0.

-- LockPick and HotWire

Keys.LockPick = {
    {
        enable = true,           -- Enable o disable LockPick
        alarmProbability = 1.0,  -- Min 0.0 max 1.0
        alarmTime = 10000,        
        SkillCheck = true,       -- If it's false, a progress bar will be used.
        TimeProgress = 2000,
        Skills = { 
            { {areaSize = 60, speedMultiplier = 1},{areaSize = 60, speedMultiplier = 0.5},{areaSize = 60, speedMultiplier = 1},{areaSize = 60, speedMultiplier = 0.5},{areaSize = 60, speedMultiplier = 1}, }, { '1', '2','3','4','5'}
        },
        animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",      
        anim = "machinic_loop_mechandplayer",
        Disptach = false,                   
        DispatchFunction = function()  -- You can put here Dispatch Event. 
            print('Dispatch activated.')
        end
    }
}

Keys.HotWire = {
    {
        enable = true,     -- Enable o Disable Hotwire.
        SkillCheck = true, -- If it's false, a progress bar will be used.
        TimeProgress = 2000,  
        Skills = {
            { {areaSize = 60, speedMultiplier = 1},{areaSize = 60, speedMultiplier = 0.5} }, { '1', '2' }
        },
        animDict = "veh@std@ds@base",
        anim = "hotwire",
    }
}


--Notification

RegisterNetEvent('sy_carkeys:Notification')
AddEventHandler('sy_carkeys:Notification', function(title, msg, type)
    lib.notify({
        title = title,
        description = msg,
        type = type
    })
end)

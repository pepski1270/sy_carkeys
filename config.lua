lib.locale()
Keys = {}

Keys.Distance = 5 -- Distance to open or close

Keys.DistanceCreate = 5 -- Distance to create key

Keys.CreateKeyTime = 5000 -- progressBar time

Keys.ItemName = 'carkeys' -- Name item 

Keys.CopyPrice = 50  -- Price to buy copy keys

Keys.Key = 'U'  -- KeyBind

Keys.CommandGiveKey = 'givekey' -- Command onfly admins .

Keys.CloseDoorsNPC = true         -- Close All NPC Cars Doors on create Entity.

Keys.OpenDoorProbability = 0.5    -- Probability of finding an open door Min 0.0 , Max 1.0

Keys.NpcReclameKey = {
    {
        hash = 'a_m_y_beachvesp_02',
        pos = vector3(-56.4195, -1098.47, 25.422),
        heading = 25.75,
        icon = 'fas fa-key',
        label = locale('cerrajero'),
        blip = true 

    },
  -- Example 
  --  {
  --      hash = 'a_m_y_beachvesp_01',
  --      pos =  vector3(158.06, 6654.59, 30.67),
  --     heading = 133.0,
  --     icon = 'fas fa-key',
  --      label = locale('cerrajero'),
  --      blip = true 
  --  },

}
--Noti
RegisterNetEvent('sy_carkeys:Notification')
AddEventHandler('sy_carkeys:Notification', function(title, msg, type)
    lib.notify({
        title = title,
        description = msg,
        type = type
    })
end)





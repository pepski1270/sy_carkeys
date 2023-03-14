lib.locale()


local ox_inventory = exports.ox_inventory


RegisterServerEvent('sy_carkeys:KeyOnBuy', function(plate, model)
    if ox_inventory:CanCarryItem(source, Keys.ItemName, 1) then
        ox_inventory:AddItem(source, Keys.ItemName, 1,
            { plate = plate, description = locale('key_description', plate, model) })
    end
end)


RegisterServerEvent('sy_carkeys:BuyKeys', function(plate, model)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= Keys.CopyPrice then
        if ox_inventory:CanCarryItem(source, Keys.ItemName, 1) then
            exports.ox_inventory:RemoveItem(source, 'money', Keys.CopyPrice)
            ox_inventory:AddItem(source, Keys.ItemName, 1,
                { plate = plate, description = locale('key_description', plate, model) })
            TriggerClientEvent('sy_carkeys:Notification', source, locale('title'),
                locale('llavecomprada', model, Keys.CopyPrice), 'success')
        end
    else
        TriggerClientEvent('sy_carkeys:Notification', source, locale('title'), locale('NoDinero'), 'error')
    end
end)

lib.callback.register('sy_carkeys:getVehicles', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()
    local vehicles = {}

    local results = MySQL.Sync.fetchAll("SELECT * FROM `owned_vehicles` WHERE `owner` = @identifier", {
        ['@identifier'] = identifier,
    })
    if results[1] ~= nil then
        for i = 1, #results do
            local result = results[i]
            local veh = json.decode(result.vehicle)
            vehicles[#vehicles + 1] = { plate = result.plate, vehicle = veh }
        end
        return vehicles
    end
end)


lib.addCommand(Keys.CommandGiveKey, {
    help = locale('givekey'),
    params = {
        {
            name = 'ID',
            help = locale('helpgivekey'),
            optional = true,
        },

    },
    restricted = 'group.admin'
}, function(source, args)
    local target = args.ID or source
    TriggerClientEvent('sy_carkeys:AddKeysCars', target)
end)


if Keys.CloseDoorsNPC then
    AddEventHandler('entityCreated', function(entity)
        if not DoesEntityExist(entity) then
            return
        end
        local entityType = GetEntityType(entity)
        if entityType ~= 2 then
            return
        end
        if GetEntityPopulationType(entity) > 5 then
            return
        end
        if math.random() > Keys.OpenDoorProbability then
            return
        end
        SetVehicleDoorsLocked(entity, 2)
    end)
end

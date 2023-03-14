lib.locale()


local ox_inventory = exports.ox_inventory


RegisterServerEvent('sy_carkeys:KeyOnBuy', function(plate, model)
    if ox_inventory:CanCarryItem(source, Keys.ItemName, 1) then
        ox_inventory:AddItem(source, Keys.ItemName, 1, {plate = plate, description = locale('key_description',plate,model)})
    end
end)


RegisterServerEvent('sy_carkeys:BuyKeys', function(plate,model)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= Keys.CopyPrice then
        if ox_inventory:CanCarryItem(source, Keys.ItemName, 1) then
            exports.ox_inventory:RemoveItem(source, 'money', Keys.CopyPrice)
            ox_inventory:AddItem(source, Keys.ItemName, 1, {plate = plate, description = locale('key_description',plate,model)})
            TriggerClientEvent('sy_carkeys:Notification', source, locale('title'), locale('llavecomprada',model,Keys.CopyPrice), 'success')
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

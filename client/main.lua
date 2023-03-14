lib.locale()

local vehiculocerrado = nil



vehiculocerrado = SetInterval(function()
    local ped = cache.ped
    if DoesEntityExist(GetVehiclePedIsTryingToEnter(ped)) then
        local veh = GetVehiclePedIsTryingToEnter(ped)
        local lock = GetVehicleDoorLockStatus(veh)
        if lock == 4 then
            ClearPedTasks(ped)
        end
    else
        SetInterval(vehiculocerrado, 500)
    end
end, 10)

RegisterNetEvent('sy_carkeys:llavesindatos', function(data)
    if not data.metadata.plate then
        print('No Metada Key.')
        return
    end
end)

lib.addKeybind({
    name = 'car_key',
    description = locale('keybindDesc'),
    defaultKey = Keys.Key,
    onPressed = function()
        AbrirCerrarPuertas()
    end
})

function AbrirCerrarPuertas()
    local ped = cache.ped
    local playerCoords = GetEntityCoords(ped)
    local closet = lib.getClosestVehicle(playerCoords, Keys.Distance, true)
    if closet then
        local prop = GetHashKey('p_car_keys_01')

        RequestModel(prop)
        while not HasModelLoaded(prop) do
            Wait(10)
        end
        local prop = CreateObject(prop, 1.0, 1.0, 1.0, 1, 1, 0)


        local plate = string.gsub(GetVehicleNumberPlateText(closet), " ", "")

        local dict = "anim@mp_player_intmenu@key_fob@"
        lib.requestAnimDict(dict, 0)

        local key = nil
        local keys = exports.ox_inventory:Search('slots', Keys.ItemName)
        for i, v in ipairs(keys) do
            if string.gsub(v.metadata.plate, " ", "") == plate then
                key = v
                break
            end
        end

        if not key then
            TriggerEvent('sy_carkeys:Notification', locale('title'), locale('key_not_owned_car'), 'error')
            return
        end
        if not IsPedInAnyVehicle(ped, true) then
            AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 57005), 0.08, 0.039, 0.0, 0.0, 0.0, 0.0, true,
                true, false, true, 1, true)
        elseif not key then

        end
        if not IsPedInAnyVehicle(ped, true) then
            TaskPlayAnim(ped, "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false, false)
        elseif not key then

        end
        local EstadoPuertas = GetVehicleDoorLockStatus(closet)

        if EstadoPuertas == 4 then
            SetVehicleDoorsLocked(closet, 1)
            PlayVehicleDoorOpenSound(closet, 0)
            TriggerEvent('sy_carkeys:Notification', locale('title'), locale('unlock_veh'), 'success')
            LucesLocas(closet,prop)
        elseif EstadoPuertas == 1 then
            SetVehicleDoorsLocked(closet, 4)
            PlayVehicleDoorCloseSound(closet, 1)
            TriggerEvent('sy_carkeys:Notification', locale('title'), locale('lock_veh'), 'alert')
            LucesLocas(closet,prop)
        end
    else
        TriggerEvent('sy_carkeys:Notification', locale('title'), locale('no_veh_nearby'), 'error')
        return
    end
end

function LucesLocas(closet,prop)
    SetVehicleLights(closet, 2)
    Wait(250)
    SetVehicleLights(closet, 0)
    Wait(250)
    SetVehicleLights(closet, 2)
    Wait(250)
    SetVehicleLights(closet, 0)
    Wait(600)
    DetachEntity(prop, false, false)
    DeleteEntity(prop)
end

AddEventHandler('sy_carkeys:AddKeysCars', function()
    local ped = cache.ped
    local playerVehicle = GetVehiclePedIsIn(ped, false)
    if playerVehicle ~= 0 then
        local vehicleProps = lib.getVehicleProperties(playerVehicle)
        local model = GetEntityModel(playerVehicle)
        local name = GetDisplayNameFromVehicleModel(model)
        TriggerServerEvent('sy_carkeys:CreateKey', vehicleProps.plate, name)
    else
        TriggerEvent('sy_carkeys:Notification', locale('title'), locale('dentrocar'), 'error')
    end
end)






function CarKey()
    local ped = cache.ped
    local pedcords = GetEntityCoords(ped)
    local car = lib.getClosestVehicle(pedcords, Keys.DistanceCreate, true)
    local model = GetEntityModel(car)
    local name = GetDisplayNameFromVehicleModel(model)
    local plate = GetVehicleNumberPlateText(car)
    if car == nil then
        TriggerEvent('sy_carkeys:Notification', locale('title'), locale('nocarcerca'), 'error')
    else
        if lib.progressBar({
                duration = Keys.CreateKeyTime,
                label = locale('forjar'),
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                },
            })
        then
            TriggerServerEvent('sy_carkeys:KeyOnBuy', plate, name)
        else
            TriggerEvent('sy_carkeys:Notification', locale('title'), locale('calcelado'), 'alert')
        end
    end
end

exports('CarKey', CarKey)



function CarKeyBuy()
    local ped = cache.ped
    local pedcords = GetEntityCoords(ped)
    local car = lib.getClosestVehicle(pedcords, Keys.DistanceCreate, true)
    local model = GetEntityModel(car)
    local name = GetDisplayNameFromVehicleModel(model)
    local plate = GetVehicleNumberPlateText(car)
    if car == nil then
        TriggerEvent('sy_carkeys:Notification', locale('title'), locale('nocarcerca'), 'error')
    else
        TriggerServerEvent('sy_carkeys:KeyOnBuy', plate, name)
    end
end

exports('CarKeyBuy', CarKeyBuy)

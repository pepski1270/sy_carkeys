function GetPlayerKey()
    local ped = cache.ped
    local playerCoords = GetEntityCoords(ped)
    local closet = lib.getClosestVehicle(playerCoords, Keys.Distance, true)
    local plate = string.gsub(GetVehicleNumberPlateText(closet), " ", "")
    local keys = exports.ox_inventory:Search('slots', Keys.ItemName)
    for i, v in ipairs(keys) do
        if string.gsub(v.metadata.plate, " ", "") == plate then
            return v
        end
    end
    return nil
end

lib.addKeybind({
    name = 'car_key',
    description = locale('keybindDesc'),
    defaultKey = Keys.KeyOpenClose,
    onPressed = function()
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

            local dict = "anim@mp_player_intmenu@key_fob@"
            lib.requestAnimDict(dict)

            if not GetPlayerKey() then
                TriggerEvent('sy_carkeys:Notification', locale('title'), locale('key_not_owned_car'))
                return
            end
            if not IsPedInAnyVehicle(ped, true) then
                AttachEntityToEntity(prop, ped, GetPedBoneIndex(ped, 57005), 0.08, 0.039, 0.0, 0.0, 0.0, 0.0, true,
                    true, false, true, 1, true)
            elseif not GetPlayerKey() then

            end
            if not IsPedInAnyVehicle(ped, true) then
                TaskPlayAnim(ped, "anim@mp_player_intmenu@key_fob@", "fob_click_fp", 8.0, 8.0, -1, 48, 1, false, false,
                    false)
            elseif not GetPlayerKey() then

            end
            local EstadoPuertas = GetVehicleDoorLockStatus(closet)

            if EstadoPuertas == 2 then
                TriggerServerEvent('sy_carkeys:ServerDoors', VehToNet(closet), GetVehicleDoorLockStatus(closet))
                TriggerEvent('sy_carkeys:Notification', locale('title'), locale('unlock_veh'))
                Wait(1000)
                DetachEntity(prop, false, false)
                DeleteEntity(prop)
            elseif EstadoPuertas == 1 then
                TriggerServerEvent('sy_carkeys:ServerDoors', VehToNet(closet), GetVehicleDoorLockStatus(closet))
                TriggerEvent('sy_carkeys:Notification', locale('title'), locale('lock_veh'))
                Wait(1000)
                DetachEntity(prop, false, false)
                DeleteEntity(prop)
            end
        else
            TriggerEvent('sy_carkeys:Notification', locale('title'), locale('no_veh_nearby'))
            return
        end
    end
})






function GetVehicleEngineState(vehicle)
    local state = GetVehicleEngineHealth(vehicle) > 0 and GetIsVehicleEngineRunning(vehicle)
    return state
end

if Keys.OnExitCar then
    local MotorOn = false
    local MotorOnSalir = nil
    MotorOnSalir = SetInterval(function()
        local ped = cache.ped
        local vehicle = GetVehiclePedIsIn(ped, false)
        local inCar = IsPedInAnyVehicle(ped, false)
        if inCar and vehicle ~= nil and vehicle ~= 0 then
            if IsControlPressed(2, 75) then
                Wait(100)
                if GetPlayerKey() ~= nil and IsControlPressed(2, 75) then
                    Wait(100)
                    if not MotorOn and GetVehicleEngineState(vehicle) then
                        MotorOn = true
                    end
                    if MotorOn then
                        SetVehicleEngineOn(vehicle, true, true, false)
                    end
                end
            else
                if GetVehicleEngineState(vehicle) then
                    MotorOn = true
                else
                    MotorOn = false
                end
            end
        else
            SetInterval(MotorOnSalir, 500)
        end
    end, 10)
end



RegisterNetEvent('sy_carkeys:LucesLocas', function(netId, lockStatus)
    local vehicle = NetToVeh(netId)
    if DoesEntityExist(vehicle) then
        PlayVehicleDoorCloseSound(vehicle, 1)
        SetVehicleDoorsLockedForAllPlayers(vehicle, lockStatus)
        SetVehicleLights(vehicle, 2)
        Wait(250)
        SetVehicleLights(vehicle, 0)
        Wait(250)
        SetVehicleLights(vehicle, 2)
        Wait(250)
        SetVehicleLights(vehicle, 0)
        Wait(600)
    end
end)


RegisterNetEvent('sy_carkeys:AddKeysCars')
AddEventHandler('sy_carkeys:AddKeysCars', function()
    local ped = cache.ped
    local playerVehicle = GetVehiclePedIsIn(ped, false)
    if playerVehicle ~= 0 then
        local vehicleProps = lib.getVehicleProperties(playerVehicle)
        local model = GetEntityModel(playerVehicle)
        local name = GetDisplayNameFromVehicleModel(model)
        TriggerServerEvent('sy_carkeys:CreateKey', vehicleProps.plate, name)
    else
        TriggerEvent('sy_carkeys:Notification', locale('title'), locale('dentrocar'))
    end
end)

RegisterNetEvent('sy_carkeys:DeleteClientKey')
AddEventHandler('sy_carkeys:DeleteClientKey', function(count)
    local ped = cache.ped
    local playerVehicle = GetVehiclePedIsIn(ped, false)
    if playerVehicle ~= 0 then
        local vehicleProps = lib.getVehicleProperties(playerVehicle)
        local model = GetEntityModel(playerVehicle)
        local name = GetDisplayNameFromVehicleModel(model)
        TriggerServerEvent('sy_carkeys:DeleteKey', count, vehicleProps.plate, name)
    else
        TriggerEvent('sy_carkeys:Notification', locale('title'), locale('dentrocar'))
    end
end)




function CarKey(time)
    local ped = cache.ped
    local pedcords = GetEntityCoords(ped)
    local car = lib.getClosestVehicle(pedcords, Keys.DistanceCreate, true)
    local model = GetEntityModel(car)
    local name = GetDisplayNameFromVehicleModel(model)
    local plate = GetVehicleNumberPlateText(car)
    if car == nil then
        TriggerEvent('sy_carkeys:Notification', locale('title'), locale('nocarcerca'))
    else
        if lib.progressBar({
                duration = time,
                label = locale('forjar'),
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                },
            })
        then
            TriggerServerEvent('sy_carkeys:CreateKey', plate, name)
        else
            TriggerEvent('sy_carkeys:Notification', locale('title'), locale('calcelado'))
        end
    end
end

function CarKeyBuy(time)
    Wait(time)
    local ped = cache.ped
    local pedcords = GetEntityCoords(ped)
    local car = lib.getClosestVehicle(pedcords, Keys.DistanceCreate, true)
    local model = GetEntityModel(car)
    local name = GetDisplayNameFromVehicleModel(model)
    local plate = GetVehicleNumberPlateText(car)
    if car == nil then
        TriggerEvent('sy_carkeys:Notification', locale('title'), locale('nocarcerca'))
    else
        TriggerServerEvent('sy_carkeys:CreateKey', plate, name)
    end
end

local vehiculocerrado = nil


vehiculocerrado = SetInterval(function()
    local ped = cache.ped
    if DoesEntityExist(GetVehiclePedIsTryingToEnter(ped)) then
        local veh = GetVehiclePedIsTryingToEnter(ped)
        local lock = GetVehicleDoorLockStatus(veh)

        if lock == 2 then
            ClearPedTasks(ped)
        end

        if Keys.Engine then
            if lock == 1 then
                if GetIsVehicleEngineRunning(veh) == false then
                    SetVehicleNeedsToBeHotwired(veh, false)
                    SetVehicleEngineOn(veh, false, true, true)
                end
            end
            if GetIsVehicleEngineRunning(veh) == false then
                return
            end
        end
    else
        SetInterval(vehiculocerrado, 500)
    end
end, 0)



if Keys.Engine then
    CreateThread(function()
        while true do
            local ped = cache.ped
            local vehicle = GetVehiclePedIsIn(ped, false)
            local inCar = IsPedInAnyVehicle(ped, false)

            if inCar and vehicle ~= nil and vehicle ~= 0 then
                local engineRunning = GetIsVehicleEngineRunning(vehicle)
                if engineRunning then
                    EnableControlAction(2, 71, true)
                else
                    DisableControlAction(2, 71, true)
                end
                Wait(0)
            else
                Wait(0)
            end
        end
    end)


    local engineStatus = nil
    lib.addKeybind({
        name = 'motor',
        description = 'Apagar/Encender Motor',
        defaultKey = Keys.KeyToggleEngine,
        onPressed = function()
            local ped = cache.ped

            local vehicle = GetVehiclePedIsIn(ped, false)

            if not IsPedInAnyVehicle(ped, false) then
                TriggerEvent('sy_carkeys:Notification', locale('title'),
                    locale('incar'))
                return
            end

            if not GetPlayerKey() then
                TriggerEvent('sy_carkeys:Notification', locale('title'), locale('key_not_owned_car'))
                return
            end

            if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
                SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), true, true)
            end

            if not (engineStatus) then
                engineStatus = true
            else
                engineStatus = false
            end
        end
    })
end




function LockPick()
    for k, v in pairs(Keys.LockPick) do
        local ped = cache.ped
        local pedcords = GetEntityCoords(ped)
        local closet = lib.getClosestVehicle(pedcords, 3, true)
        local EstadoPuertas = GetVehicleDoorLockStatus(closet)
        lib.requestAnimDict(v.animDict)
        if closet then
            if v.SkillCheck then
                if EstadoPuertas == 1 then
                    TriggerEvent('sy_carkeys:Notification', locale('LockPickTitle'), locale('NoLocPick')
                    )
                    return
                end
                TaskPlayAnim(ped, v.animDict, v.anim, 8.0, 8.0, -1, 48, 1, false, false, false)
                local success = lib.skillCheck(table.unpack(v.Skills))
                if success then
                    ClearPedTasks(ped)
                    TriggerEvent('sy_carkeys:Notification', locale('LockPickTitle'), 'LockPick success'
                    )
                    TriggerServerEvent('sy_carkeys:ServerDoors', VehToNet(closet), GetVehicleDoorLockStatus(closet))
                    if math.random() < v.alarmProbability then
                        SetVehicleAlarmTimeLeft(closet, v.alarmTime)
                    end
                    if v.Disptach then
                        v.DispatchFunction()
                    end
                else
                    ClearPedTasks(ped)
                    TriggerEvent('sy_carkeys:Notification', locale('LockPickTitle'), locale('LockPickFail'))
                end
            else
                if EstadoPuertas == 1 then
                    TriggerEvent('sy_carkeys:Notification', locale('LockPickTitle'), locale('NoLocPick')
                    )
                    return
                end
                if lib.progressBar({
                        duration = v.TimeProgress,
                        label = locale('LocPickProgress'),
                        useWhileDead = false,
                        canCancel = false,
                        disable = {
                            car = true,
                        },
                        anim = {
                            dict = v.animDict,
                            clip = v.anim
                        },
                    }) then
                    TriggerServerEvent('sy_carkeys:ServerDoors', VehToNet(closet), GetVehicleDoorLockStatus(closet))
                    if math.random() < v.alarmProbability then
                        SetVehicleAlarmTimeLeft(closet, v.alarmTime)
                    end
                    if v.Disptach then
                        v.DispatchFunction()
                        TriggerEvent('sy_carkeys:Dispatch')
                    end
                else
                    if math.random() < v.alarmProbability then
                        SetVehicleAlarmTimeLeft(closet, v.alarmTime)
                    end
                    TriggerEvent('sy_carkeys:Notification', locale('LockPickTitle'), locale('LockPickFail'))
                end
            end
        else
            TriggerEvent('sy_carkeys:Notification', locale('LockPickTitle'), locale('nocarcerca'))
        end
    end
end

function HotWire()
    for k, v in pairs(Keys.HotWire) do
        local ped = cache.ped
        local inVehicle2 = GetVehiclePedIsIn(ped, false)
        local inVehicle = IsPedInAnyVehicle(ped)
        lib.requestAnimDict(v.animDict)
        if inVehicle then
            if v.SkillCheck then
                TaskPlayAnim(ped, v.animDict, v.anim, 8.0, 8.0, -1, 48, 1, false, false, false)
                local success = lib.skillCheck(table.unpack(v.Skills))
                if success then
                    local engineRunning = GetIsVehicleEngineRunning(inVehicle2)
                    if engineRunning then
                        SetVehicleEngineOn(inVehicle2, false, true, true)
                        if Keys.Debug then
                            print('Motor off')
                        end
                        DisableControlAction(2, 71, false)
                    else
                        SetVehicleEngineOn(inVehicle2, true, true, true)
                        if Keys.Debug then
                            print('Motor on')
                        end
                    end
                    ClearPedTasks(ped)
                else
                    TriggerEvent('sy_carkeys:Notification', locale('HotWireTitle'), locale('HotWireFail'))
                end
            else
                if lib.progressBar({
                        duration = v.TimeProgress,
                        label = locale('LocPickProgress'),
                        useWhileDead = false,
                        canCancel = false,
                        disable = {
                            car = true,
                        },
                        anim = {
                            dict = v.animDict,
                            clip = v.anim
                        },
                    }) then
                    local engineRunning = GetIsVehicleEngineRunning(inVehicle2)
                    if engineRunning then
                        SetVehicleEngineOn(inVehicle2, false, true, true)
                        if Keys.Debug then
                            print('Motor off')
                        end
                    else
                        SetVehicleEngineOn(inVehicle2, true, true, true)
                        if Keys.Debug then
                            print('Motor on')
                        end
                    end
                else
                    if math.random() < v.alarmProbability then
                        SetVehicleAlarmTimeLeft(inVehicle2, v.alarmTime)
                    end
                    TriggerEvent('sy_carkeys:Notification', locale('HotWireTitle'), locale('HotWireFail'))
                end
            end
        else
            TriggerEvent('sy_carkeys:Notification', locale('HotWireTitle'), locale('HotWireInCar'))
        end
    end
end




function SetMatricula()
    local ped = cache.ped
    local inVehicle = IsPedInAnyVehicle(ped)

    if inVehicle then
        local vehicle = GetVehiclePedIsIn(ped, false)
        local plate = GetVehicleNumberPlateText(vehicle)

        local input = lib.inputDialog(locale('MatriculaNueva'), {
            {
                type = 'input',
                label = locale('ActualMatri', plate),
                description = locale('MatriculaMax')
            },
            {
                type = 'select',
                label = locale('CambiarColorMatri'),
                options = {
                    { value = 0, label = 'Blue / White'},
                    { value = 1, label = 'Yellow / black'},
                    { value = 2, label = 'Yellow / Blue'},
                    { value = 3, label = 'Blue/ White 2'},
                    { value = 4, label = 'Blue / White 3'},
                    { value = 5, label = 'Yankton'},
                }
            },
        })
        if not input then return end
        local count = 0
        for i = 1, #input[1] do
            local c = string.sub(input[1], i, i)
            if c == ' ' then
                count = count + 1
            else
                count = count + utf8.len(c)
            end
        end

        if count > 8 or count == 0 then
            TriggerEvent('sy_carkeys:Notification', locale('title'), locale('MatriculaMax'))
        else
            local vehicle = GetVehiclePedIsUsing(ped)
            local model = GetEntityModel(vehicle)
            local newName = GetDisplayNameFromVehicleModel(model)
            local newPlate = string.upper(input[1])
            local newColor = input[2]

        
            TriggerServerEvent('sy_carkeys:SetMatriculaServer', plate, newPlate, newColor, newName)

        end
    else
        TriggerEvent('sy_carkeys:Notification', locale('title'), locale('CambiarMatriDentro'))
    end
end

RegisterNetEvent('sy_carkeys:SetMatricula')
AddEventHandler('sy_carkeys:SetMatricula', function(newPlate,newColor)
    local vehicle = GetVehiclePedIsUsing(cache.ped)
    local plate = GetVehicleNumberPlateText(vehicle)
    local model = GetEntityModel(vehicle)
    local name = GetDisplayNameFromVehicleModel(model)
    SetVehicleNumberPlateText(vehicle, newPlate)
    SetVehicleNumberPlateTextIndex(vehicle, newColor)
    TriggerServerEvent('sy_carkeys:DeleteKey', 1, plate, name)
    TriggerServerEvent('sy_carkeys:CreateKey', newPlate, name)
    return newPlate,newColor, name
end)    




exports('HotWire', HotWire)

exports('LockPick', LockPick)

exports('CarKeyBuy', CarKeyBuy)

exports('CarKey', CarKey)

exports('SetMatricula', SetMatricula)



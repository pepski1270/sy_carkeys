lib.addKeybind({
    name = 'car_key',
    description = locale('keybindDesc'),
    defaultKey = Keys.KeyOpenClose,
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




        local dict = "anim@mp_player_intmenu@key_fob@"
        lib.requestAnimDict(dict)
        local plate = string.gsub(GetVehicleNumberPlateText(closet), " ", "")
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
            LucesLocas(closet, prop)
        elseif EstadoPuertas == 1 then
            SetVehicleDoorsLocked(closet, 4)
            PlayVehicleDoorCloseSound(closet, 1)
            TriggerEvent('sy_carkeys:Notification', locale('title'), locale('lock_veh'), 'alert')
            LucesLocas(closet, prop)
        end
    else
        TriggerEvent('sy_carkeys:Notification', locale('title'), locale('no_veh_nearby'), 'error')
        return
    end
end

function LucesLocas(closet, prop)
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

RegisterNetEvent('sy_carkeys:AddKeysCars')
AddEventHandler('sy_carkeys:AddKeysCars', function()
    local ped = cache.ped
    local playerVehicle = GetVehiclePedIsIn(ped, false)
    if playerVehicle ~= 0 then
        local vehicleProps = lib.getVehicleProperties(playerVehicle)
        local model = GetEntityModel(playerVehicle)
        local name = GetDisplayNameFromVehicleModel(model)
        TriggerServerEvent('sy_carkeys:KeyOnBuy',  vehicleProps.plate, name)
    else
        TriggerEvent('sy_carkeys:Notification', locale('title'), locale('dentrocar'), 'error')
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
    Wait(1000)
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




local vehiculocerrado = nil


vehiculocerrado = SetInterval(function()
    local ped = cache.ped
    if DoesEntityExist(GetVehiclePedIsTryingToEnter(ped)) then
        local veh = GetVehiclePedIsTryingToEnter(ped)
        local lock = GetVehicleDoorLockStatus(veh)

        if lock == 4 then
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
end, 10)


if Keys.OnExitCar then
    local MotorOnSalir = nil

    MotorOnSalir = SetInterval(function()
        local ped = cache.ped
        local vehicle = GetVehiclePedIsIn(ped, false)
        local inCar = IsPedInAnyVehicle(ped, false)
        if inCar and vehicle ~= nil and vehicle ~= 0 then
            if IsControlPressed(2, 75)  then
                Wait(100)
                if IsControlPressed(2, 75)  then
                    Wait(100)
                    if not GetIsVehicleEngineRunning(vehicle) then
                        SetVehicleEngineOn(vehicle, true, true, false)
                    end
                end
            end
        else
            SetInterval(MotorOnSalir, 0)
        end
    end, 10)
end


if Keys.Engine then
    local engineInterval = nil

    engineInterval = SetInterval(function()
        local ped = cache.ped
        local vehicle = GetVehiclePedIsIn(ped, false)
        local inCar = IsPedInAnyVehicle(ped, false)
    
        if vehicle ~= nil and vehicle ~= 0 then
            local engineRunning = GetIsVehicleEngineRunning(vehicle)
            if engineRunning then
                EnableControlAction(2, 71, true)
                if engineInterval then
                    SetInterval(engineInterval, 2) -- Reducir el intervalo de verificación a 2 milisegundos
                end
            else
                DisableControlAction(2, 71, true)
                if engineInterval then
                    SetInterval(engineInterval, 0)
                end
            end
        else
            SetInterval(engineInterval, 500)
        end
    end, 0) -- Reducir el intervalo de verificación a 2 milisegundos
    


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
                    locale('incar'), 'error')
                return
            end

            local key = nil

            local plate = string.gsub(GetVehicleNumberPlateText(vehicle), " ", "")

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
                    TriggerEvent('sy_carkeys:Notification', locale('LockPickTitle'), locale('NoLocPick'),
                        'error')
                    return
                end
                TaskPlayAnim(ped, v.animDict, v.anim, 8.0, 8.0, -1, 48, 1, false, false, false)
                local success = lib.skillCheck(table.unpack(v.Skills))
                if success then
                    ClearPedTasks(ped)

                    SetVehicleDoorsLocked(closet, 1)
                    if math.random() < v.alarmProbability then
                        SetVehicleAlarmTimeLeft(closet, v.alarmTime)
                    end
                    if v.Disptach then
                        v.DispatchFunction()
                    end
                else
                    ClearPedTasks(ped)
                    TriggerEvent('sy_carkeys:Notification', locale('LockPickTitle'), locale('LockPickFail'), 'error')
                end
            else
                if EstadoPuertas == 1 then
                    TriggerEvent('sy_carkeys:Notification', locale('LockPickTitle'), locale('NoLocPick'),
                        'error')
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
                    SetVehicleDoorsLocked(closet, 1)
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
                    TriggerEvent('sy_carkeys:Notification', locale('LockPickTitle'), locale('LockPickFail'), 'error')
                end
            end
        else
            TriggerEvent('sy_carkeys:Notification', locale('LockPickTitle'), locale('nocarcerca'), 'error')
        end
    end
end

exports('LockPick', LockPick)

if Keys.Debug then
    RegisterCommand('abrir', function()
        LockPick()
    end)
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
                    TriggerEvent('sy_carkeys:Notification', locale('HotWireTitle'), locale('HotWireFail'), 'error')
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
                    TriggerEvent('sy_carkeys:Notification', locale('HotWireTitle'), locale('HotWireFail'), 'error')
                end
            end
        else
            TriggerEvent('sy_carkeys:Notification', locale('HotWireTitle'), locale('HotWireInCar'), 'error')
        end
    end
end

exports('HotWire', HotWire)

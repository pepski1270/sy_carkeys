lib.locale()


CreateThread(function()
    for k, v in pairs(Keys.NpcReclameKey) do
        RequestModel(v.hash)
        while not HasModelLoaded(v.hash) do
            Wait(1)
        end
        NPC = CreatePed(2, v.hash, v.pos.x, v.pos.y, v.pos.z, v.heading, false, false)
        SetPedFleeAttributes(NPC, 0, 0)
        SetPedDiesWhenInjured(NPC, false)
        TaskStartScenarioInPlace(NPC, v.PedScenario, 0, true)
        SetPedKeepTask(NPC, true)
        SetBlockingOfNonTemporaryEvents(NPC, true)
        SetEntityInvincible(NPC, true)
        FreezeEntityPosition(NPC, true)
        if v.blip then
            blip = AddBlipForCoord(v.pos.x, v.pos.y, v.pos.z)
            SetBlipSprite(blip, 186)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 1.0)
            SetBlipColour(blip, 4)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(locale('cerrajero'))
            EndTextCommandSetBlipName(blip)
        end
        exports.ox_target:addBoxZone({
            coords = vec3(v.pos.x, v.pos.y, v.pos.z + 1),
            size = vec3(1, 1, 2),
            rotation = v.heading,
            debug = v.debug,
            options = {
                {
                    icon = v.icon,
                    label = v.label,
                    onSelect = function()
                        local KeyMenu = {}
                        local vehicles = lib.callback.await('sy_carkeys:getVehicles')

                        if vehicles == nil then
                            TriggerEvent('sy_carkeys:Notification', locale('title'), locale('nopropio'), 'alert')
                            return
                        end
                        for i = 1, #vehicles do
                            local data = vehicles[i]
                            local name = GetDisplayNameFromVehicleModel(data.vehicle.model)
                            local marca = GetMakeNameFromVehicleModel(data.vehicle.model)
                            local plate = data.vehicle.plate
                            local price = Keys.CopyPrice


                            table.insert(KeyMenu, {
                                title = marca .. ' - ' .. name,
                                iconColor = 'green',
                                icon = 'car',
                                arrow = true,
                                description = locale('matricula', plate),
                                onSelect = function()
                                    local options = {}
                                    if v.BuyKey then
                                        table.insert(options, {
                                            title = locale('ComprarKey'),
                                            icon = 'key',
                                            arrow = true,
                                            description = locale('precio', price),
                                            image = 'nui://ox_inventory/web/images/' .. Keys.ItemName .. '.png',
                                            onSelect = function()
                                                local alert = lib.alertDialog({
                                                    header = locale('buy_key_confirm1'),
                                                    content = locale('buy_key_confirm2', plate, marca, name,
                                                        price),
                                                    centered = true,
                                                    cancel = true
                                                })
                                                if alert == 'cancel' then
                                                    TriggerEvent('sy_carkeys:Notification', locale('title'),
                                                        locale('vuelve'),
                                                        'alert')
                                                    return
                                                else
                                                    if lib.progressBar({
                                                            duration = Keys.CreateKeyTime,
                                                            label = locale('forjar'),
                                                            useWhileDead = false,
                                                            canCancel = false,
                                                            disable = {
                                                                car = true,
                                                            },
                                                        })
                                                    then
                                                        TriggerServerEvent('sy_carkeys:BuyKeys', plate, name)
                                                    end
                                                end
                                            end
                                        })
                                    end
                                    if v.BuyPlate then
                                        table.insert(options, {
                                            title = locale('Matricula'),
                                            icon = 'rectangle-list',
                                            arrow = true,
                                            description = locale('ComprarMatriDescri', Keys.PriceItemPlate),
                                            image = 'nui://ox_inventory/web/images/'..Keys.ItemPlate..'.png',
                                            serverEvent = 'sy_carkeys:ComprarMatricula'
                                        })
                                    end
                                    lib.registerContext({
                                        id = 'sy_carkeys:MenuCarSelect',
                                        title = name .. ' - ' .. marca,
                                        menu = 'sy_carkeys:SelectCarKey',
                                        options = options
                                    })


                                    lib.showContext('sy_carkeys:MenuCarSelect')
                                end
                            })
                        end

                        lib.registerContext({
                            id = 'sy_carkeys:SelectCarKey',
                            title = locale('cerrajero'),
                            options = KeyMenu
                        })

                        lib.showContext('sy_carkeys:SelectCarKey')
                    end
                }
            }
        })
    end
end)


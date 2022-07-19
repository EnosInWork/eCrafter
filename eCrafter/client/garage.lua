ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Wait(10)
    end
    ESX.PlayerData = ESX.GetPlayerData()
end)

function OpenGarageVendeur()
    local main_garage_vendeur = RageUI.CreateMenu("", "Garage")
    RageUI.Visible(main_garage_vendeur, not RageUI.Visible(main_garage_vendeur))
    while main_garage_vendeur do
        Citizen.Wait(0)
            RageUI.IsVisible(main_garage_vendeur, true, true, true, function()

        RageUI.ButtonWithStyle("Ranger la voiture", "Pour ranger une voiture.", {RightLabel = "→→"},true, function(Hovered, Active, Selected)
            if (Selected) then   
            local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                if dist4 < 4 then
                    TriggerServerEvent('ddx_vehiclelock:deletekeyjobs', 'no')
                    DeleteEntity(veh)
                    RageUI.CloseAll()
                end 
            end
        end) 

        RageUI.ButtonWithStyle("Baller", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
            if (Selected) then
            spawnCar('baller6')
            RageUI.CloseAll()
            end
        end)

        RageUI.ButtonWithStyle("Manchez", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
            if (Selected) then
            spawnCar('manchez')
            RageUI.CloseAll()
            end
        end)

        RageUI.ButtonWithStyle("Contender Max 4X4", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
            if (Selected) then
            spawnCar('contender')
            RageUI.CloseAll()
            end
        end)

        RageUI.ButtonWithStyle("Cognoscenti", nil, {RightLabel = "→"},true, function(Hovered, Active, Selected)
            if (Selected) then
            spawnCar("cognoscenti")
            RageUI.CloseAll()
            end
        end)

        end, function() 
        end)
    
        if not RageUI.Visible(main_garage_vendeur) then
            main_garage_vendeur = RMenu:DeleteType(main_garage_vendeur, true)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
        local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, Config.garage.position.x, Config.garage.position.y, Config.garage.position.z)
        if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Config.OrgaName then 
        if jobdist <= Config.Marker.DrawDistance then
            Timer = 0
            DrawMarker(Config.Marker.Type, Config.garage.position.x, Config.garage.position.y, Config.garage.position.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
            end
            if jobdist <= 1.0 then
                Timer = 0
                    RageUI.Text({ message = "Appuyez sur ~m~[E]~s~ pour ouvrir →→ ~m~Garage", time_display = 1 })
                    if IsControlJustPressed(1,51) then
                        OpenGarageVendeur()
                    end   
                end 
            end
        Citizen.Wait(Timer)   
    end
end)

function spawnCar(car)
    local car = GetHashKey(car)
    RequestModel(car)
    while not HasModelLoaded(car) do
        RequestModel(car)
        Wait(0)
    end
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), false))
    local vehicle = CreateVehicle(car, Config.spawnvoiture.position.x, Config.spawnvoiture.position.y, Config.spawnvoiture.position.z, Config.spawnvoiture.position.h, true, false)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleMaxMods(vehicle)
    SetPedIntoVehicle(PlayerPedId(),vehicle,-1) 
    TriggerServerEvent('ddx_vehiclelock:givekey', 'no', GetVehicleNumberPlateText(vehicle)) -- Ajout clé véhicule
end

function SetVehicleMaxMods(vehicle)
    local props = {
      modEngine       = 2,
      modBrakes       = 2,
      modTransmission = 2,
      modSuspension   = 3,
      modTurbo        = true,
    }
    ESX.Game.SetVehicleProperties(vehicle, props)
    SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)
    SetVehicleCustomSecondaryColour(vehicle, 0, 0, 0)
end
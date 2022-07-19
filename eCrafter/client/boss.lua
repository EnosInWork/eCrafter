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

function menuduboss()
    local main = RageUI.CreateMenu("", "Coffre")

        RageUI.Visible(main, not RageUI.Visible(main))
            while main do
            Citizen.Wait(0)
            RageUI.IsVisible(main, true, true, true, function()

            if societyvendeurmoney2 ~= nil then
                RageUI.ButtonWithStyle("Argent société :", nil, {RightLabel = "$" .. societyvendeurmoney2}, true, function()
                end)
            end

            RageUI.Separator("")

            RageUI.ButtonWithStyle("Retirer de l'argent",nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                if Selected then
                    local amount = KeyboardInput("Montant", "", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        RageUI.Popup({message = "[~r~Problème~s~]\nMontant invalide"})
                    else
                        TriggerServerEvent("eCrafter:retraitentreprise", amount)
                        RefreshvendeurMoney()
                    end
                end
            end)

            RageUI.ButtonWithStyle("Déposer de l'argent",nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                if Selected then
                    local amount = KeyboardInput("Montant", "", "", 10)
                    amount = tonumber(amount)
                    if amount == nil then
                        RageUI.Popup({message = "[~r~Problème~s~]\nMontant invalide"})
                    else
                        TriggerServerEvent("eCrafter:depotentreprise", amount)
                        RefreshvendeurMoney()
                    end
                end
            end) 

            RageUI.ButtonWithStyle("Recruter", nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                if (Selected) then   
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer ~= -1 and closestDistance <= 3.0 then
                        TriggerServerEvent('eCrafter:recruter', GetPlayerServerId(closestPlayer))
                    else
                        RageUI.Popup({message = "[~r~Problème~s~]\nAucun joueur à proximité"})
                    end 
                end
            end)

                RageUI.ButtonWithStyle("Promouvoir", nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                if (Selected) then   
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer ~= -1 and closestDistance <= 3.0 then
                        TriggerServerEvent('eCrafter:promouvoir', GetPlayerServerId(closestPlayer))
                    else
                        RageUI.Popup({message = "[~r~Problème~s~]\nAucun joueur à proximité"})
                    end 
                end
            end)

                RageUI.ButtonWithStyle("Rétrograder", nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                if (Selected) then   
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer ~= -1 and closestDistance <= 3.0 then
                        TriggerServerEvent('eCrafter:descendre', GetPlayerServerId(closestPlayer))
                    else
                        RageUI.Popup({message = "[~r~Problème~s~]\nAucun joueur à proximité"})
                    end 
                end
            end)

                RageUI.ButtonWithStyle("Virer", nil, {RightLabel = "→→"}, not cooldown, function(Hovered, Active, Selected)
                if (Selected) then   
                    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                    if closestPlayer ~= -1 and closestDistance <= 3.0 then
                        TriggerServerEvent('eCrafter:virer', GetPlayerServerId(closestPlayer))
                    else
                        RageUI.Popup({message = "[~r~Problème~s~]\nAucun joueur à proximité"})
                    end 
                end
            end)

            end, function()
            end)

            if not RageUI.Visible(main) then
            main = RMenu:DeleteType("Coffre", true)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local Timer = 500
        local plycrdjob = GetEntityCoords(GetPlayerPed(-1), false)
        local jobdist = Vdist(plycrdjob.x, plycrdjob.y, plycrdjob.z, Config.boss.position.x, Config.boss.position.y, Config.boss.position.z)
        if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Config.OrgaName and ESX.PlayerData.job2.grade_name == 'boss' then 

        if jobdist <= Config.Marker.DrawDistance then
            Timer = 0
            DrawMarker(Config.Marker.Type, Config.boss.position.x, Config.boss.position.y, Config.boss.position.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
            end
            if jobdist <= 1.0 then
                Timer = 0
                    RageUI.Text({ message = "Appuyez sur ~m~[E]~s~ pour ouvrir →→ ~m~Actions Patron", time_display = 1 })
                    if IsControlJustPressed(1,51) then
                        RefreshvendeurMoney()
                        menuduboss()
                    end   
                end 
            end
        Citizen.Wait(Timer)   
    end
end)

function RefreshvendeurMoney()
    if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then
        ESX.TriggerServerCallback('eCrafter:getSocietyMoney', function(money)
            UpdateSocietyvendeurMoney(money)
        end, ESX.PlayerData.job2.name)
    end
end

function UpdateSocietyvendeurMoney(money)
    societyvendeurmoney2 = ESX.Math.GroupDigits(money)
end
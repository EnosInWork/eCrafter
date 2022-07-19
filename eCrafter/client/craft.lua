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

local inCraft = true 
local selectedSymbol = 1
local cVarLongC = {"- [~o~Fabrication en cours~s~] -", "-- [~o~Fabrication en cours~s~] --", "--- [~o~Fabrication en cours~s~] ---", "---- [~o~Fabrication en cours~s~] ----", "----- [~o~Fabrication en cours~s~] -----", "------ [~o~Fabrication en cours~s~] ------"}
local cVarLong = function()
    return cVarLongC[selectedSymbol]
end

RegisterNetEvent('eCrafter:animationCreateWeapon')
AddEventHandler('eCrafter:animationCreateWeapon', function()

    LanceMoiSa()

    FreezeEntityPosition(PlayerPedId(), true)

    if Config.Animation == true then 
	TaskStartScenarioInPlace(PlayerPedId(), Config.AnimName, 0, true)
    end

	Citizen.Wait(Config.WaitForReceive) 

	ClearPedTasksImmediately(PlayerPedId())

    FreezeEntityPosition(PlayerPedId(), false)

    inCraft = true

end)

LanceMoiSa = function()
    inCraft = false
    Citizen.CreateThread(function()
        while not inCraft do
            Wait(800)
            selectedSymbol = selectedSymbol + 1
            if selectedSymbol > #cVarLongC then
                selectedSymbol = 1
            end
        end
    end)
end

function ouvrircraftzebi()
    local main = RageUI.CreateMenu("", "Craft")
    RageUI.Visible(main, not RageUI.Visible(main))
    while main do
        Citizen.Wait(0)
            RageUI.IsVisible(main, true, true, true, function()

                if not inCraft then
                    RageUI.Separator(cVarLong())
                end


                for k,v in pairs(Config.Crafting) do

                    RageUI.ButtonWithStyle(v.label,"~o~Matériaux requis:\n~y~"..v.materiaux[1].label.." (x"..v.materiaux[1].amout.."), " ..v.materiaux[2].label.." (x"..v.materiaux[2].amout.."), "..v.materiaux[3].label.." (x"..v.materiaux[3].amout.."), "..v.materiaux[4].label.." (x"..v.materiaux[4].amout..")", {RightLabel = ""}, inCraft, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('eCrafter:CreateWeapon', v.name, v.materiaux)
                        end
                    end)
        
                end

            end, function() 
            end)
    
        if not RageUI.Visible(main) then
            main = RMenu:DeleteType(main, true)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
        local dist3 = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Config.table.position.x, Config.table.position.y, Config.table.position.z)
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.OrgaName or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Config.OrgaName then 
            if dist3 <= 15.0 then
                DrawMarker(Config.Marker.Type, Config.table.position.x, Config.table.position.y, Config.table.position.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
            end
            if dist3 <= 1.0 then   
                RageUI.Text({ message = "Appuyez sur ~m~[E]~s~ pour ouvrir →→ ~m~Table de Craft", time_display = 1 })
            if IsControlJustPressed(1,51) then           
                ouvrircraftzebi()
            end   
            end
        end 
    end
end)
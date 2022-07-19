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

local dragStatus = {}
local IsHandcuffed = false
dragStatus.isDragged = false
local PlayerData, GUI, CurrentActionData, JobBlips = {}, {}, {}, {}
local publicBlip = false
local colorVar = "~o~"
local PlyID = PlayerPedId()
local Items = {}      -- Item que le joueur possède (se remplit lors d'une fouille)
local Armes = {}    -- Armes que le joueur possède (se remplit lors d'une fouille)
local ArgentSale = {}  -- Argent sale que le joueur possède (se remplit lors d'une fouille)
local IsHandcuffed, DragStatus = false, {}
DragStatus.IsDragged          = false
local PlayerData = {}
local function MarquerJoueur()
	local ped = GetPlayerPed(ESX.Game.GetClosestPlayer())
	local pos = GetEntityCoords(ped)
	local target, distance = ESX.Game.GetClosestPlayer()
	if distance <= 4.0 then
	DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1, 2, 1, nil, nil, 0)
end
end
local function getPlayerInv(player)
Items = {}
Armes = {}
ArgentSale = {}

ESX.TriggerServerCallback('enos:getOtherPlayerData', function(data)
	for i=1, #data.accounts, 1 do
		if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
			table.insert(ArgentSale, {
				label    = ESX.Math.Round(data.accounts[i].money),
				value    = 'black_money',
				itemType = 'item_account',
				amount   = data.accounts[i].money
			})

			break
		end
	end

	for i=1, #data.weapons, 1 do
		table.insert(Armes, {
			label    = ESX.GetWeaponLabel(data.weapons[i].name),
			value    = data.weapons[i].name,
			right    = data.weapons[i].ammo,
			itemType = 'item_weapon',
			amount   = data.weapons[i].ammo
		})
	end

	for i=1, #data.inventory, 1 do
		if data.inventory[i].count > 0 then
			table.insert(Items, {
				label    = data.inventory[i].label,
				right    = data.inventory[i].count,
				value    = data.inventory[i].name,
				itemType = 'item_standard',
				amount   = data.inventory[i].count
			})
		end
	end
end, GetPlayerServerId(player))
end

function menuf7()
    local main = RageUI.CreateMenu("", "Intéractions")
    local main_sub = RageUI.CreateMenu("", "Intéractions")
    local three_sub = RageUI.CreateMenu("", "Intéractions")

        RageUI.Visible(main, not RageUI.Visible(main))
            while main do
            Citizen.Wait(0)
            RageUI.IsVisible(main, true, true, true, function()

        	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

            RageUI.ButtonWithStyle("Vos zones de farm", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
            end, three_sub)

			RageUI.ButtonWithStyle('Fouiller la personne', nil, {RightLabel = "→→"}, closestPlayer ~= -1 and closestDistance <= 3.0, function(_, a, s)
				if a then
					MarquerJoueur()
					if s then
					getPlayerInv(closestPlayer)
					ExecuteCommand("me fouille l'individu")
				end
			end
			end, main_sub)  

            RageUI.ButtonWithStyle("Menotter/démenotter", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    if closestPlayer ~= -1 and closestDistance <= 3.0 then

                    TriggerServerEvent('enos:handcuff', GetPlayerServerId(closestPlayer))
                else
                    RageUI.Popup({message = "~r~[Problème]~s~\nPersonne à proximité"})
                end
                end
            end)

            RageUI.ButtonWithStyle("Escorter", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('enos:drag', GetPlayerServerId(closestPlayer))
            else
                RageUI.Popup({message = "~r~[Problème]~s~\nPersonne à proximité"})
                end
            end
        end)

            RageUI.ButtonWithStyle("Mettre dans un véhicule", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('enos:putInVehicle', GetPlayerServerId(closestPlayer))
            else
                RageUI.Popup({message = "~r~[Problème]~s~\nPersonne à proximité"})
                    end
                end
            end)
            RageUI.ButtonWithStyle("Sortir du véhicule", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                if (Selected) then
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
                TriggerServerEvent('enos:OutVehicle', GetPlayerServerId(closestPlayer))
            else
                RageUI.Popup({message = "~r~[Problème]~s~\nPersonne à proximité"})
            end
            end
        end)

        RageUI.ButtonWithStyle("Crocheter le véhicule", nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
			if Selected then
				local playerPed = PlayerPedId()
				local vehicle = ESX.Game.GetVehicleInDirection()
				local coords = GetEntityCoords(playerPed)
				if IsPedSittingInAnyVehicle(playerPed) then
                    RageUI.Popup({message = "~r~[Problème]~s~\nVous ne pouvez pas faire ça à l'interieur du véhicule"})
					return
				end
				if DoesEntityExist(vehicle) then
					isBusy = true
					TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
					Citizen.CreateThread(function()
						Wait(10000)
						SetVehicleDoorsLocked(vehicle, 1)
						SetVehicleDoorsLockedForAllPlayers(vehicle, false)
						ClearPedTasksImmediately(playerPed)
                        RageUI.Popup({message = "~g~Véhicule Unlocked"})
						isBusy = false
					end)
				else
                    RageUI.Popup({message = "~r~[Problème]~s~\nAucun véhicule proche"})
				end
			end
		end)
        end, function()
        end)
        RageUI.IsVisible(main_sub, true, true, true, function()
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            RageUI.Separator("↓ ~g~Argent Sale ~s~↓")
            for k,v  in pairs(ArgentSale) do
                RageUI.ButtonWithStyle("Argent sale :", nil, {RightLabel = "~g~"..v.label.."$"}, true, function(_, _, s)
                    if s then
                        local combien = KeyboardInput("Combien ?", '' , '', 8)
                        if tonumber(combien) > v.amount then
                            RageUI.Popup({message = "~r~[Problème]~s~\nQuantité invalide"})
                        else
                            TriggerServerEvent('enos:confiscatePlayerItem', GetPlayerServerId(closestPlayer), v.itemType, v.value, tonumber(combien))
                        end
                        RageUI.GoBack()
                    end
                end)
            end
            RageUI.Separator("↓ ~g~Objets ~s~↓")
            for k,v  in pairs(Items) do
                RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "~g~x"..v.right}, true, function(_, _, s)
                    if s then
                        local combien = KeyboardInput("Combien ?", '' , '', 8)
                        if tonumber(combien) > v.amount then
                                 RageUI.Popup({message = "~r~[Problème]~s~\nQuantité invalide"})
                        else
                            TriggerServerEvent('enos:confiscatePlayerItem', GetPlayerServerId(closestPlayer), v.itemType, v.value, tonumber(combien))
                        end
                        RageUI.GoBack()
                    end
                end)
            end
                RageUI.Separator("↓ ~g~Armes ~s~↓")
                for k,v  in pairs(Armes) do
                    RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "avec ~g~"..v.right.. " ~s~balle(s)"}, true, function(_, _, s)
                        if s then
                            local combien = KeyboardInput("Combien ?", '' , '', 8)
                            if tonumber(combien) > v.amount then
                                     RageUI.Popup({message = "~r~[Problème]~s~\nQuantité invalide"})
                            else
                                TriggerServerEvent('enos:confiscatePlayerItem', GetPlayerServerId(closestPlayer), v.itemType, v.value, tonumber(combien))
                            end
                            RageUI.GoBack()
                        end
                    end)
                end
            end, function()
            end)

            RageUI.IsVisible(three_sub, true, true, true, function()

            RageUI.ButtonWithStyle("Récolte Métaux",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then       
                    SetNewWaypoint(Config.metaux.position.x, Config.metaux.position.y, Config.metaux.position.z)
                end
            end)

            RageUI.ButtonWithStyle("Récolte Mèches",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then       
                    SetNewWaypoint(Config.meche.position.x, Config.meche.position.y, Config.meche.position.z)
                end
            end)

            RageUI.ButtonWithStyle("Récolte Canons",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then       
                    SetNewWaypoint(Config.canon.position.x, Config.canon.position.y, Config.canon.position.z)
                end
            end)

            RageUI.ButtonWithStyle("Récolte Leviers",nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then       
                    SetNewWaypoint(Config.levier.position.x, Config.levier.position.y, Config.levier.position.z)
                end
            end)

        end, function()
        end)

            if not RageUI.Visible(main) and not RageUI.Visible(main_sub) and not RageUI.Visible(three_sub) then
            main = RMenu:DeleteType(main, true)
        end
    end
end

Keys.Register('F7', 'Crafter', 'Ouvrir le menu Crafter', function()
	if ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Config.OrgaName then
    	menuf7()
	end
end)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Wait(500) 
        blockinput = false
        return result 
    else
        Wait(500) 
        blockinput = false 
        return nil 
    end
end

RegisterNetEvent('enos:handcuff')
AddEventHandler('enos:handcuff', function()
  IsHandcuffed    = not IsHandcuffed;
  local playerPed = PlayerPedId()
  Citizen.CreateThread(function()
    if IsHandcuffed then
        RequestAnimDict('mp_arresting')
        while not HasAnimDictLoaded('mp_arresting') do
            Wait(100)
        end
      TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
      DisableControlAction(2, 37, true)
      SetEnableHandcuffs(playerPed, true)
      SetPedCanPlayGestureAnims(playerPed, false)
      FreezeEntityPosition(playerPed,  true)
      DisableControlAction(0, 24, true) -- Attack
      DisableControlAction(0, 257, true) -- Attack 2
      DisableControlAction(0, 25, true) -- Aim
      DisableControlAction(0, 263, true) -- Melee Attack 1
      DisableControlAction(0, 37, true) -- Select Weapon
      DisableControlAction(0, 47, true)  -- Disable weapon
      DisplayRadar(false)
    else
      ClearPedSecondaryTask(playerPed)
      SetEnableHandcuffs(playerPed, false)
      SetPedCanPlayGestureAnims(playerPed,  true)
      FreezeEntityPosition(playerPed, false)
      DisplayRadar(true)
    end
  end)
end)
RegisterNetEvent('enos:drag')
AddEventHandler('enos:drag', function(cop)
  TriggerServerEvent('esx:clientLog', 'starting dragging')
  IsDragged = not IsDragged
  CopPed = tonumber(cop)
end)
Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsHandcuffed then
      if IsDragged then
        local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
        local myped = PlayerPedId()
        AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
      else
        DetachEntity(PlayerPedId(), true, false)
      end
    end
  end
end)
RegisterNetEvent('enos:putInVehicle')
AddEventHandler('enos:putInVehicle', function()
  local playerPed = PlayerPedId()
  local coords    = GetEntityCoords(playerPed)
  if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
    local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)
    if DoesEntityExist(vehicle) then
      local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
      local freeSeat = nil
      for i=maxSeats - 1, 0, -1 do
        if IsVehicleSeatFree(vehicle,  i) then
          freeSeat = i
          break
        end
      end
      if freeSeat ~= nil then
        TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
      end
    end
  end
end)
RegisterNetEvent('enos:OutVehicle')
AddEventHandler('enos:OutVehicle', function(t)
  local ped = GetPlayerPed(t)
  ClearPedTasksImmediately(ped)
  plyPos = GetEntityCoords(PlayerPedId(),  true)
  local xnew = plyPos.x+2
  local ynew = plyPos.y+2
  SetEntityCoords(PlayerPedId(), xnew, ynew, plyPos.z)
end)

Citizen.CreateThread(function()
    while true do
        wait = 800
        if IsHandcuffed then
            wait = 0
            DisableControlAction(0, 142, true) -- MeleeAttackAlternate
            DisableControlAction(0, 30,  true) -- MoveLeftRight
            DisableControlAction(0, 31,  true) -- MoveUpDown
        end
        Citizen.Wait(wait)
    end
end)
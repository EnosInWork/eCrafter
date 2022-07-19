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

local playerPed = PlayerPedId()

dansmenu = false

local recoltebb = false

RMenu.Add('recoltebb', 'main', RageUI.CreateMenu("", ""))
RMenu:Get('recoltebb', 'main'):SetSubtitle(Config.PrefixName)

RMenu:Get('recoltebb', 'main').EnableMouse = false
RMenu:Get('recoltebb', 'main').Closed = function()
	dansmenu = false
	recoltebb = false
	TriggerServerEvent('stop:farm')
	FreezeEntityPosition(playerPed, false)
end

local recolteaa = false
RMenu.Add('recolteaa', 'main', RageUI.CreateMenu("", ""))
RMenu:Get('recolteaa', 'main'):SetSubtitle(Config.PrefixName)

RMenu:Get('recolteaa', 'main').EnableMouse = false
RMenu:Get('recolteaa', 'main').Closed = function()
	dansmenu = false
	recolteaa = false
	TriggerServerEvent('stop:farm')
	FreezeEntityPosition(playerPed, false)
end

local recoltecc = false
RMenu.Add('recoltecc', 'main', RageUI.CreateMenu("", ""))
RMenu:Get('recoltecc', 'main'):SetSubtitle(Config.PrefixName)

RMenu:Get('recoltecc', 'main').EnableMouse = false
RMenu:Get('recoltecc', 'main').Closed = function()
	dansmenu = false
	recoltecc = false
	TriggerServerEvent('stop:farm')
	FreezeEntityPosition(playerPed, false)
end

local recoltedefou = false
RMenu.Add('recoltedefou', 'main', RageUI.CreateMenu("", ""))
RMenu:Get('recoltedefou', 'main'):SetSubtitle(Config.PrefixName)

RMenu:Get('recoltedefou', 'main').EnableMouse = false
RMenu:Get('recoltedefou', 'main').Closed = function()
	dansmenu = false
	recoltedefou = false
	TriggerServerEvent('stop:farm')
	FreezeEntityPosition(playerPed, false)
end

function recoltem()
	if not recoltebb then
		recoltebb = true
		RageUI.Visible(RMenu:Get('recoltebb', 'main'), true)
	Citizen.CreateThread(function()
		while recoltebb do
			Wait(1)

				RageUI.IsVisible(RMenu:Get('recoltebb', 'main'), true, true, true, function()

					FreezeEntityPosition(playerPed, false)

					if dansmenu then
							FreezeEntityPosition(playerPed, true)
						RageUI.ButtonWithStyle("Récolter des métaux", nil, { RightBadge = RageUI.BadgeStyle.Lock }, false, function(Hovered, Active, Selected)     
							if (Selected) then
							end
						  end)
		
						else 

					RageUI.ButtonWithStyle("Récolter des métaux", nil, {RightLabel = "→"}, not cooldown, function(Hovered, Active, Selected) 
						if (Selected) then
							dansmenu = true 
							TriggerServerEvent('start:farm1')
							FreezeEntityPosition(playerPed, true)
							cooldown = true
							Citizen.SetTimeout(10000,function()
								cooldown = false
							    end)
						    end 
					    end)
				    end
				end)
			end
		end)
	end
end

function recoltemeche()
	if not recolteaa then
		recolteaa = true
		RageUI.Visible(RMenu:Get('recolteaa', 'main'), true)
	Citizen.CreateThread(function()
		while recolteaa do
			Wait(1)

				RageUI.IsVisible(RMenu:Get('recolteaa', 'main'), true, true, true, function()

					FreezeEntityPosition(playerPed, false)

					if dansmenu then
							FreezeEntityPosition(playerPed, true)
						RageUI.ButtonWithStyle("Récolter des mèches", nil, { RightBadge = RageUI.BadgeStyle.Lock }, false, function(Hovered, Active, Selected)     
							if (Selected) then
							end
						  end)
		
						else 

					RageUI.ButtonWithStyle("Récolter des mèches", nil, {RightLabel = "→"}, not cooldown, function(Hovered, Active, Selected) 
						if (Selected) then
							dansmenu = true 
							TriggerServerEvent('start:farm2')
							FreezeEntityPosition(playerPed, true)
							cooldown = true
							Citizen.SetTimeout(10000,function()
								cooldown = false
							    end)
						    end 
					    end)
				    end
				end)
			end
		end)
	end
end

function recoltecanon()
	if not recoltecc then
		recoltecc = true
		RageUI.Visible(RMenu:Get('recoltecc', 'main'), true)
	Citizen.CreateThread(function()
		while recoltecc do
			Wait(1)

				RageUI.IsVisible(RMenu:Get('recoltecc', 'main'), true, true, true, function()

					FreezeEntityPosition(playerPed, false)

					if dansmenu then
							FreezeEntityPosition(playerPed, true)
						RageUI.ButtonWithStyle("Récolter des canons", nil, { RightBadge = RageUI.BadgeStyle.Lock }, false, function(Hovered, Active, Selected)     
							if (Selected) then
							end
						  end)
		
						else 

					RageUI.ButtonWithStyle("Récolter des canons", nil, {RightLabel = "→"}, not cooldown, function(Hovered, Active, Selected) 
						if (Selected) then
							dansmenu = true 
							TriggerServerEvent('start:farmC')
							FreezeEntityPosition(playerPed, true)
							cooldown = true
							Citizen.SetTimeout(10000,function()
								cooldown = false
							    end)
						    end 
					    end)
				    end
				end)
			end
		end)
	end
end

function recoltelevier()
	if not recoltedefou then
		recoltedefou = true
		RageUI.Visible(RMenu:Get('recoltedefou', 'main'), true)
	Citizen.CreateThread(function()
		while recoltedefou do
			Wait(1)

				RageUI.IsVisible(RMenu:Get('recoltedefou', 'main'), true, true, true, function()

					FreezeEntityPosition(playerPed, false)

					if dansmenu then
							FreezeEntityPosition(playerPed, true)
						RageUI.ButtonWithStyle("Récolter des levier", nil, { RightBadge = RageUI.BadgeStyle.Lock }, false, function(Hovered, Active, Selected)     
							if (Selected) then
							end
						  end)
		
						else 

					RageUI.ButtonWithStyle("Récolter des levier", nil, {RightLabel = "→"}, not cooldown, function(Hovered, Active, Selected) 
						if (Selected) then
							dansmenu = true
							TriggerServerEvent('start:farm4')
							FreezeEntityPosition(playerPed, true)
							cooldown = true
							Citizen.SetTimeout(10000,function()
								cooldown = false
							    end)
						    end 
					    end)
				    end
				end)
			end
		end)
	end
end

Citizen.CreateThread(function()
    while true do
        Waiting = 800
        local plyCoords3 = GetEntityCoords(PlayerPedId(), false)
        local Dist_Met = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Config.metaux.position.x, Config.metaux.position.y, Config.metaux.position.z)
        local Dist_Mech = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Config.meche.position.x, Config.meche.position.y, Config.meche.position.z)
        local Dist_Canon = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Config.canon.position.x, Config.canon.position.y, Config.canon.position.z)
        local Dist_Levier = Vdist(plyCoords3.x, plyCoords3.y, plyCoords3.z, Config.levier.position.x, Config.levier.position.y, Config.levier.position.z)

        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.OrgaName or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Config.OrgaName then 

            if Dist_Met <= 15.0 then
				Waiting = 0
				DrawMarker(Config.Marker.Type, Config.metaux.position.x, Config.metaux.position.y, Config.metaux.position.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
            end

            if Dist_Met <= 1.0 then 
				Waiting = 0  
				RageUI.Text({ message = "Appuyez sur ~m~[E]~s~ pour ouvrir →→ ~m~Récolte Métaux", time_display = 1 })
				if IsControlJustPressed(1,51) then           
					recoltem()
				end   
            end

            if Dist_Mech <= 15.0 then
				DrawMarker(Config.Marker.Type, Config.meche.position.x, Config.meche.position.y, Config.meche.position.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)
            end

            if Dist_Mech <= 1.0 then   
				RageUI.Text({ message = "Appuyez sur ~m~[E]~s~ pour ouvrir →→ ~m~Récolte Mèches", time_display = 1 })
				if IsControlJustPressed(1,51) then           
					recoltemeche()
				end   
            end

			if Dist_Canon <= 15.0 then
				DrawMarker(Config.Marker.Type, Config.canon.position.x, Config.canon.position.y, Config.canon.position.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)

            end

            if Dist_Canon <= 1.0 then   
				RageUI.Text({ message = "Appuyez sur ~m~[E]~s~ pour ouvrir →→ ~m~Récolte Canons", time_display = 1 })
				if IsControlJustPressed(1,51) then           
					recoltecanon()
				end   
            end

			if Dist_Levier <= 15.0 then
				DrawMarker(Config.Marker.Type, Config.levier.position.x, Config.levier.position.y, Config.levier.position.z-0.99, nil, nil, nil, -90, nil, nil, Config.Marker.Size.x, Config.Marker.Size.y, Config.Marker.Size.z, Config.Marker.Color.R, Config.Marker.Color.G, Config.Marker.Color.B, 200)

            end

            if Dist_Levier <= 1.0 then   
				RageUI.Text({ message = "Appuyez sur ~m~[E]~s~ pour ouvrir →→ ~m~Récolte Leviers", time_display = 1 })
				if IsControlJustPressed(1,51) then           
					recoltelevier()
				end   
            end

        end 
		Citizen.Wait(Waiting)
    end
end)

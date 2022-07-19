ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function eLogsDiscord(message,url)
    local DiscordWebHook = url
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({username = Config.logs.NameLogs, content = message}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('eCrafter:CreateWeapon')
AddEventHandler('eCrafter:CreateWeapon', function(itemName, materiaux)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)

	if xPlayer.getInventoryItem(materiaux[1].name).count >= materiaux[1].amout and xPlayer.getInventoryItem(materiaux[2].name).count >= materiaux[2].amout then

		TriggerClientEvent('eCrafter:animationCreateWeapon', _src)

        Citizen.Wait(Config.WaitForReceive) 

		for k,v in pairs(materiaux) do
			xPlayer.removeInventoryItem(v.name, v.amout)
		end

        if Config.WeaponItem == true then 
            xPlayer.addInventoryItem(itemName, 1)
            eLogsDiscord("[Craft] **"..xPlayer.getName().."** a craft et reçu x1 "..itemName.." via la table de craft", Config.logs.Craft)
        else
		    xPlayer.addWeapon(itemName, 1)
            eLogsDiscord("[Craft] **"..xPlayer.getName().."** a craft et reçu x1 "..itemName.." via la table de craft", Config.logs.Craft)
        end

	else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nIl vous manque des matériaux !")
	end

end)

RegisterServerEvent('enos:handcuff')
AddEventHandler('enos:handcuff', function(target)
    TriggerClientEvent('enos:handcuff', target)
end)

RegisterServerEvent('enos:drag')
AddEventHandler('enos:drag', function(target)
  local _source = source
    TriggerClientEvent('enos:drag', target, _source)
end)

RegisterServerEvent('enos:putInVehicle')
AddEventHandler('enos:putInVehicle', function(target)
    TriggerClientEvent('enos:putInVehicle', target)
end)

RegisterServerEvent('enos:OutVehicle')
AddEventHandler('enos:OutVehicle', function(target)
    TriggerClientEvent('enos:OutVehicle', target)
end)



ESX.RegisterServerCallback('enos:getOtherPlayerData', function(source, cb, target, notify)
  local xPlayer = ESX.GetPlayerFromId(target)

  TriggerClientEvent("esx:showNotification", target, "~r~Quelqu'un vous fouille ...")

  if xPlayer then
      local data = {
          name = xPlayer.getName(),
          job = xPlayer.job.label,
          grade = xPlayer.job.grade_label,
          inventory = xPlayer.getInventory(),
          accounts = xPlayer.getAccounts(),
          weapons = xPlayer.getLoadout()
      }

      cb(data)
  end
end)

RegisterNetEvent('enos:confiscatePlayerItem')
AddEventHandler('enos:confiscatePlayerItem', function(target, itemType, itemName, amount)
  local _source = source
  local sourceXPlayer = ESX.GetPlayerFromId(_source)
  local targetXPlayer = ESX.GetPlayerFromId(target)

  if itemType == 'item_standard' then
      local targetItem = targetXPlayer.getInventoryItem(itemName)
  local sourceItem = sourceXPlayer.getInventoryItem(itemName)
  
    targetXPlayer.removeInventoryItem(itemName, amount)
    sourceXPlayer.addInventoryItem  (itemName, amount)
          TriggerClientEvent("esx:showNotification", source, "Vous avez confisqué ~b~"..amount..' '..sourceItem.label.."~s~.")
          TriggerClientEvent("esx:showNotification", target, "Quelqu'un vous a pris ~b~"..amount..' '..sourceItem.label.."~s~.")
      else
    TriggerClientEvent("esx:showNotification", source, "~r~Quantité invalide")
  end
      
  if itemType == 'item_account' then
      targetXPlayer.removeAccountMoney(itemName, amount)
      sourceXPlayer.addAccountMoney   (itemName, amount)
      
      TriggerClientEvent("esx:showNotification", source, "Vous avez confisqué ~b~"..amount.." d' "..itemName.."~s~.")
      TriggerClientEvent("esx:showNotification", target, "Quelqu'un vous aconfisqué ~b~"..amount.." d' "..itemName.."~s~.")
      
  elseif itemType == 'item_weapon' then
      if amount == nil then amount = 0 end
      targetXPlayer.removeWeapon(itemName, amount)
      sourceXPlayer.addWeapon   (itemName, amount)

      TriggerClientEvent("esx:showNotification", source, "Vous avez confisqué ~b~"..ESX.GetWeaponLabel(itemName).."~s~ avec ~b~"..amount.."~s~ balle(s).")
      TriggerClientEvent("esx:showNotification", target, "Quelqu'un vous a confisqué ~b~"..ESX.GetWeaponLabel(itemName).."~s~ avec ~b~"..amount.."~s~ balle(s).")
  end
end)

PlayersHarvesting  = {}
PlayersHarvesting2 = {}
PlayersHarvesting3 = {}

function HarvestMet(source)
    if PlayersHarvesting[source] == true then
        local xPlayer = ESX.GetPlayerFromId(source)
        local metQuantity = xPlayer.getInventoryItem('metaux').count

        if metQuantity >= 100 then
            TriggerClientEvent('esx:showNotification', source, "[~r~Problème~s~] Vous en porter déjà trop")
        else
            SetTimeout(1800, function()
            xPlayer.addInventoryItem('metaux', 1)
            eLogsDiscord("[Récolte] **"..xPlayer.getName().."** a récolter x1 Métaux", Config.logs.Recolte)
            HarvestMet(source)
            end)
        end
    end
end

function Harvest2(source)
    if PlayersHarvesting[source] == true then
        local xPlayer = ESX.GetPlayerFromId(source)
        local mechQuantity = xPlayer.getInventoryItem('meche').count
        if mechQuantity >= 100 then
            TriggerClientEvent('esx:showNotification', source, "[~r~Problème~s~] Vous en porter déjà trop")
        else
            SetTimeout(1800, function()
            xPlayer.addInventoryItem('meche', 1)
            eLogsDiscord("[Récolte] **"..xPlayer.getName().."** a récolter x1 Mèche", Config.logs.Recolte)
            Harvest2(source)
            end)
        end
    end
end

function HarvestC(source)
    if PlayersHarvesting[source] == true then
        local xPlayer = ESX.GetPlayerFromId(source)
        local canQuantity = xPlayer.getInventoryItem('canon').count

        if canQuantity >= 100 then
                 TriggerClientEvent('esx:showNotification', source, "[~r~Problème~s~] Vous en porter déjà trop")
        else
            SetTimeout(1800, function()
            xPlayer.addInventoryItem('canon', 1)
            eLogsDiscord("[Récolte] **"..xPlayer.getName().."** a récolter x1 Canon", Config.logs.Recolte)
            HarvestC(source)
            end)
        end
    end
end

function Harvest4(source)
    if PlayersHarvesting[source] == true then
        local xPlayer = ESX.GetPlayerFromId(source)
        local levQuantity = xPlayer.getInventoryItem('levier').count

        if levQuantity >= 100 then
                 TriggerClientEvent('esx:showNotification', source, "[~r~Problème~s~] Vous en porter déjà trop")
        else
            SetTimeout(1800, function()
            xPlayer.addInventoryItem('levier', 1)
            eLogsDiscord("[Récolte] **"..xPlayer.getName().."** a récolter x1 levier", Config.logs.Recolte)
            Harvest4(source)
            end)
        end
    end
end

RegisterServerEvent('start:farm1')
AddEventHandler('start:farm1', function()
    local _source = source
    PlayersHarvesting[_source] = true
    TriggerClientEvent('esx:showNotification', _source, 'Récupération...')
    HarvestMet(source)
end)

RegisterServerEvent('start:farm2')
AddEventHandler('start:farm2', function()
    local _source = source
    PlayersHarvesting[_source] = true
    TriggerClientEvent('esx:showNotification', _source, 'Récupération...')
    Harvest2(source)
end)

RegisterServerEvent('start:farmC')
AddEventHandler('start:farmC', function()
    local _source = source
    PlayersHarvesting[_source] = true
    TriggerClientEvent('esx:showNotification', _source, 'Récupération...')
    HarvestC(source)
end)

RegisterServerEvent('start:farm4')
AddEventHandler('start:farm4', function()
    local _source = source
    PlayersHarvesting[_source] = true
    TriggerClientEvent('esx:showNotification', _source, 'Récupération...')
    Harvest4(source)
end)

RegisterServerEvent('stop:farm')
AddEventHandler('stop:farm', function()
	local _source = source
	-- Harvest
	PlayersHarvesting[_source] = false
	PlayersHarvesting2[_source] = false
	PlayersHarvesting3[_source] = false
end)

ESX.RegisterServerCallback('Coffre:GetStock', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', Config.OrgaSocietyName, function(inventory)
		cb(inventory.items)
	end)
end)


RegisterNetEvent('Coffre:GetStockI')
AddEventHandler('Coffre:GetStockI', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', Config.OrgaSocietyName, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- is there enough in the society?
		if count > 0 and inventoryItem.count >= count then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, '<C>Objet retirer', count, inventoryItem.label)
				eLogsDiscord("[COFFRE] "..xPlayer.getName().." a retiré "..count.." "..inventoryItem.label.." du coffre", Config.logs.CoffreObjets)
		else
            TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nQuantité invalide")
		end
	end)
end)

RegisterNetEvent('Coffre:putStockItems')
AddEventHandler('Coffre:putStockItems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', Config.OrgaSocietyName, function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		-- does the player have enough of the item?
		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', _source, "~g~Objet déposer "..count..""..inventoryItem.label.."")
			eLogsDiscord("[COFFRE] "..xPlayer.getName().." a déposé "..count.." "..inventoryItem.label.." dans le coffre", Config.logs.CoffreObjets)
		else
            TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nQuantité invalide")
		end
	end)
end)

ESX.RegisterServerCallback('Coffre:getArmoryWeapons', function(source, cb)
	TriggerEvent('esx_datastore:getSharedDataStore', Config.OrgaSocietyName, function(store)
		local weapons = store.get('weapons')

		if weapons == nil then
			weapons = {}
		end
		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('Coffre:ddArmoryWeapon', function(source, cb, weaponName, removeWeapon)
	local xPlayer = ESX.GetPlayerFromId(source)

	if removeWeapon then
		xPlayer.removeWeapon(weaponName)
		eLogsDiscord("[COFFRE ARMES] "..xPlayer.getName().." a déposé "..weaponName.." du coffre", Config.logs.CoffreArmes)
	end

	TriggerEvent('esx_datastore:getSharedDataStore', Config.OrgaSocietyName, function(store)
		local weapons = store.get('weapons') or {}
		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = weapons[i].count + 1
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name  = weaponName,
				count = 1
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

ESX.RegisterServerCallback('eCrafter:removeArmoryWeapon', function(source, cb, weaponName)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addWeapon(weaponName, 0)
	eLogsDiscord("[COFFRE ARMES] "..xPlayer.getName().." a retiré "..weaponName.." du coffre", Config.logs.CoffreArmes)

	TriggerEvent('esx_datastore:getSharedDataStore', Config.OrgaSocietyName, function(store)
		local weapons = store.get('weapons') or {}

		local foundWeapon = false

		for i=1, #weapons, 1 do
			if weapons[i].name == weaponName then
				weapons[i].count = (weapons[i].count > 0 and weapons[i].count - 1 or 0)
				foundWeapon = true
				break
			end
		end

		if not foundWeapon then
			table.insert(weapons, {
				name = weaponName,
				count = 0
			})
		end

		store.set('weapons', weapons)
		cb()
	end)
end)

ESX.RegisterServerCallback('eCrafter:getPlayerInventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

RegisterServerEvent('eCrafter:recruter')
AddEventHandler('eCrafter:recruter', function(target)

  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(target)

  
  if job2 == false then
  	if xPlayer.job.grade_name == 'boss' then
  	xTarget.setJob(Config.OrgaName, 0)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Le joueur a bien été recruté")
  	TriggerClientEvent('esx:showNotification', target, "<C>Bienvenue chez les "..Config.PrefixName.." !")
	  eLogsDiscord("[RECRUTEMENT] **"..xPlayer.getName().."** a recruté **"..xTarget.getName().."**", Config.logs.Boss)
  	else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nVous n'êtes pas patron")
end
  else
  	if xPlayer.job2.grade_name == 'boss' then
  	xTarget.setJob2(Config.OrgaName, 0)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Le joueur a bien été recruté")
      TriggerClientEvent('esx:showNotification', target, "<C>Bienvenue chez les "..Config.PrefixName.." !")
	  eLogsDiscord("[RECRUTEMENT] **"..xPlayer.getName().."** a recruté **"..xTarget.getName().."**", Config.logs.Boss)
  	else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nVous n'êtes pas patron")
end
  end
end)

RegisterServerEvent('eCrafter:promouvoir')
AddEventHandler('eCrafter:promouvoir', function(target)

  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(target)

  
  if job2 == false then
  	if xPlayer.job.grade_name == 'boss' and xPlayer.job.name == xTarget.job.name then
  	xTarget.setJob(Config.OrgaName, tonumber(xTarget.job.grade) + 1)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Le joueur a bien été promu")
  	TriggerClientEvent('esx:showNotification', target, "~g~Vous avez été promu chez les EMS!")
	  eLogsDiscord("[PROMOTION] **"..xPlayer.getName().."** a promu **"..xTarget.getName().."**", Config.logs.Boss)
  	else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nVous n'êtes pas patron ou le joueur ne peux être promu")
end
  else
  	if xPlayer.job2.grade_name == 'boss' and xPlayer.job2.name == xTarget.job2.name then
  	xTarget.setJob2(Config.OrgaName, tonumber(xTarget.job2.grade) + 1)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "~g~Le joueur a bien été promu")
  	TriggerClientEvent('esx:showNotification', target, "~g~Vous avez été promu chez les EMS!")
	  eLogsDiscord("[PROMOTION] **"..xPlayer.getName().."** a promu **"..xTarget.getName().."**", Config.logs.Boss)
  	else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nVous n'êtes pas patron ou le joueur ne peux être promu")
end
  end
end)

RegisterServerEvent('eCrafter:descendre')
AddEventHandler('eCrafter:descendre', function(target)

  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(target)

  
  if job2 == false then
  	if xPlayer.job.grade_name == 'boss' and xPlayer.job.name == xTarget.job.name then
  	xTarget.setJob(Config.OrgaName, tonumber(xTarget.job.grade) - 1)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "~o~Le joueur a bien été rétrograder")
  	TriggerClientEvent('esx:showNotification', target, "~o~Vous avez été rétrogradé des "..Config.PrefixName.."!")
	  eLogsDiscord("[RETROGRADE] **"..xPlayer.getName().."** a rétrogradé **"..xTarget.getName().."**", Config.logs.Boss)
  	else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nVous n'êtes pas patron ou le joueur ne peux être descendu plus")
end
  else
  	if xPlayer.job2.grade_name == 'boss' and xPlayer.job2.name == xTarget.job2.name then
  	xTarget.setJob2(Config.OrgaName, tonumber(xTarget.job2.grade) - 1)
  	TriggerClientEvent('esx:showNotification', xPlayer.source, "~o~Le joueur a bien été rétrograder")
  	TriggerClientEvent('esx:showNotification', target, "~o~Vous avez été rétrogradé des "..Config.PrefixName.."!")
	  eLogsDiscord("[RETROGRADE] **"..xPlayer.getName().."** a rétrogradé **"..xTarget.getName().."**", Config.logs.Boss)
  	else
        TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nVous n'êtes pas patron ou le joueur ne peux être descendu plus")
    end
  end
end)

RegisterServerEvent('eCrafter:virer')
AddEventHandler('eCrafter:virer', function(target)
  local xPlayer = ESX.GetPlayerFromId(source)
  local xTarget = ESX.GetPlayerFromId(target)
  
  if job2 == false then
        if xPlayer.job.grade_name == 'boss' and xPlayer.job.name == xTarget.job.name then
            xTarget.setJob("unemployed", 0)
            TriggerClientEvent('esx:showNotification', xPlayer.source, "~o~Le joueur a bien été destituer")
            TriggerClientEvent('esx:showNotification', target, "Vous avez été viré des "..Config.PrefixName.."!")
            eLogsDiscord("[Exclusion] **"..xPlayer.getName().."** a viré **"..xTarget.getName().."**", Config.logs.Boss)
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nVous n'êtes pas patron ou le joueur ne peux être destituer")
        end
    else
        if xPlayer.job2.grade_name == 'boss' and xPlayer.job2.name == xTarget.job2.name then
            xTarget.setJob2("unemployed2", 0)
            TriggerClientEvent('esx:showNotification', xPlayer.source, "~o~Le joueur a bien été destituer")
            TriggerClientEvent('esx:showNotification', target, "Vous avez été viré des "..Config.PrefixName.."!")
            eLogsDiscord("[Exclusion] **"..xPlayer.getName().."** a viré **"..xTarget.getName().."**", Config.logs.Boss)
  	    else
	        TriggerClientEvent('esx:showNotification', xPlayer.source, "[~r~Problème~s~]\nVous n'êtes pas patron ou le joueur ne peux être destituer")
        end
    end
end)

RegisterServerEvent("eCrafter:retraitentreprise")
AddEventHandler("eCrafter:retraitentreprise", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	local xMoney = xPlayer.getAccount("bank").money

    TriggerEvent('esx_addonaccount:getSharedAccount', Config.OrgaSocietyName, function (account)
		if account.money >= total then
			account.removeMoney(total)
			xPlayer.addAccountMoney('bank', total)
			TriggerClientEvent('esx:showAdvancedNotification', source, 'Organisation', '~o~Vendeur', "~g~Vous avez retiré "..total.." $ de votre organisation", 'CHAR_BANK_FLEECA', 10)
            eLogsDiscord("[Retrait] **"..xPlayer.getName().."** a retirer **"..total.."** de l'organisation", Config.logs.Boss)
		else
            TriggerClientEvent('esx:showNotification', source, "[~r~Problème~s~]\nVous n'avez pas assez d'argent dans votre entreprise")
		end
	end)
end) 
  
RegisterServerEvent("eCrafter:depotentreprise")
AddEventHandler("eCrafter:depotentreprise", function(money)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total = money
    local xMoney = xPlayer.getMoney()
    
    TriggerEvent('esx_addonaccount:getSharedAccount', Config.OrgaSocietyName, function (account)
        if xMoney >= total then
            account.addMoney(total)
            xPlayer.removeAccountMoney('bank', total)
            TriggerClientEvent('esx:showAdvancedNotification', source, 'Organisation', '~o~Vendeur', "~g~Vous avez déposé "..total.." $ dans votre organisation", 'CHAR_BANK_FLEECA', 10)
            eLogsDiscord("[Dépot] **"..xPlayer.getName().."** a déposer **"..total.."** de l'organisation", Config.logs.Boss)
        else
            TriggerClientEvent('esx:showNotification', source, "[~r~Problème~s~]\nVous n'avez pas assez d'argent")
        end
    end)   
end)

ESX.RegisterServerCallback('eCrafter:getSocietyMoney', function(source, cb, societyName)
	if societyName ~= nil then
	  local society = Config.SocietyName
	  TriggerEvent('esx_addonaccount:getSharedAccount', Config.OrgaSocietyName, function(account)
		cb(account.money)
	  end)
	else
	  cb(0)
	end
end)
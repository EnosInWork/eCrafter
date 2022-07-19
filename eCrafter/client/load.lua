local dragStatus = {}
local IsHandcuffed = false
dragStatus.isDragged = false
local PlayerData, GUI, CurrentActionData, JobBlips = {}, {}, {}, {}
local publicBlip = false

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

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	blips()
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
    blips()
end)

Citizen.CreateThread(function()
    local vendeurmap = AddBlipForCoord(-1538.41, 128.88, 21.1)
    SetBlipSprite(vendeurmap, 429)
    SetBlipColour(vendeurmap, 0)
    SetBlipScale(vendeurmap, 0.6)
    SetBlipAsShortRange(vendeurmap, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString("Maison")
    EndTextCommandSetBlipName(vendeurmap)
end)

function blips()
	Citizen.CreateThread(function()
        if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.OrgaName or ESX.PlayerData.job2 and ESX.PlayerData.job2.name == Config.OrgaName then 
            local enostropbg = AddBlipForCoord(Config.metaux.position.x, Config.metaux.position.y, Config.metaux.position.z)
            SetBlipSprite(enostropbg, 233)
            SetBlipColour(enostropbg, 3)
            SetBlipScale(enostropbg, 0.6)
            SetBlipAsShortRange(enostropbg, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString("Récolte Métaux")
            EndTextCommandSetBlipName(enostropbg)

            local omgenostropfort = AddBlipForCoord(Config.meche.position.x, Config.meche.position.y, Config.meche.position.z)
            SetBlipSprite(omgenostropfort, 233)
            SetBlipColour(omgenostropfort, 3)
            SetBlipScale(omgenostropfort, 0.6)
            SetBlipAsShortRange(omgenostropfort, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString("Récolte Mèche")
            EndTextCommandSetBlipName(omgenostropfort)

            local saluttwa = AddBlipForCoord(Config.canon.position.x, Config.canon.position.y, Config.canon.position.z)
            SetBlipSprite(saluttwa, 233)
            SetBlipColour(saluttwa, 3)
            SetBlipScale(saluttwa, 0.6)
            SetBlipAsShortRange(saluttwa, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString("Récolte Canon")
            EndTextCommandSetBlipName(saluttwa)

            local arabg = AddBlipForCoord(Config.levier.position.x, Config.levier.position.y, Config.levier.position.z)
            SetBlipSprite(arabg, 233)
            SetBlipColour(arabg, 3)
            SetBlipScale(arabg, 0.6)
            SetBlipAsShortRange(arabg, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString("Récolte Levier")
            EndTextCommandSetBlipName(arabg)
        end
	end)
end

Citizen.CreateThread(function()
    local hash = GetHashKey(Config.PedList.Type)
    
    while not HasModelLoaded(hash) do
        RequestModel(hash)
        Wait(20)
    end
    
    for k,v in pairs(Config.PedList) do
        ped = CreatePed("PED_TYPE_CIVFEMALE", Config.PedList.Type, v.pos, v.h, true, true)
    end

    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)

end)


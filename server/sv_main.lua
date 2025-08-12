ESX = exports["es_extended"]:getSharedObject()
local Config = require 'config.config'

local waitTime = Config.intervalBetweenAirdrops * 60000
local loc = nil
local looted = false

CreateThread(function()
    while true do
        Wait(waitTime)
        looted = false
        TriggerClientEvent("insane-airdrop:client:clearStuff", -1)
        local randomloc = math.random(1, #Config.Locs)
        loc = Config.Locs[randomloc]
        TriggerClientEvent("insane-airdrop:client:startAirdrop", -1, loc)
    end
end)

RegisterNetEvent("insane-airdrop:server:sync:loot", function() looted = true end)

RegisterNetEvent("insane-airdrop:server:getLoot", function()
    local src = source
    if not looted then return end
    if #(loc - GetEntityCoords(GetPlayerPed(src))) > 10 then
        DropPlayer(src, "Няма да мамиш!")
        return
    end

    local Player = ESX.GetPlayerFromId(src)
    for i = 1, Config.amountOfItems, 1 do
        local randItem = Config.LootTable[math.random(1, #Config.LootTable)]
        Player.addInventoryItem(randItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', src,
                           ESX.GetItemLabel(randItem), 'add')
        Wait(500)
    end
    Wait(Config.timetodeletebox * 60000)
    TriggerClientEvent("insane-airdrop:client:clearStuff", -1)
end)

lib.callback.register('insane-airdrop:server:getLootState',
function() return looted end)

RegisterCommand("test", function(source, args, rawCommand)
    looted = false
    TriggerClientEvent("insane-airdrop:client:clearStuff", -1)
    local randomloc = math.random(1, #Config.Locs)
    loc = Config.Locs[randomloc]

    TriggerClientEvent("insane-airdrop:client:startAirdrop", -1, loc)
end)

local Config = require('config.config')

if Config.Framework == 'ESX' then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

RegisterNetEvent('mcr_scrapyard:rewardPlayer', function()
    local src = source
    local reward = Config.RewardsItems[1] -- lze rozšířit na více itemů
    local count = math.random(reward.min, reward.max)
    if Config.Framework == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.addInventoryItem(reward.item, count)
        end
    elseif Config.Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            Player.Functions.AddItem(reward.item, count)
        end
    end
end)

lib.callback.register('mcr_scrapyard:getOnlineCops', function(source)
    local count = 0
    if Config.Framework == 'ESX' then
        for _, playerId in ipairs(GetPlayers()) do
            local xPlayer = ESX.GetPlayerFromId(tonumber(playerId))
            if xPlayer and xPlayer.job and xPlayer.job.name then
                for _, job in ipairs(Config.PoliceJobs) do
                    if xPlayer.job.name == job then
                        count = count + 1
                    end
                end
            end
        end
    elseif Config.Framework == 'qbcore' then
        for _, playerId in ipairs(GetPlayers()) do
            local Player = QBCore.Functions.GetPlayer(tonumber(playerId))
            if Player and Player.PlayerData and Player.PlayerData.job and Player.PlayerData.job.name then
                for _, job in ipairs(Config.PoliceJobs) do
                    if Player.PlayerData.job.name == job then
                        count = count + 1
                    end
                end
            end
        end
    end
    return count
end) 
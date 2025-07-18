local Config = require('config.config')
local sendDispatchNotification = require('config.cl_edits').sendDispatchNotification

if Config.Framework == 'ESX' then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

local function isInMarker(coords, loc)
    local dist = #(vector3(coords.x, coords.y, coords.z) - vector3(loc.x, loc.y, loc.z))
    local scale = Config.MarkerSettings.scale or {x = 6.0, y = 6.0, z = 2.0}
    return dist < math.max(scale.x, scale.y)
end

local function getClosestScrapyard()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    for _, loc in ipairs(Config.ScrapyardLocations) do
        if isInMarker(coords, loc) then
            return loc
        end
    end
    return nil
end

local dismantledParts = {}

local function getVehicleParts(vehicle)
    local parts = {}
    local vehId = VehToNet(vehicle)
    dismantledParts[vehId] = dismantledParts[vehId] or {}
    local removed = dismantledParts[vehId]
    local L = Config.Locales
    -- Doors
    local numDoors = GetNumberOfVehicleDoors(vehicle)
    if numDoors >= 2 then
        if not removed["door0"] then parts[#parts+1] = {label = L.disassemble_front_left_door, type = 'door', index = 0, key = 'door0', bone = 'door_dside_f'} end
        if not removed["door1"] then parts[#parts+1] = {label = L.disassemble_front_right_door, type = 'door', index = 1, key = 'door1', bone = 'door_pside_f'} end
    end
    if numDoors >= 4 then
        if not removed["door2"] then parts[#parts+1] = {label = L.disassemble_rear_left_door, type = 'door', index = 2, key = 'door2', bone = 'door_dside_r'} end
        if not removed["door3"] then parts[#parts+1] = {label = L.disassemble_rear_right_door, type = 'door', index = 3, key = 'door3', bone = 'door_pside_r'} end
    end
    -- Hood
    if DoesVehicleHaveDoor(vehicle, 4) and not removed["hood"] then
        parts[#parts+1] = {label = L.disassemble_hood, type = 'door', index = 4, key = 'hood', bone = 'bonnet'}
    end
    -- Trunk
    if DoesVehicleHaveDoor(vehicle, 5) and not removed["trunk"] then
        parts[#parts+1] = {label = L.disassemble_trunk, type = 'door', index = 5, key = 'trunk', bone = 'boot'}
    end
    -- Wheels
    local numWheels = GetVehicleNumberOfWheels(vehicle)
    local wheelMap = {
        [1] = {label = L.disassemble_front_left_wheel, bone = 'wheel_lf', index = 0, key = 'wheel0'},
        [2] = {label = L.disassemble_front_right_wheel, bone = 'wheel_rf', index = 1, key = 'wheel1'},
        [3] = {label = L.disassemble_rear_left_wheel, bone = 'wheel_lr', index = 2, key = 'wheel2'},
        [4] = {label = L.disassemble_rear_right_wheel, bone = 'wheel_rr', index = 3, key = 'wheel3'},
    }
    for i = 1, math.min(numWheels, 4) do
        local w = wheelMap[i]
        if IsVehicleTyreBurst(vehicle, w.index, false) == false and not removed[w.key] then
            parts[#parts+1] = {label = w.label, type = 'wheel', index = w.index, key = w.key, bone = w.bone}
        end
    end
    return parts
end

local addTargetToVehicle
local disassemblePart

local function areAllPartsDismantled(vehicle)
    local vehId = VehToNet(vehicle)
    dismantledParts[vehId] = dismantledParts[vehId] or {}
    local removed = dismantledParts[vehId]
    local numDoors = GetNumberOfVehicleDoors(vehicle)
    if numDoors >= 2 then
        if not removed["door0"] or not removed["door1"] then return false end
    end
    if numDoors >= 4 then
        if not removed["door2"] or not removed["door3"] then return false end
    end
    if DoesVehicleHaveDoor(vehicle, 4) and not removed["hood"] then return false end
    if DoesVehicleHaveDoor(vehicle, 5) and not removed["trunk"] then return false end
    for i = 0, 3 do
        local key = 'wheel'..i
        if IsVehicleTyreBurst(vehicle, i, false) == false and not removed[key] then return false end
    end
    return true
end

local function disassembleVehicleFinal(vehicle)
    local playerPed = PlayerPedId()
    sendDispatchNotification()
    TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_CLIPBOARD', 0, true)
    local success = lib.progressBar({
        duration = Config.ProgressBarDuration or 7500,
        label = Config.Locales.disassembling_vehicle or 'Rozebírání vozidla...'
    })
    ClearPedTasks(playerPed)
    if success then
        if DoesEntityExist(vehicle) then
            DeleteEntity(vehicle)
        end
        TriggerServerEvent('mcr_scrapyard:rewardPlayer', true)
    end
end

addTargetToVehicle = function(vehicle)
    if Config.Target == 'ox_target' then
        if exports.ox_target and exports.ox_target.removeLocalEntity then
            exports.ox_target:removeLocalEntity(vehicle)
        end
    elseif Config.Target == 'qb-target' then
        if exports['qb-target'] and exports['qb-target'].RemoveTargetEntity then
            exports['qb-target']:RemoveTargetEntity(vehicle)
        end
    end
    local parts = getVehicleParts(vehicle)
    local options = {}
    for _, part in ipairs(parts) do
        local option = {
            label = part.label,
            icon = 'fa-solid fa-gear',
            onSelect = function()
                disassemblePart(vehicle, part)
            end,
            action = function()
                disassemblePart(vehicle, part)
            end
        }
        if Config.Target == 'ox_target' and part.bone then
            option.bones = { part.bone }
        elseif Config.Target == 'qb-target' and part.bone then
            option.bone = part.bone
        end
        table.insert(options, option)
    end
    if areAllPartsDismantled(vehicle) then
        local option = {
            label = Config.Locales.disassemble_vehicle,
            icon = 'fa-solid fa-car-burst',
            onSelect = function()
                disassembleVehicleFinal(vehicle)
            end,
            action = function()
                disassembleVehicleFinal(vehicle)
            end
        }
        table.insert(options, option)
    end
    if Config.Target == 'ox_target' then
        exports.ox_target:addLocalEntity(vehicle, options)
    elseif Config.Target == 'qb-target' then
        exports['qb-target']:AddTargetEntity(vehicle, {
            options = options,
            distance = 2.5
        })
    end
end

local function refreshTargets(vehicle)
    addTargetToVehicle(vehicle)
end

disassemblePart = function(vehicle, part)
    local playerPed = PlayerPedId()
    local dict = 'mini@repair'
    local anim = 'fixing_a_ped'
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(10) end
    TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
    if math.random(1, 100) <= (Config.SentDispatchChancePart or 10) then
        sendDispatchNotification()
    end
    Wait(math.random(1000, 1100))
    local success = lib.skillCheck({'easy', 'easy', 'easy'})
    ClearPedTasks(playerPed)
    if success then
        if part.type == 'door' then
            SetVehicleDoorBroken(vehicle, part.index, true)
        elseif part.type == 'wheel' then
            SetVehicleTyreBurst(vehicle, part.index, true, 1000.0)
        end
        local vehId = VehToNet(vehicle)
        dismantledParts[vehId] = dismantledParts[vehId] or {}
        dismantledParts[vehId][part.key] = true
        TriggerServerEvent('mcr_scrapyard:rewardPlayer')
        refreshTargets(vehicle)
    end
end

local lastTargetVehicle = nil

CreateThread(function()
    while true do
        Wait(1000)
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local loc = getClosestScrapyard()
            if loc then
                if lastTargetVehicle ~= vehicle then
                    addTargetToVehicle(vehicle)
                    lastTargetVehicle = vehicle
                end
            else
                lastTargetVehicle = nil
            end
        else
            lastTargetVehicle = nil
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        for _, loc in ipairs(Config.ScrapyardLocations) do
            DrawMarker(
                Config.MarkerSettings.type or 1,
                loc.x, loc.y, loc.z - 1.0,
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                Config.MarkerSettings.scale and Config.MarkerSettings.scale.x or 3.0,
                Config.MarkerSettings.scale and Config.MarkerSettings.scale.y or 3.0,
                Config.MarkerSettings.scale and Config.MarkerSettings.scale.z or 1.0,
                Config.MarkerSettings.color and Config.MarkerSettings.color.r or 0,
                Config.MarkerSettings.color and Config.MarkerSettings.color.g or 0,
                Config.MarkerSettings.color and Config.MarkerSettings.color.b or 255,
                Config.MarkerSettings.color and Config.MarkerSettings.color.a or 150,
                false, true, 2, false, nil, nil, false
            )
        end
    end
end)

local function getOnlineCops(cb)
    lib.callback('mcr_scrapyard:getOnlineCops', false, cb)
end

RegisterNetEvent('mcr_scrapyard:disassembleVehicle', function(vehicle)
    getOnlineCops(function(count)
        if count < Config.RequiredCops then
            if Config.Notify == 'ESX' then
                ESX.ShowNotification(Config.Locales.get_cop_count_notify)
            elseif Config.Notify == 'qbcore' then
                QBCore.Functions.Notify(Config.Locales.get_cop_count_notify, 'error')
            end
            return
        end
        local playerPed = PlayerPedId()
        local dict = 'mini@repair'
        local anim = 'fixing_a_ped'
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(10)
        end
        TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
        if math.random(1, 100) <= (Config.SentDispatchChance or 35) then
            sendDispatchNotification()
        end
        local success = lib.progressBar({
            duration = Config.ProgressBarDuration,
            label = Config.Locales.progressbar_text
        })
        ClearPedTasks(playerPed)
        if success then
            TriggerServerEvent('mcr_scrapyard:rewardPlayer')
            if DoesEntityExist(vehicle) then
                DeleteEntity(vehicle)
            end
        end
    end)
end) 
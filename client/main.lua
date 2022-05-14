local QBCore = exports['qb-core']:GetCoreObject()
local pedSpawned = false
local ShopPed = {}

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
    -- Initialise items here
end)

local function createPeds()
    if pedSpawned then return end
    for k, v in pairs(Config.Locations) do
        if not ShopPed[k] then ShopPed[k] = {} end
        local current = v["ped"]
        current = type(current) == 'string' and GetHashKey(current) or current
        RequestModel(current)

        while not HasModelLoaded(current) do
            Wait(0)
        end
        ShopPed[k] = CreatePed(0, current, v["coords"].x, v["coords"].y, v["coords"].z-1, v["coords"].w, false, false)
        TaskStartScenarioInPlace(ShopPed[k], v["scenario"], true)
        FreezeEntityPosition(ShopPed[k], true)
        SetEntityInvincible(ShopPed[k], true)
        SetBlockingOfNonTemporaryEvents(ShopPed[k], true)

        if Config.UseTarget then
            exports['qb-target']:AddTargetEntity(ShopPed[k], {
                options = {
                    {
                        label = v["targetLabel"],
                        icon = v["targetIcon"],
                        action = function()
                            openShop(k, Config.Locations[k])
                        end,
                        debug = true
                    }
                },
                distance = 2.0
            })
        end
    end
    pedSpawned = true
end

-- Threads

CreateThread(function()
    -- Tickrate of thread
    Wait(1000)

    while true do
        -- Do stuff
        Wait(10000)
        createPeds()
    end
end)
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
    -- Initialise items here
end)

-- Functions
local function myFunction()
    -- Do stuff
    print("Hello!")
end

-- Threads
CreateThread(function()
    -- Tickrate of thread
    Wait(1000)

    while true do
        -- Do stuff
        Wait(10000)
        myFunction()
    end
end)
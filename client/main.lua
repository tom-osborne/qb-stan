local QBCore = exports['qb-core']:GetCoreObject()
local pedSpawned = false
-- Events
RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
  -- Initialise items here
end)

AddEventHandler('onResourceStart', function(resourceName)
  -- handles script restarts
  if GetCurrentResourceName() == resourceName then
      createPeds()
      createBlips()
  end
end)

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
  -- spawns peds on client map
  createPeds()
  createBlips()
end)

-- Script specific events
RegisterNetEvent("qb-stan:start", function()
  QBCore.Functions.Notify('You now work as an apprentice!', 'success', 7500)
  local text = "You're application for apprentice has been accepted. Your first job is to re-fill all the generators!"
  TriggerServerEvent('qb-phone:server:sendNewMail', {
    sender = "Stan's Construction",
    subject = "Welcome to the team!",
    message = text,
    button = {}
  })
end)

RegisterNetEvent("qb-stan:buy", function()
  print("Buying items")
end)

-- Functions
function createPeds()
  
  for idx, ped in ipairs(Config.Peds) do

    RequestModel(ped.model)
    while not HasModelLoaded(ped.model) do
      Wait(0)
    end

    -- Spawn ped
    local entity = CreatePed(0, ped.model, ped.coords.x, ped.coords.y, ped.coords.z - 1, ped.heading, false, false)
    TaskStartScenarioInPlace(entity, ped.scenario, 0, true)
    FreezeEntityPosition(entity, true)
    SetEntityInvincible(entity, true)
    SetBlockingOfNonTemporaryEvents(entity, true)

    -- Start ped qb-target menu
    exports['qb-target']:AddTargetEntity(entity, { -- The specified entity number
      options = { -- This is your options table, in this table all the options will be specified for the target to accept
        { -- First option
          num = 1, -- This is the position number of your option in the list of options in the qb-target context menu (OPTIONAL)
          type = "client", -- This specifies the type of event the target has to trigger on click, this can be "client", "server", "command" or "qbcommand", this is OPTIONAL and will only work if the event is also specified
          event = "qb-stan:start", -- This is the event it will trigger on click, this can be a client event, server event, command or qbcore registered command, NOTICE: Normal command can't have arguments passed through, QBCore registered ones can have arguments passed through
          icon = 'fa-solid fa-file-pen', -- This is the icon that will display next to this trigger option
          label = 'Start as apprentice', -- This is the label of this option which you would be able to click on to trigger everything, this has to be a string
          canInteract = function(entity, distance, data) -- This will check if you can interact with it, this won't show up if it returns false, this is OPTIONAL
            if IsPedAPlayer(entity) then return false end -- This will return false if the entity interacted with is a player and otherwise returns true
              return true
            end,
        }
      },
      distance = 2.5, -- This is the distance for you to be at for the target to turn blue, this is in GTA units and has to be a float value
    })

    pedSpawned = true
    print("Created ped " .. idx)

  end

end

local function deletePeds()
  if pedSpawned then
    DeletePed(entity)
  end
end

function createBlips()
  print("creating blips...")
  for _, ped in ipairs(Config.Peds) do
    print("Sprite: " .. ped.blipSprite)
    if ped.showblip then
      pedBlip = AddBlipForCoord(ped.coords.x, ped.coords.y, ped.coords.z)
      SetBlipSprite(pedBlip, ped.blipSprite)
      SetBlipScale(pedBlip, ped.blipScale)
      SetBlipDisplay(pedBlip, 4)
      SetBlipColour(pedBlip, ped.blipColour)
      SetBlipAsShortRange(pedBlip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentSubstringPlayerName("Construction Job")
      EndTextCommandSetBlipName(pedBlip)
    end
  end
end

-- Threads

-- Spawn start ped
-- CreateThread(function()

--   end)
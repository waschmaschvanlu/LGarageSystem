if GetResourceState("es_extended") == "started" then
    if exports["es_extended"] and exports["es_extended"].getSharedObject then
        ESX = exports["es_extended"]:getSharedObject()
    else
        TriggerEvent("esx:getSharedObject", function(obj)
            ESX = obj
        end)
    end
end
RegisterServerEvent("LudaroGarage:CreateGarage")
AddEventHandler('LudaroGarage:CreateGarage', function(changes)
    CreateGarage(changes)
end)

RegisterServerEvent("LudaroGarage:ParkOut")
AddEventHandler('LudaroGarage:ParkOut', function(plate, id, coords)
    parkout(plate, id, coords)
end)

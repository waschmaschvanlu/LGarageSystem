-- if GetResourceState("es_extended") == "started" then
--     if exports["es_extended"] and exports["es_extended"].getSharedObject then
--         ESX = exports["es_extended"]:getSharedObject()
--     else
--         TriggerEvent("esx:getSharedObject", function(obj)
--             ESX = obj
--         end)
--     end
-- end
-- RegisterCommand('testplate', function(source, args, rawCommand)
--     nearestvehicle = ESX.Game.GetClosestVehicle()
--     print(nearestvehicle)
--     if nearestvehicle ~= nil then
--         plate = GetVehicleNumberPlateText(nearestvehicle)
--         SetVehicleNumberPlateTextIndex(nearestvehicle, 1)
--         SetVehicleNumberPlateText(nearestvehicle, "")
--         print(plate)
--     end
--     local textureDic = CreateRuntimeTxd('duiTxd')                         -- Create custom texture dictionary only needs to be done once
--     local object = CreateDui('https://i.imgur.com/Q3uw6V7.png', 540, 300) -- this URL doesn't need to be edited, its just the 2d model for the plate -- Load image into object
--     local handle = GetDuiHandle(object)                                   -- Gets DUI handle from object
--     CreateRuntimeTextureFromDuiHandle(textureDic, "duiTex2", handle)      -- Creates the texture "duiTex" in the "duiTxd" dictionary
--     AddReplaceTexture('vehshare', 'plate01_n', 'duiTxd', 'duiTex2')       -- Applies "duiTex2" from "duiTxd" to "plate01_n" from "vehshare"
-- end)

-- RegisterCommand('testl', function(source, args, rawCommand)
--     coords = GetEntityCoords(PlayerPedId())
--     SetHdArea(coords.x + 400, coords.y + 400, coords.z +, 200.0)
-- end)


ESX = exports["es_extended"]:getSharedObject()
local blip = nil
local sacs = {}

RegisterNetEvent('eventsfourgon:spawnArgentProps')
AddEventHandler('eventsfourgon:spawnArgentProps', function(vehicleProps, sacsCoords, montant)
    local coords = vehicleProps.coords
    local heading = vehicleProps.heading

    if not montant or montant <= 0 then
        print("Montant non défini ou égal à zéro!")
        return
    end

    local nombreSacs = math.ceil(montant / 500)

    sacs = {}

    for i = 1, nombreSacs do
        local sacCoord = sacsCoords[i]
        table.insert(sacs,
            { model = 'prop_money_bag_01', x = sacCoord.x, y = sacCoord.y, z = sacCoord.z, pickup = false })
    end

    --print("spawnArgentProps - Coords:", coords.x, coords.y, coords.z)

    local model = GetHashKey(vehicleProps.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(500)
    end

    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, false)

    for _, sac in ipairs(sacs) do
        local prop = CreateObject(GetHashKey(sac.model), sac.x, sac.y, sac.z, true, false, true)
        -- SetEntityHeading(prop, heading)
        -- SetEntityHasGravity(prop, false)
        -- SetEntityCollision(prop, false, false)
        -- FreezeEntityPosition(prop, true)
    end

    if not DoesBlipExist(blip) then
        blip = AddBlipForEntity(vehicle)
    end

    TriggerEvent('eventsfourgon:syncSacs', sacsCoords, heading)
end)

RegisterNetEvent('eventsfourgon:supprimerSac')
AddEventHandler('eventsfourgon:supprimerSac', function(sacIndex)
    local sac = sacs[sacIndex]

    if sac then
        print('Supprimer le sac avec l\'index côté client:', sacIndex) -- Ajout d'un message de débogage
        DeleteEntity(sac.object)
        sac.object = nil
        table.remove(sacs, sacIndex)
    else
        print('Sac non trouvé avec l\'index côté client:', sacIndex) -- Ajout d'un message de débogage
    end
end)





RegisterNetEvent('eventsfourgon:convoiArrete')
AddEventHandler('eventsfourgon:convoiArrete', function()
    TriggerEvent('esx:showNotification', 'Le convoi s\'est arrêté.')

    if DoesBlipExist(blip) then
        RemoveBlip(blip)
        blip = nil
    end
end)

RegisterNetEvent('eventsfourgon:syncSacs')
AddEventHandler('eventsfourgon:syncSacs', function(syncedSacs, heading)
    for i, sacCoord in ipairs(syncedSacs) do
        local sacExists = false

        -- Vérifier si le sac existe déjà dans la table
        for j, existingSac in ipairs(sacs) do
            if existingSac.x == sacCoord.x and existingSac.y == sacCoord.y and existingSac.z == sacCoord.z then
                sacExists = true
                break
            end
        end

        -- Si le sac n'existe pas, l'ajouter
        if not sacExists then
            local newSac = { model = 'prop_money_bag_01', x = sacCoord.x, y = sacCoord.y, z = sacCoord.z, pickup = false }
            table.insert(sacs, newSac)

            -- Créer l'objet sac
            newSac.object = CreateObject(GetHashKey(newSac.model), newSac.x, newSac.y, newSac.z, true, false, true)
            SetEntityHeading(newSac.object, heading)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if sacs then
            for i, sac in ipairs(sacs) do
                if sac then
                    local playerPed = GetPlayerPed(-1)
                    local playerCoords = GetEntityCoords(playerPed)
                    local sacCoords = vector3(sac.x, sac.y, sac.z)
                    local distance = Vdist(playerCoords, sacCoords)

                    -- print("Distance au sac " .. i .. ": " .. distance)  -- Ajout du message de débogage

                    if distance < 2.0 then
                        print("Appuyez sur E pour ramasser l'argent") -- Ajout du message de débogage

                        -- Ajoutez des messages de débogage pour afficher l'index côté client
                        TriggerEvent('eventsfourgon:debugIndex', 'Index côté client: ' .. i)

                        DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour ramasser l'argent")

                        if IsControlJustPressed(0, 38) then
                            local montant = 500
                            TriggerServerEvent('eventsfourgon:ramasserArgent', i, montant)
                        end
                    end
                end
            end
        end
    end
end)

-- Gestionnaire d'événements pour afficher les messages de débogage
RegisterNetEvent('eventsfourgon:debugIndex')
AddEventHandler('eventsfourgon:debugIndex', function(message)
    print(message)
end)




function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function removeallsacks(sacks)
    for i, sack in ipairs(sacks) do
        DeleteEntity(sack.object)
        sack.object = nil
        table.remove(sacks, i)
    end
end

function RemoveSackByCoordOrId(coord, id)
    for i, sack in ipairs(sacks) do
        if sack.x == coord.x and sack.y == coord.y and sack.z == coord.z or i == id then
            DeleteEntity(sack.object)
            sack.object = nil
            table.remove(sacks, i)
        end
    end
end
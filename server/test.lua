ESX = exports["es_extended"]:getSharedObject()
local camionSpawned = false
local spawnedSacs = {}

RegisterServerEvent('eventsfourgon:spawnCamion')
AddEventHandler('eventsfourgon:spawnCamion', function(playerCoords, montant)
    if not camionSpawned then
        local heading = playerCoords.heading

        local vehicleProps = {
            model = 'stockade',
            plate = 'PLAQUE',
            coords = { x = playerCoords.x, y = playerCoords.y, z = playerCoords.z },
            heading = heading,
        }

        print("spawnCamion - Coords Received:", playerCoords.x, playerCoords.y, playerCoords.z, "Montant:", montant)

        if not montant or montant <= 0 then
            print("Montant non défini ou égal à zéro!")
            return
        end

        local sacsCoords = GetSacsCoords(vehicleProps.coords, montant) -- Utilisez les coordonnées du camion

        TriggerClientEvent('eventsfourgon:spawnArgentProps', -1, vehicleProps, sacsCoords, montant)

        camionSpawned = true

        SetTimeout(600000, function()
            camionSpawned = false
            TriggerClientEvent('eventsfourgon:convoiArrete', -1)
        end)
    end
end)


RegisterServerEvent('eventsfourgon:ramasserArgent')
AddEventHandler('eventsfourgon:ramasserArgent', function(sacIndex, montant)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer and montant and type(montant) == 'number' then
        print('Joueur trouvé et montant valide.')

        -- Ajoutez des messages de débogage pour afficher l'index côté serveur
        print('Suppression du sac avec l\'index serveur:', sacIndex)
        TriggerClientEvent('eventsfourgon:debugIndex', -1, 'Index côté serveur: ' .. sacIndex)

        xPlayer.addMoney(montant)
        TriggerClientEvent('esx:showNotification', source, 'Vous avez ramassé de l\'argent!')
        TriggerClientEvent('eventsfourgon:supprimerSac', -1, sacIndex) -- Cette ligne doit rester du côté serveur, elle indique au client de supprimer l'objet

        local sac = spawnedSacs[sacIndex]
        if sac then
            spawnedSacs[sacIndex] = nil
        end
    else
        print('Erreur: Joueur non trouvé ou montant invalide. Joueur:', xPlayer, 'Montant:', montant)
    end
end)





function GetSacsCoords(camionCoords, montant)
    local sacs = {}
    local nombreSacs = math.floor(montant / 500) -- Utilisez math.floor pour arrondir vers le bas

    for i = 1, nombreSacs do
        local sacX = camionCoords.x + math.random(-5, 5)
        local sacY = camionCoords.y + math.random(-5, 5)
        local sacZ = camionCoords.z

        sacs[i] = { x = sacX, y = sacY, z = sacZ - 1.0, object = nil }
    end

    return sacs
end

RegisterCommand('spawnConvoi', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    print("xPlayer:" .. xPlayer .. " Group:" .. xPlayer.getGroup())
    if xPlayer and xPlayer.getGroup() == 'admin' then
        local playerPed = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(playerPed)
        local montant = tonumber(args[1]) or 0

        print("Coordonnées:", playerCoords.x, playerCoords.y, playerCoords.z)
        print("Montant:", montant)

        TriggerEvent('eventsfourgon:spawnCamion',
            { x = playerCoords.x, y = playerCoords.y, z = playerCoords.z, heading = GetEntityHeading(playerPed) },
            montant)
    else
        TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez pas les autorisations nécessaires.')
    end
end, false)

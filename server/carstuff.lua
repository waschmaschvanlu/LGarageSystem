function parkout(plate, id, pos)
    position = vector3(pos.x, pos.y, pos.z)
    positionheading = pos.w
    sqlvehicle = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate", {['@plate'] = plate})

    if sqlvehicle[1] ~= nil then
        if sqlvehicle[1].owner == id then
            MySQL.Async.execute("UPDATE owned_vehicles SET parked = @parked WHERE plate = @plate", {['@parked'] = 0, ['@plate'] = plate})
        end
    end

    ESX.OneSync.SpawnVehicle(sqlvehicle[1].model, position, positionheading, v.properties, function(NetworkId)
        local Vehicle = NetworkGetEntityFromNetworkId(NetworkId)
       TriggerClientEvent("Ludaro:CarSpawned", id, vehicle)
    end)
end
RegisterNetEvent("baseevents:enteringVehicle", function(vehicle, seat, displayname)
    currentcoords = GetEntityCoords(PlayerPedId())
end)



RegisterNetEvent("baseevents:leftVehicle", function(vehicle, seat, displayname)
    local currentcoords2 = GetEntityCoords(PlayerPedId())
    local distance = #(currentcoords2 - currentcoords)
    plate = GetVehicleNumberPlateText(vehicle)
    if distance > 1 then
        print("saving milage".. distance)
        TriggerServerEvent("milage:save", plate, distance)
    end


end)
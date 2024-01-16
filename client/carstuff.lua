function parkvehicle()
    plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
    checkifowner = lib.callback("ludaro_garage:checkifowner", false, plate)
    if checkifowner then
        TriggerServerEvent("ludaro_garage:parkvehicle", plate)
    else
        Notify(locale("notowner"))
    end
end


function getcarname(vehiclemodel, plate)
    plate = GetVehicleNumberPlateText(vehicle)
    name = lib.callback.await("ludaro_garage:getcarname", plate)
    local getdisplayname = GetDisplayNameFromVehicleModel(vehiclemodel)
    return name or getdisplayname or "Unknown"
end


function getlastlocation(plate)
    plate = GetVehicleNumberPlateText(vehicle)
    location = lib.callback.await("ludaro_garage:getlastlocation", plate)
    return location or nil
end
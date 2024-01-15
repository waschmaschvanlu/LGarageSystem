function parkvehicle()
    plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false))
    checkifowner = lib.callback("ludaro_garage:checkifowner", false, plate)
    if checkifowner then
        TriggerServerEvent("ludaro_garage:parkvehicle", plate)
    else
        Notify("You do not own this vehicle.")
    end
end

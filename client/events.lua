RegisterNetEvent("LudaroGarage:OpenGarageCreationMenu", function()
    openGarageCreationMenu()
end)

RegisterNetEvent("Ludaro:CarSpawned", function(vehicle)
    if SpawnInVehicle then
        SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    end
    _menuPool:CloseAllMenus()
    Notify(locale("vehicle_spawned"))
end)
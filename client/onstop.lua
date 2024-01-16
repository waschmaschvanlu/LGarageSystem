AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        RemoveAllNPCS()
        _menuPool:CloseAllMenus()
    end
end)

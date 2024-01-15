AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        RemoveAllNPCS()
    end
end)

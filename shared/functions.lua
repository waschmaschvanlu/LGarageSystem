Notify = function(msg)
    ESX.ShowNotification(msg)
    -- https://docs.esx-framework.org/legacy/Client/functions/shownotification
end

DrawTextUI = function(msg)
    ESX.ShowHelpNotification(msg)
end

DrawText3D = function(coords, msg)
    ESX.DrawText3D(coords, msg)
end

KeyboardInput = function(Text, Name, MaxLength)
    AddTextEntry("FMMC_KEY_TIP1", Text)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", Name, "", "", "", MaxLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end
Debug = true

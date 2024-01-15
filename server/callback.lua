lib.callback.register('ludaro_garage:checkifowner', function(source, plate)
    print(plate)
    print(ESX.GetPlayerFromId(source).identifier)
    local result = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate AND owner = @owner",
        { ['@plate'] = plate, ['@owner'] = ESX.GetPlayerFromId(source).identifier })
    if result[1] then
        return true
    else
        return false
    end
end)
items = {"bread", "phone"}

function isnotintable(table, item)
    for k, v in pairs(table) do
        if v == item then
            return false
        end
    end
    return true
end



if Config.RemoveItemsAfterRPDeath then
    for i = 1, #xPlayer.inventory, 1 do
        if xPlayer.inventory[i].count > 0 or isintable(items, xPlayer.inventory.name) then
            xPlayer.setInventoryItem(xPlayer.inventory[i].name, 0)
        end
    end
end


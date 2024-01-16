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
lib.callback.register('ludaro_garage:getCars', function(source, garageid)
if garageid == "impound" then
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.job.name
    local society = GetSociety(job)
    local identifier = xPlayer.identifier
    
    local condition = "(owner = @owner AND job = @job AND stored = 0) OR owner = @societyOwner AND stored = 0 OR (job IS NULL OR job = 'none' OR job = 'unemployed') AND owner = @owner AND stored = 0"
    
    if IsJobGarage(garageid) then
        local result = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE " .. condition,
        {
            ['@owner'] = identifier or 'none',
            ['@job'] = job or 'none', 
            ['@societyOwner'] = society
        })
        return result
    else
        local result = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner AND stored = 0",
        {
            ['@owner'] = identifier or 'none'
        })
        return result
    end    
else
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.job.name
    local society = GetSociety(job)
    local identifier = xPlayer.identifier

    if IsJobGarage(garageid) then
        local result = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE (owner = @owner AND job = @job) OR owner = @societyOwner OR (job IS NULL OR job = 'none' OR job = 'unemployed' AND owner = @owner)",
        {
            ['@owner'] = identifier or 'none',
            ['@job'] = job or 'none', 
            ['@societyOwner'] = society
        })
        return result
    else
        local result = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner",
        {
            ['@owner'] = identifier or 'none'
        })
        return result
    end
    return result
end
end)


function IsJobGarage(id)
    if JobGarageOnlyJobCars or id ~= "impound" then
        local garage = MySQL.Sync.fetchScalar("SELECT job FROM ludaro_garagesystem WHERE ID = @id", {['@id'] = id})

        -- Check if a job is associated with the garage
        if garage[1] then
            return garage[1] ~= "none", garage[1]
        else
            return false
        end
    else
        return true
    end
end


function GetSociety(job)
    return "society_" .. job or 'none'
end
function AddSQL()
    -- if
end

function GetData(owner, sharedwith)
    if owner then
        mysqlreturn = MySQL.Sync.fetchAll("SELECT * FROM ludaro_garagesystem WHERE owner = @owner",
            { ['@owner'] = owner })
        if mysqlreturn then
            return mysqlreturn
        else
            return false
        end
    elseif sharedwith then
        mysqlreturn = MySQL.Sync.fetchAll("SELECT * FROM ludaro_garagesystem")
        for k, v in pairs(mysqlreturn) do
            if #v.sharedwith > 0 then
                for k2, v2 in pairs(v.sharedwith) do
                    if v2 == sharedwith then
                        print("found")
                        return v
                    end
                end
            end
        end
    else
        mysqlreturn = MySQL.Sync.fetchAll("SELECT * FROM ludaro_garagesystem")
        return mysqlreturn
    end
end

function GetAllJsonAndConvertToTable(input)
    local outputTable = {}

    for key, value in pairs(input) do
        if type(value) == "string" then
            local success, result = pcall(json.decode, value)
            if success then
                outputTable[key] = result
            else
                outputTable[key] = value -- If not valid JSON, keep the original value
            end
        else
            outputTable[key] = value
        end
    end

    return outputTable
end

for _, playerId in ipairs(GetPlayers()) do
    print(playerId)
    TriggerClientEvent("ludaro_garage:client:SendData", playerId, "GetAllJsonAndConvertToTable(GetData(nil, nil))")
    -- ('%s'):format('text') is same as string.format('%s', 'text)
end

lib.callback.register('ludaro_garage:sendata', function(source)
    return GetAllJsonAndConvertToTable(GetData(nil, nil)), ESX.GetPlayerFromId(source).identifier, ESX.GetPlayerFromId(source).job.name, ESX.GetPlayerFromId(source).job.grade
end) -- this callback is here so it can execute faster, 








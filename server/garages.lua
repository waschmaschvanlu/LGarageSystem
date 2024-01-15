function CreateGarage(data)
    -- Check if all necessary data exists
    print("Creating garage with data: " .. json.encode(data))
    print(data.name, data.exit, data.park, data.entrance, data.price, data.garageType)
    if not (data.name and data.exit and data.park and data.entrance and data.price and data.garageType) then
        print("Missing necessary data to create garage.")
        return
    end

    -- Extract the data
    local name = data.name
    local coords = {
        exit = { x = data.exit.x, y = data.exit.y, z = data.exit.z },
        garage = { x = data.park.x, y = data.park.y, z = data.park.z },
        entrance = { x = data.entrance.x, y = data.entrance.y, z = data.entrance.z },
    }
    local marker = data.marker or nil
    local blip = data.blip or nil
    local price = data.price or 0
    local ipl = data.ipl or DefaultIPL
    local job = data.job or nil
    local type = data.garageType or "list"
    local owner = data.owner or nil
    print(data.npc)
    local npc = data.npc or nil

    -- Create the SQL query
    local query = string.format(
        "INSERT INTO ludaro_garagesystem (name, coords, marker, blip, price, ipl, job, type, owner, npc) VALUES ('%s', '%s', '%s', '%s', '%d', '%s', '%s', '%s', '%s', '%s')",
        name, json.encode(coords), json.encode(marker), json.encode(blip), price, ipl, json.encode(job), type, owner,
        json.encode(npc))

    -- Execute the query
    MySQL.Async.execute(query, {}, function(rowsChanged)
        print("Inserted new garage into database. Rows changed: " .. rowsChanged)
    end)
end

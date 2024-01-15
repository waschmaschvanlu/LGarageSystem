-- function SpawnNPC(model, coords, freeze, id)
--     RequestModel(model)
--     while not HasModelLoaded(model) do
--         Citizen.Wait(0)
--     end
--     local success, ped = pcall(function()
--         return CreatePed(4, model, coords.x, coords.y, coords.z, coords.w, freeze, false)
--     end)
--     if success then
--         SetEntityInvincible(ped, true)
--         SetBlockingOfNonTemporaryEvents(ped, true)
--         FreezeEntityPosition(ped, freeze)
--         SetEntityAsMissionEntity(ped, true, true)
--         table.insert(allPeds, { ped, id }) -- Add the ped to a table of all peds
--         return ped                         -- Return the Ped
--     else
--         print("Failed to create ped for model: " .. model)
--     end
-- end

function RemoveAllNPCS()

end

-- function RemoveNPC(id)
--     for i, v in ipairs(allPeds) do
--         if v[2] == id then
--             DeleteEntity(v[1])
--             table.remove(allPeds, i)
--             break
--         end
--     end
-- end

-- for k, v in pairs(Garages) do
--     v.active = false
--     if v.job then
--         if v.job.name == ESX.PlayerData.job.name and v.job.grade == ESX.PlayerData.job.grade then
--             v.active = true
--         end
--     else
--         if #v.buyable == 0 or v.buyable == nil then
--             v.active = true
--         end
--     end
--     if v.active then
--         function onEnter(self)
--             v = self.data
--             SpawnNPC(v.settings.npc.model, v.settings.npc.coords, true, self.id)
--             print('entered zone', self.id)
--         end

--         function onExit(self)
--             RemoveNPC(self.id)
--             print('exited zone', self.id)
--         end

--         function inside(self)
--             markersettings = self.data.settings.marker
--             Citizen.Wait(0)
--             if self.data.settings.marker.enabled then
--                 DrawMarker(markersettings.type, markersettings.x, markersettings.y, markersettings.z, 0.0, 0.0, 0.0,
--                     0.0, 0.0, 0.0, markersettings.scale or 1.0, markersettings.scale or 1.0,
--                     markersettings.scale or 1.0, markersettings.r, markersettings.g, markersettings.b,
--                     markersettings.a, false, true, 2, false, false, false, false)
--             end
--             distance = (#self.data.coords.menu - GetEntityCoords(PlayerPedId()))
--             if self.data.distance <= distance then
--                 DrawText3D(self.data.coords.menu, "Drücke ~g~E~w~ um die Garage zu öffnen")
--                 DrawTextUI("Drücke ~g~E~w~ um die Garage zu öffnen")
--                 if IsControlJustReleased(0, 38) then
--                     OpenGarageMenu(self.data)
--                 end
--             end
--         end

--         coords = v.coords.exit or v.coords.menu or v.coords.park or v.coords
--         local box = lib.zones.box({
--             coords = v.coords.menu,
--             size = vec3(v.distance, v.distance, v.ditance),
--             rotation = 45,
--             debug = Debug,
--             inside = inside,
--             onEnter = onEnter,
--             onExit = onExit,
--             data = v,
--             name = k,
--         })

--         blipsettings = v.settings.blip
--         coords = blipsettings.coords or v.coords.menu or v.coords.exit or v.coords.park
--         local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
--         SetBlipSprite(blip, blipsettings.sprite)
--         SetBlipScale(blip, blipsettings.scale or 1.0)
--         SetBlipColour(blip, blipsettings.color)
--         SetBlipAsShortRange(blip, true)
--         BeginTextCommandSetBlipName("STRING")
--         AddTextComponentString(blipsettings.name or k)
--         EndTextCommandSetBlipName(blip)
--     end
-- end


-- CreateBlips()
-- DrawMaker()
-- DrawNPCS()



-- function DrawMaker()
--     Citizen.CreateThread(function()
--         while true do
--             for k, v in pairs(Garages) do
--                 Citizen.Wait(0)
--                 markersettings = v.settings.marker
--                 if markersettings.enabled and v.active then
--                     DrawMarker(markersettings.type, markersettings.x, markersettings.y, markersettings.z, 0.0, 0.0, 0.0,
--                         0.0, 0.0, 0.0, markersettings.scale or 1.0, markersettings.scale or 1.0,
--                         markersettings.scale or 1.0, markersettings.r, markersettings.g, markersettings.b,
--                         markersettings.a, false, true, 2, false, false, false, false)
--                 end
--             end
--         end
--     end)
-- end

-- function DrawNPCS()
--     Citizen.CreateThread(function()
--         while true do
--             for k, v in pairs(Garages) do
--                 if v.settings.npc.enabled and v.active then
--                     Citizen.Wait(500)
--                     npcsettings = v.settings.npc
--                     distancetonpc = #(GetEntityCoords(PlayerPedId()) - v.settings.npc.coords)
--                     distance = v.distance or 5.0
--                     if istancetonpc < distance then
--                         npc = SpawnNPC(npcsettings.model, npcsettings.coords, true)
--                     else
--                         RemoveNPC(npc)
--                     end
--                 end
--             end
--         end
--     end)
-- end

-- allPeds = {}



-- function RemoveNPC(ped)
--     if DoesEntityExist(ped) then
--         for i, v in ipairs(allPeds) do
--             if v == ped then
--                 table.remove(allPeds, i)
--                 break
--             end
--         end
--         DeleteEntity(ped)
--     end
-- end



-- Citizen.CreateThread(function()
--     while true do
--  if
--     end
-- end)

function CreateNPCZone(data)
    coords = json.decode(data.coords).entrance
    function onEnternpc(self)
        print('entered zone', self.id)
        CreateNPC(data, self.id)
    end

    function onExitnpc(self)
        print('exited zone', self.id)
        DeleteNPC(self.id)
    end

    function insidenpc(self)
    end

    local box = lib.zones.box({
        coords = coords,
        size = vec3(LoadingRange, LoadingRange, LoadingRange),
        rotation = 0,
        debug = Debug,
        inside = insidenpc,
        onEnter = onEnternpc,
        onExit = onExitnpc,
        data = data,
        name = data.name,
    })
end

function CreateEntrance(data)
    coords = json.decode(data.coords).entrance
    function onEnterentr(self)
        print('entered zone', self.id)
    end

    function onExitentr(self)
        print('exited zone', self.id)
    end

    function insideentr(self)
        DrawTextUI(locale('press_e_to_enter'))
        if IsControlJustPressed(0, 38) then
            OpenGarageMenu(self.data)
        end
    end

    local box2 = lib.zones.box({
        coords = coords,
        size = vec3(2.0, 2.0, 2.0),
        rotation = 0,
        debug = Debug,
        inside = insideentr,
        onEnter = onEnterentr,
        onExit = onExitentr,
        data = data,
        name = data.name,
    })
end

allPeds = {}
function CreateNPC(data, name)
    npc = json.decode(data.npc)
    coords = json.decode(data.coords).entrance
    if IsModelValid(npc.Model) then
        model = GetHashKey(npc.Model)
    else
        model = GetHashKey("a_m_m_business_01")
    end
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    local ped = CreatePed(4, model, coords.x, coords.y, coords.z, coords.w, false, false)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityAsMissionEntity(ped, true, true)
    table.insert(allPeds, { ped, name }) -- Add the ped to a table of all peds
    return ped, id
end

function DeleteNPC(id)
    for i, v in ipairs(allPeds) do
        if v[2] == id then
            DeleteEntity(v[1])
            table.remove(allPeds, i)
            break
        end
    end
end

function RemoveAllNPCS()
    for i, v in ipairs(allPeds) do
        DeleteEntity(v[1])
        table.remove(allPeds, i)
    end
end

function CreateMarkerZone(data)
    coords = json.decode(data.coords).entrance
    markersettings = json.decode(data.marker)
    alpha = markersettings.Alpha or 255
    red = markersettings.Red or 0
    green = markersettings.Green or 255
    blue = markersettings.Blue or 0
    scale = markersettings.Scale or 1.0
    typee = markersettings.Type or 1
    bobupanddown = markersettings.BobUpAndDown or false
    faceCamera = markersettings.FaceCamera or false
    coords = json.decode(data.coords).entrance
    function onEntermarker(self)
    end

    function onExitmarker(self)
    end

    function insidemarker(self)
        DrawMarker(typee, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, scale, scale, scale, red, green, blue,
            alpha, bobupanddown, faceCamera, 2, false, false, false, false)
    end

    local box = lib.zones.box({
        coords = coords,
        size = vec3(LoadingRange, LoadingRange, LoadingRange),
        rotation = 0,
        debug = Debug,
        inside = insidemarker,
        onEnter = onEntermarker,
        onExit = onExitmarker,
        data = data,
        name = data.name,
    })
end

function CreateExit()
end

function CreateBlip(data)
    blipp = json.decode(data.blip)
    coords = json.decode(data.coords).entrance
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, blipp.sprite)
    SetBlipScale(blip, blipp.scale or 1.0)
    SetBlipColour(blip, blipp.color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.name or "Garageeee")
    EndTextCommandSetBlipName(blip)
end

function CreatePark(data)
    parkcoords = json.decode(data.coords).garage
    function onEnterpark(self)
    end

    function onExitpark(self)
    end

    function Insidepark(self)
        DrawMarker(1, parkcoords.x, parkcoords.y, parkcoords.z, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255,
            255, false, true, 2, false, false, false, false)
        if IsPedInAnyVehicle(PlayerPedId(), true) and #(vector3(parkcoords.x, parkcoords.y, parkcoords.z) - GetEntityCoords(PlayerPedId())) < 5.0 then
            DrawTextUI(locale('press_e_to_park'))
            if IsControlJustReleased(0, 38) then
                plate = GetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), true))
                checkifowner = lib.callback("ludaro_garage:checkifowner", false, function()
                    if checkifowner then
                        TriggerServerEvent("ludaro_garage:parkvehicle", plate)
                    else
                        Notify("You do not own this vehicle.")
                    end
                end, plate)
            end
        end
    end

    local box = lib.zones.box({
        coords = parkcoords,
        size = vec3(LoadingRange, LoadingRange, LoadingRange),
        rotation = 0,
        debug = Debug,
        inside = Insidepark,
        onEnter = onEnterpark,
        onExit = onExitpark,
        data = data,
        name = data.name,
    })
end

function CreateExit(data)
    exitcoords = json.decode(data.coords).exit
    function onEnterexit(self)
    end

    function onExitexit(self)
    end

    function Insideexit(self)
        DrawMarker(1, exitcoords.x, exitcoords.y, exitcoords.z, 0.0, 0.0, 0.0,
            0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255,
            255, false, true, 2, false, false, false, false)
    end

    local box = lib.zones.box({
        coords = exitcoords,
        size = vec3(LoadingRange, LoadingRange, LoadingRange),
        rotation = 0,
        debug = Debug,
        inside = Insideexit,
        onEnter = onEnterexit,
        onExit = onExitexit,
        data = data,
        name = data.name,
    })
end

function hasrightjob(job, grade, data)
    data.job = json.decode(data.job)
    -- print(data.job.name, data.job.grade)
    if data.job == nil or data.job.job == nil then
        return true
    end
    if data.job.job == job and (data.job.grade or 0 > grade) then
        return true
    end
    return false
end

function isowner(data, identifier)
    data.owner = json.decode(data.owner)
    if data.owner == nil then
        return false
    end
    if data.owner == identifier then
        return true
    end
    return false
end

function CreateGarages(data, identifier, job, grade)
    for k, v in pairs(data) do
        if hasrightjob(job, grade, v) or isowner(v, identifier) then
            CreateNPCZone(v)
            CreateBlip(v)
            CreateMarkerZone(v)
            CreateEntrance(v)
            CreatePark(v)
            CreateExit(v)
        end
    end
end

local count, identifier, job, grade = lib.callback.await('ludaro_garage:sendata', false)
CreateGarages(count, identifier, job, grade)

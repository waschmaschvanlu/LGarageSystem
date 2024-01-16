function CreateNPCZone(data)
    coords = json.decode(data.coords).entrance
    function onEnternpc(self)
        print('entered zone', self.name)
        CreateNPC(data, self.name)
    end

    function onExitnpc(self)
        print('exited zone', self.name)
        DeleteNPC(self.name)
    end

    function insidenpc(self)
    end

    NPCBox = lib.zones.box({
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

    EntranceBox = lib.zones.box({
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
    coords = json.decode(data.coords).entrance or data.coords
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

    Markerbox = lib.zones.box({
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
    coords = json.decode(data.coords).entrance or data.blip.coords or data.coords
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
                        Notify(locale("notOwner"))
                    end
                end, plate)
            end
        end
    end

    Parkbox = lib.zones.box({
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

 Exitbox = lib.zones.box({
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


function refreshgarages()
    
    ParkBox:remove()
    ExitBox:remove()
    NPCbox:remove()
    MarkerBox:remove()
    EntranceBox:remove()
    local count, identifier, job, grade = lib.callback.await('ludaro_garage:sendata', false)
    for k,v in pairs(count) do
        DeleteNPC(v.name)
    end
CreateGarages(count, identifier, job, grade)


end
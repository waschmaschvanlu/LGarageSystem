_menuPool = NativeUI.CreatePool()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if _menuPool:IsAnyMenuOpen() then
            _menuPool:ProcessMenus()
        else
            Citizen.Wait(150) -- this small line
        end
    end
end)

RegisterNetEvent("LudaroGarage:OpenGarageCreationMenu", function()
    changes = {}
    local mainmenu = NativeUI.CreateMenu(locale("GarageCreationMenuTitle"), locale("GarageCreationMenuDescription"))
    _menuPool:Add(mainmenu)
    _menuPool:RefreshIndex()
    _menuPool:MouseControlsEnabled(false)
    _menuPool:MouseEdgeEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
    mainmenu:Visible(true)

    local garageNameItem = NativeUI.CreateItem(locale("GarageName"), "")

    garageNameItem.Activated = function(sender, index)
        local name = KeyboardInput(locale("GarageName"), "", 30)
        if name then
            changes.name = name
            garageNameItem:RightLabel(name)
        end
    end
    local garageExitCoordsItem = NativeUI.CreateItem(locale("GarageExitCoords"), "")
    garageExitCoordsItem.Activated = function(sender, index)
        local coords = GetEntityCoords(PlayerPedId())
        changes.exit = { x = coords.x, y = coords.y, z = coords.z, w = GetEntityHeading(PlayerPedId()) }
        garageExitCoordsItem:RightLabel(math.round(coords.x) ..
            "|" .. math.round(coords.y) .. "|" .. math.round(coords.z) .. "|")
    end



    local garageEntranceCoordsItem = NativeUI.CreateItem(locale("GarageEntranceCoords"), "")
    garageEntranceCoordsItem.Activated = function(sender, index)
        local coords = GetEntityCoords(PlayerPedId())
        changes.entrance = { x = coords.x, y = coords.y, z = coords.z, w = GetEntityHeading(PlayerPedId()) }
        garageEntranceCoordsItem:RightLabel(math.round(coords.x) ..
            "|" .. math.round(coords.y) .. "|" .. math.round(coords.z) .. "|")
    end
    local garageParkCoordsItem = NativeUI.CreateItem(locale("GarageParkCoords"), "")
    garageParkCoordsItem.Activated = function(sender, index)
        local coords = GetEntityCoords(PlayerPedId())
        changes.park = { x = coords.x, y = coords.y, z = coords.z, w = GetEntityHeading(PlayerPedId()) }
        garageParkCoordsItem:RightLabel(math.round(coords.x) ..
            "|" .. math.round(coords.y) .. "|" .. math.round(coords.z) .. "|")
    end


    local garageType = NativeUI.CreateListItem(locale("GarageType"),
        { locale("GarageTypeList"), locale("GarageTypeIpl") })

    changes.garageType = "list"
    garageType.OnListChanged = function(sender, item, index)
        print(index)
        if index == 1 then
            changes.garageType = "list"
        elseif index == 2 then
            changes.garageType = "ipl"
        end
    end

    local garageIpl = NativeUI.CreateItem(locale("GarageIpl"), "")
    garageIpl.Activated = function(sender, index)
        local ipl = KeyboardInput(locale("GarageIpl"), "", 30)
        if ipl then
            changes.ipl = ipl
        end
    end
    mainmenu:AddItem(garageNameItem)
    mainmenu:AddItem(garageExitCoordsItem)
    mainmenu:AddItem(garageEntranceCoordsItem)
    mainmenu:AddItem(garageParkCoordsItem)
    mainmenu:AddItem(garageType)
    local garageOwner     = NativeUI.CreateItem(locale("GarageOwner"), "")
    garageOwner.Activated = function(sender, index)
        local owner = KeyboardInput(locale("GarageOwner"), "", 30)
        if owner then
            changes.owner = owner
            garageOwner:RightLabel(owner)
        end
    end
    local priceItem       = NativeUI.CreateItem(locale("GaragePrice"), "")
    changes.price         = 0
    priceItem.Activated   = function(sender, index)
        local price = KeyboardInput(locale("GaragePrice"), "", 30)
        if price then
            changes.price = price
            priceItem:RightLabel(price)
        end
    end

    mainmenu:AddItem(garageOwner)
    mainmenu:AddItem(priceItem)


    jobgaragesubmenu = _menuPool:AddSubMenu(mainmenu, locale("JobGarage"), "")
    jobgaragesubmenu.Item:RightLabel("~g~→→→")
    _menuPool:RefreshIndex()
    _menuPool:MouseControlsEnabled(false)
    _menuPool:MouseEdgeEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
    local jobgarage              = NativeUI.CreateCheckboxItem(locale("JobGarageEnabled"), false, "")
    jobgarage.OnCheckboxChange   = function(sender, checked)
        changes.job.Enabled = checked
    end
    changes.job                  = {}
    local jobgaragejob           = NativeUI.CreateItem(locale("JobGarageJob"), "")
    jobgaragejob.Activated       = function(sender, index)
        local job = KeyboardInput(locale("JobGarageJob"), "", 30)
        if job then
            changes.job.job = job
            jobgaragejob:RightLabel(job)
        end
    end
    local jobgaragegrade         = NativeUI.CreateListItem(locale("JobGarageGrade"),
        { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 })
    jobgaragegrade.OnListChanged = function(sender, item, index)
        changes.job.grade = index
    end
    jobgaragesubmenu.SubMenu:AddItem(jobgarage)
    jobgaragesubmenu.SubMenu:AddItem(jobgaragejob)
    jobgaragesubmenu.SubMenu:AddItem(jobgaragegrade)


    local blipsubmenu = _menuPool:AddSubMenu(mainmenu, locale("GarageBlip"), "")
    blipsubmenu.Item:RightLabel("~g~→→→")
    _menuPool:RefreshIndex()
    _menuPool:MouseControlsEnabled(false)
    _menuPool:MouseEdgeEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
    changes.blip = {}
    local blipItem = NativeUI.CreateCheckboxItem(locale("BlipEnabled"), false, "")
    blipItem.OnCheckboxChanged = function(sender, checked)
        changes.blip.Enabled = checked
    end
    tablefrom0to85 = {}
    for i = 0, 85 do
        table.insert(tablefrom0to85, i)
    end
    local blipcolor = NativeUI.CreateListItem(locale("GarageBlipColor"), tablefrom0to85)
    blipcolor.OnListChanged = function(sender, item, index)
        changes.blip.color = index
    end

    tablefrom0to826 = {}
    for i = 0, 826 do
        table.insert(tablefrom0to826, i)
    end
    local blipsprite = NativeUI.CreateListItem(locale("GarageBlipSprite"), tablefrom0to826)
    blipsprite.OnListChanged = function(sender, item, index)
        changes.blip.sprite = index
    end
    scaletable = {}
    for i = 0.0, 3.0, 0.1 do
        table.insert(scaletable, i)
    end
    local blipscale = NativeUI.CreateListItem(locale("GarageBlipScale"), scaletable, 1, false, "")
    blipscale.OnListChanged = function(sender, item, index)
        changes.blip.scale = index
    end

    blipsubmenu.SubMenu:AddItem(blipItem)
    blipsubmenu.SubMenu:AddItem(blipcolor)
    blipsubmenu.SubMenu:AddItem(blipsprite)
    blipsubmenu.SubMenu:AddItem(blipscale)
    local markerSubMenu = _menuPool:AddSubMenu(mainmenu, locale("GarageMarker"), "")
    markerSubMenu.Item:RightLabel("~g~→→→")
    _menuPool:RefreshIndex()
    _menuPool:MouseControlsEnabled(false)
    _menuPool:MouseEdgeEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
    changes.marker = {}
    local markerItem = NativeUI.CreateCheckboxItem(locale("MarkerEnabled"), false, "")
    markerItem.OnCheckboxChange = function(sender, checked)
        changes.marker.Enabled = checked
    end
    tablefrom0to43 = {}
    for i = 0, 43 do
        table.insert(tablefrom0to43, i)
    end
    tablefrom0to255 = {}
    for i = 0, 255 do
        table.insert(tablefrom0to255, i)
    end
    local markerType = NativeUI.CreateListItem(locale("GarageMarkerType"), tablefrom0to43, 1, false, "")
    markerType.OnListChanged = function(sender, item, index)
        changes.marker.Type = index
    end
    local markerSize = NativeUI.CreateListItem(locale("GarageMarkerSize"), tablefrom0to255, 1, false, "")
    markerSize.OnListChanged = function(sender, item, index)
        changes.marker.Size = index
    end
    local markerred = NativeUI.CreateListItem(locale("GarageMarkerRed"), tablefrom0to255, 1, false, "")
    markerred.OnListChanged = function(sender, item, index)
        changes.marker.Red = index
    end

    local markergreen = NativeUI.CreateListItem(locale("GarageMarkerGreen"), tablefrom0to255, 1, false, "")
    markergreen.OnListChanged = function(sender, item, index)
        changes.marker.Green = index
    end

    local markerblue = NativeUI.CreateListItem(locale("GarageMarkerBlue"), tablefrom0to255, 1, false, "")
    markerblue.OnListChanged = function(sender, item, index)
        changes.marker.Blue = index
    end

    local markerAlpha = NativeUI.CreateListItem(locale("GarageMarkerAlpha"), tablefrom0to255, 1, false, "")
    markerAlpha.OnListChanged = function(sender, item, index)
        changes.marker.Alpha = index
    end
    local markerbobupanddown = NativeUI.CreateCheckboxItem(locale("GarageMarkerBobUpAndDown"), false, "")
    markerbobupanddown.OnCheckboxChange = function(sender, checked)
        changes.marker.Bobupanddown = checked
    end

    local markerfacecam = NativeUI.CreateCheckboxItem(locale("GarageMarkerFaceCam"), false, "")
    markerfacecam.OnCheckboxChange = function(sender, checked)
        changes.marker.Facecam = checked
    end
    markerSubMenu.SubMenu:AddItem(markerItem)
    markerSubMenu.SubMenu:AddItem(markerType)
    markerSubMenu.SubMenu:AddItem(markerSize)
    markerSubMenu.SubMenu:AddItem(markerred)
    markerSubMenu.SubMenu:AddItem(markergreen)
    markerSubMenu.SubMenu:AddItem(markerblue)
    markerSubMenu.SubMenu:AddItem(markerAlpha)
    markerSubMenu.SubMenu:AddItem(markerbobupanddown)
    markerSubMenu.SubMenu:AddItem(markerfacecam)

    local npcSubMenu = _menuPool:AddSubMenu(mainmenu, locale("GarageNPC"), "")
    npcSubMenu.Item:RightLabel("~g~→→→")
    _menuPool:RefreshIndex()
    _menuPool:MouseControlsEnabled(false)
    _menuPool:MouseEdgeEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
    local npcItem = NativeUI.CreateCheckboxItem(locale("NPCEnabled"), false, "")
    npcItem.OnCheckboxChange = function(sender, checked)
        changes.npc.Enabled = checked
    end
    changes.npc = {}
    local npcModel = NativeUI.CreateItem(locale("GarageNPCModel"), "")
    npcModel.Activated = function(sender, index)
        local model = KeyboardInput(locale("GarageNPCModel"), "", 30)
        if model then
            changes.npc.Model = model
            npcModel:RightLabel(model)
        end
    end
    local npcCoords = NativeUI.CreateItem(locale("GarageNPCCoords"), "")
    npcCoords.Activated = function(sender, index)
        local coords = GetEntityCoords(PlayerPedId())
        changes.npc.coords = { x = coords.x, y = coords.y, z = coords.z, w = GetEntityHeading(PlayerPedId()) }
        npcCoords:RightLabel(math.round(coords.x) ..
            "|" .. math.round(coords.y) .. "|" .. math.round(coords.z) .. "|")
    end

    npcSubMenu.SubMenu:AddItem(npcItem)
    npcSubMenu.SubMenu:AddItem(npcModel)
    npcSubMenu.SubMenu:AddItem(npcCoords)

    local saveItem = NativeUI.CreateItem(locale("SaveGarage"), "")

    mainmenu:AddItem(saveItem)

    saveItem.Activated = function(sender, index)
        if changes.name and changes.exit and changes.entrance and changes.park and changes.name then
            TriggerServerEvent("LudaroGarage:CreateGarage", changes)
            _menuPool:CloseAllMenus()
            print(ESX.DumpTable(changes))
            Notify(locale("GarageCreated"))
        else
            Notify(locale("GarageCreationError"))
        end
    end
end)

RegisterCommand('testg', function(source, args, rawCommand)
    print("ah")
    TriggerEvent("LudaroGarage:OpenGarageCreationMenu")
end)

RegisterCommand("createGarage", function()
    TriggerEvent("LudaroGarage:OpenGarageCreationMenu")
end)


function OpenGarageMenu(data)
    print(data.type)
    if data.type == "list" then
        OpenListGarage(data)
    elseif data.type == "ipl" then
        OpenIPLGarage(data)
    end
end

function OpenListGarage(data)
    local mainmenu = NativeUI.CreateMenu(data.name, locale("GarageDescription"))
    _menuPool:Add(mainmenu)
    _menuPool:RefreshIndex()
    _menuPool:MouseControlsEnabled(false)
    _menuPool:MouseEdgeEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
    mainmenu:Visible(true)
end

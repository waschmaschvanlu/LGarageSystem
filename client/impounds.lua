for k,v in pairs(Impounds) do
    CreateBlip(v)
    function onEnterImpound(self)
        if v.npc.Model ~= nil or IsModelValid(v.npc.Model) then
            CreateNPC(self.data, self.name)
        end
    end
    function onExitImpound(self)
        if v.npc.Model ~= nil or IsModelValid(v.npc.Model) then
            DeleteNPC(self.name)
        end
    end
    function onImpound(self)
        if v.marker then
            DrawMarker(v.marker.type, v.marker.coords, 0, 0, 0, 0, 0, 0, v.marker.scale.x, v.marker.scale.y, v.marker.scale.z, v.marker.color.r, v.marker.color.g, v.marker.color.b, v.marker.color.a, 0, 0, 0, 0)
        end
        distance = #(GetEntityCoords(PlayerPedId()) - self.coords)
        if distance < 5.0 then
            DrawTextUI(locale('press_e_to_enter'))
            if IsControlJustReleased(0, 38) then
                OpenImpoundMenu(self.data, self.name)
            end
        end
    end
   local box = lib.zones.box({
    coords = v.coords,
    size = vec3(v.distance),
    rotation = 0,
    debug = Debug,
    inside = onImpound,
    onEnter = onEnterImpound,
    onExit = onExitImpound,
    data = v,
    name = k,
})  
end
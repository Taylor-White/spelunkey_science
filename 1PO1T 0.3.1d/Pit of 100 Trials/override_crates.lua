
local override_crates = {
    active = false;
    potential_items = {ENT_TYPE.ITEM_PICKUP_BOMBBAG, ENT_TYPE.ITEM_PICKUP_ROPEPILE, ENT_TYPE.ITEM_PICKUP_PARACHUTE, ENT_TYPE.ITEM_MACHETE, ENT_TYPE.ITEM_PICKUP_BOMBBOX, ENT_TYPE.ITEM_PICKUP_PASTE, ENT_TYPE.ITEM_PICKUP_SPRINGSHOES, ENT_TYPE.ITEM_PICKUP_SPIKESHOES, ENT_TYPE.ITEM_BOOMERANG, ENT_TYPE.ITEM_PICKUP_CLIMBINGGLOVES, ENT_TYPE.ITEM_SHOTGUN, ENT_TYPE.ITEM_MATTOCK, ENT_TYPE.ITEM_TELEPORTER, ENT_TYPE.ITEM_CROSSBOW, ENT_TYPE.ITEM_FREEZERAY, ENT_TYPE.ITEM_CAPE, ENT_TYPE.ITEM_POWERPACK, ENT_TYPE.ITEM_JETPACK, ENT_TYPE.ITEM_TELEPORTER_BACKPACK, ENT_TYPE.ITEM_HOVERPACK, ENT_TYPE.ITEM_PLASMACANNON}; --new list of items that can spawn from crates
    overriden_uids = {}; --UIDs of crates that have already been overriden
}
function override_crates.reset()
    override_crates.active = false
    override_crates.overriden_uids = {}
end
set_callback(function()
    if override_crates.active == true then
        for _, v in ipairs(get_entities_by_type(ENT_TYPE.ITEM_CRATE)) do
            local roll = math.random(1, 104)
            local reward = ENT_TYPE.ITEM_PICKUP_BOMBBAG
            if in_range(roll, 1, 34) then
                reward = ENT_TYPE.ITEM_PICKUP_BOMBBAG
            elseif in_range(roll, 35, 68) then
                reward = ENT_TYPE.ITEM_PICKUP_ROPEPILE
            elseif in_range(roll, 69, 76) then
                reward = ENT_TYPE.ITEM_PICKUP_PARACHUTE
            elseif in_range(roll, 76, 77) then
                reward = ENT_TYPE.ITEM_MACHETE
            elseif in_range(roll, 78, 79) then
                reward = ENT_TYPE.ITEM_PICKUP_BOMBBOX
            elseif in_range(roll, 80, 81) then
                reward = ENT_TYPE.ITEM_PICKUP_PASTE
            elseif in_range(roll, 82, 83) then
                reward = ENT_TYPE.ITEM_PICKUP_SPIKESHOES
            elseif in_range(roll, 84, 85) then
                reward = ENT_TYPE.ITEM_PICKUP_SPRINGSHOES
            elseif in_range(roll, 86, 87) then
                reward = ENT_TYPE.ITEM_BOOMERANG
            elseif in_range(roll, 88, 89) then
                reward = ENT_TYPE.ITEM_PICKUP_PITCHERSMITT
            elseif in_range(roll, 90, 91) then
                reward = ENT_TYPE.ITEM_PICKUP_CLIMBINGGLOVES
            elseif in_range(roll, 92, 93) then
                reward = ENT_TYPE.ITEM_MATTOCK
            elseif in_range(roll, 94, 95) then
                reward = ENT_TYPE.ITEM_TELEPORTER
            elseif in_range(roll, 96, 97) then
                reward = ENT_TYPE.ITEM_SHOTGUN
            elseif in_range(roll, 96, 98) then
                reward = ENT_TYPE.ITEM_FREEZERAY
            elseif in_range(roll, 99, 100) then
                reward = ENT_TYPE.ITEM_JETPACK
            elseif in_range(roll, 101, 102) then
                reward = ENT_TYPE.ITEM_HOVERPACK
            elseif in_range(roll, 103, 104) then
                reward = ENT_TYPE.ITEM_TELEPORTER_BACKPACK
            elseif roll == 105 then
                reward = ENT_TYPE.ITEM_POWERPACK
            end
            local is_overriden = false
            for _, l in ipairs(override_crates.overriden_uids) do
                if v == l then
                    is_overriden = true
                end
            end
            if is_overriden == false then --replace contents
                table.insert(override_crates.overriden_uids, v)
                local ent = get_entity(v)
                if ent ~= nil and ent.type.id == ENT_TYPE.ITEM_CRATE then
                    set_contents(ent.uid, reward) 
                end
            end
        end
    end
end, ON.FRAME)

return override_crates
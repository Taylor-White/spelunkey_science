
local honorbound_controller = {
    active = false;
    bombs = false;
    ropes = false;
    projectiles = false;
    perks = false;
    items = false;
    pickups = false;
    stolen_items = {};
    stolen_items_custom_override = {}; --used for custom items (butchers knife, butterfly knife etc.)
}
function honorbound_controller.pickup_to_powerup(id)
    if id == ENT_TYPE.ITEM_PICKUP_SPECTACLES then
        return ENT_TYPE.ITEM_POWERUP_SPECTACLES
    end
    if id == ENT_TYPE.ITEM_PICKUP_CLIMBINGGLOVES then
        return ENT_TYPE.ITEM_POWERUP_CLIMBING_GLOVES
    end
    if id == ENT_TYPE.ITEM_PICKUP_PITCHERSMITT then
        return ENT_TYPE.ITEM_POWERUP_PITCHERSMITT
    end
    if id == ENT_TYPE.ITEM_PICKUP_SPRINGSHOES then
        return ENT_TYPE.ITEM_POWERUP_SPRING_SHOES
    end
    if id == ENT_TYPE.ITEM_PICKUP_SPIKESHOES then
        return ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES
    end
    if id == ENT_TYPE.ITEM_PICKUP_PASTE then
        return ENT_TYPE.ITEM_POWERUP_PASTE
    end
    if id == ENT_TYPE.ITEM_PICKUP_COMPASS then
        return ENT_TYPE.ITEM_POWERUP_COMPASS
    end
    if id == ENT_TYPE.ITEM_PICKUP_SPECIALCOMPASS then
        return ENT_TYPE.ITEM_POWERUP_SPECIALCOMPASS
    end
    if id == ENT_TYPE.ITEM_PICKUP_TRUECROWN then
        return ENT_TYPE.ITEM_POWERUP_TRUECROWN
    end
    if id == ENT_TYPE.ITEM_PICKUP_HEDJET then
        return ENT_TYPE.ITEM_POWERUP_HEDJET
    end
    if id == ENT_TYPE.ITEM_PICKUP_CROWN then
        return ENT_TYPE.ITEM_POWERUP_CROWN
    end
    if id == ENT_TYPE.ITEM_PICKUP_EGGPLANTCROWN then
        return ENT_TYPE.ITEM_POWERUP_EGGPLANTCROWN
    end
    return id
end
function honorbound_controller.set_honorbound_state(state)
    if state == true then
        honorbound_controller.take_items()
        honorbound_controller.disable_perks()
        honorbound_controller.disable_items()
        toast_override("Honorbound! It's just you and your whip!")
    else
        honorbound_controller.return_items()
        honorbound_controller.reset()
    end
end
function honorbound_controller.powerup_to_pickup(id)
    if id == ENT_TYPE.ITEM_POWERUP_SPECTACLES then
        return ENT_TYPE.ITEM_PICKUP_SPECTACLES
    end
    if id == ENT_TYPE.ITEM_POWERUP_CLIMBING_GLOVES then
        return ENT_TYPE.ITEM_PICKUP_CLIMBINGGLOVES
    end
    if id == ENT_TYPE.ITEM_POWERUP_PITCHERSMITT then
        return ENT_TYPE.ITEM_PICKUP_PITCHERSMITT
    end
    if id == ENT_TYPE.ITEM_POWERUP_SPRING_SHOES then
        return ENT_TYPE.ITEM_PICKUP_SPRINGSHOES
    end
    if id == ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES then
        return ENT_TYPE.ITEM_PICKUP_SPIKESHOES
    end
    if id == ENT_TYPE.ITEM_POWERUP_PASTE then
        return ENT_TYPE.ITEM_PICKUP_PASTE
    end
    if id == ENT_TYPE.ITEM_POWERUP_COMPASS then
        return ENT_TYPE.ITEM_PICKUP_COMPASS
    end
    if id == ENT_TYPE.ITEM_POWERUP_SPECIALCOMPASS then
        return ENT_TYPE.ITEM_PICKUP_SPECIALCOMPASS
    end
    if id == ENT_TYPE.ITEM_POWERUP_TRUECROWN then
        return ENT_TYPE.ITEM_PICKUP_TRUECROWN
    end
    if id == ENT_TYPE.ITEM_POWERUP_HEDJET then
        return ENT_TYPE.ITEM_PICKUP_HEDJET
    end
    if id == ENT_TYPE.ITEM_POWERUP_CROWN then
        return ENT_TYPE.ITEM_PICKUP_CROWN
    end
    if id == ENT_TYPE.ITEM_POWERUP_EGGPLANTCROWN then
        return ENT_TYPE.ITEM_PICKUP_EGGPLANTCROWN
    end
    return id
end
function honorbound_controller.reset()
    honorbound_controller.active = false
    honorbound_controller.bombs = false
    honorbound_controller.ropes = false
    honorbound_controller.projectiles = false
    honorbound_controller.perks = false
    honorbound_controller.pickups = false
    honorbound_controller.items = false
    honorbound_controller.stolen_items = {}
    honorbound_controller.stolen_items_custom_override = {}
end
function honorbound_controller.disable_perks()
    honorbound_controller.perks = true
    game_controller.has_midastouch = 0
    game_controller.has_crateperk = 0
    game_controller.has_returnpostage = 0
    game_controller.has_payoffpain = 0
    game_controller.has_payoffpain_start = 0
    game_controller.has_stunshield = 0
    game_controller.has_sparkshield = 0
    game_controller.has_firewhip = 0
    game_controller.has_groundpound = 0
    game_controller.has_ropereclaimer = 0
end
function honorbound_controller.disable_items()
    honorbound_controller.items = true
end
function honorbound_controller.take_items()
    local items = entity_get_items_by(players[1].uid, 0, 0) 
    for i, v in ipairs(items) do
        local ent = get_entity(v)
        table.insert(honorbound_controller.stolen_items, ent.type.id)
        if is_cursegun(v) then
            honorbound_controller.stolen_items_custom_override[i] = "CURSEGUN"
        end
        if is_butterflyknife(v) then
            honorbound_controller.stolen_items_custom_override[i] = "BUTTERFLYKNIFE"
        end
        if is_butchersknife(v) then
            honorbound_controller.stolen_items_custom_override[i] = "BUTCHERKNIFE"
        end
        if is_maggotgun(v) then
            honorbound_controller.stolen_items_custom_override[i] = "MAGGOTGUN"
        end
        if ent.type.id ~= ENT_TYPE.ITEM_JETPACK and ent.type.id ~= ENT_TYPE.ITEM_POWERPACK and ent.type.id ~= ENT_TYPE.ITEM_TELEPORTER_BACKPACK and ent.type.id ~= ENT_TYPE.ITEM_HOVERPACK then
            kill_entity(v)
            players[1]:remove_powerup(ent.type.id)
        else
            --remove backpacks
            ent.y = -900
            kill_entity(v)
        end
    end
end
function honorbound_controller.return_items()
    local px, py, pl = get_position(players[1].uid)
    for i, v in ipairs(honorbound_controller.stolen_items, v) do 
        --powerups are greater than 543
        if v > 543 then
            local ret = honorbound_controller.powerup_to_pickup(v)
            spawn(ret, px, py, pl, 0, 0)
        else
            local item = spawn(v, px, py, pl, 0, 0)
            if honorbound_controller.stolen_items_custom_override[i] ~= nil then
                if honorbound_controller.stolen_items_custom_override[i] == "CURSEGUN" then
                    replace_freezeray_cursegun(item)
                end
                if honorbound_controller.stolen_items_custom_override[i] == "BUTCHERKNIFE" then
                    replace_machete_butcherknife(item)
                end
                if honorbound_controller.stolen_items_custom_override[i] == "BUTTERFLYKNIFE" then
                    replace_machete_butterflyknife(item)
                end
                if honorbound_controller.stolen_items_custom_override[i] == "MAGGOTGUN" then
                    replace_freezeray_maggotgun(item)
                end
            end
        end
    end
end

set_callback(function()
    honorbound_controller.reset()

end, ON.TRANSITION)
set_callback(function()
    honorbound_controller.reset()

end, ON.RESET)
set_callback(function()
    honorbound_controller.reset()

end, ON.LEVEL)
set_callback(function()
    honorbound_controller.reset()

end, ON.DEATH)

return honorbound_controller

butcherknife_machetes = {}
player_is_holding_butcherknife = false
player_was_holding_butcherknife = false

function replace_machete_butcherknife(machete_uid) 
    local ent = get_entity(machete_uid)
    if not ent then return end
    ent:set_texture(texturevars.butcherknife_item_texture)
    table.insert(butcherknife_machetes, machete_uid)
end
function is_butchersknife(machete_uid)
    for _, v in ipairs(butcherknife_machetes) do
        if machete_uid == v then return true end
    end
    return false
end
function is_holding_butcherknife(player_uid)
    if player_uid == false then return nil end
    local player = get_entity(player_uid)
    for _, v in ipairs(butcherknife_machetes) do
        if players[1].holding_uid == v then return true end
    end
    return false
end
function spawn_butcherknife(x, y, l, xvel, yvel)
    local butcherknife = get_entity(spawn(ENT_TYPE.ITEM_MACHETE, x, y, l, xvel, yvel))
    replace_machete_butcherknife(butcherknife.uid)
end
function do_butcherknife_effect()
    if players[1] ~= nil then
        player_is_holding_butcherknife = is_holding_butcherknife(players[1].uid)
        if player_is_holding_butcherknife == true then
            for _, v in ipairs(get_entities_by_type(enemies)) do
                local e = get_entity(v)
                local x, y, l = get_position(v)
                if e.health == 0 and e.color.r == 1.0 and player_is_holding_butcherknife == true then
                    local machete_ent = get_entity(players[1].holding_uid)
                    local machete_angle = machete_ent.angle
                    e.color.r = 0.99999
                    local roll = math.random(7)
                    if roll == 1 and machete_angle ~= 0 and machete_ent:overlaps_with(e) then --if the chance roll has been met, and the angle of the machete isnt 1 (therefore being swung) and if the distance is less than 1.5
                        spawn(ENT_TYPE.ITEM_PICKUP_COOKEDTURKEY, x, y, l, math.random(-2, 2)/10, math.random(1, 2)/10)
                    end
                end
            end
        end
    end
end
function bring_butcherknife_over()
    butcherknife_machetes = {} 
    if player_was_holding_butcherknife == true then
        player_was_holding_butcherknife = false
        replace_machete_butcherknife(players[1].holding_uid)
    end   
    if player_is_holding_butcherknife == true then
        player_is_holding_butcherknife = true
        player_was_holding_butcherknife = true
        replace_machete_butcherknife(players[1].holding_uid)
    end 
end
function clear_butcherknifes()
    butcherknife_machetes = {}
    player_is_holding_butcherknife = false
    player_was_holding_butcherknife = false 
end

set_callback(clear_butcherknifes, ON.RESET)
set_callback(clear_butcherknifes, ON.DEATH)
set_callback(bring_butcherknife_over, ON.TRANSITION)
set_callback(bring_butcherknife_over, ON.LEVEL)
set_callback(do_butcherknife_effect, ON.FRAME)
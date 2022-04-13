butterflyknife_machetes = {}
player_is_holding_butterflyknife = false
player_was_holding_butterflyknife = false

function replace_machete_butterflyknife(machete_uid) 
    local ent = get_entity(machete_uid)
    if not ent then return end
    ent:set_texture(texturevars.butterflyknife_item_texture)
    table.insert(butterflyknife_machetes, machete_uid)
end
function is_butterflyknife(machete_uid)
    for _, v in ipairs(butterflyknife_machetes) do
        if machete_uid == v then return true end
    end
    return false
end
function is_holding_butterflyknife(player_uid)
    if player_uid == false then return nil end
    local player = get_entity(player_uid)
    for _, v in ipairs(butterflyknife_machetes) do
        if players[1].holding_uid == v then return true end
    end
    return false
end
function spawn_butterflyknife(x, y, l, xvel, yvel)
    local butterflyknife = get_entity(spawn(ENT_TYPE.ITEM_MACHETE, x, y, l, xvel, yvel))
    replace_machete_butterflyknife(butterflyknife.uid)
end
function do_butterflyknife_effect()
    if players[1] ~= nil then
        player_is_holding_butterflyknife = is_holding_butterflyknife(players[1].uid)
        if player_is_holding_butterflyknife == true then
            for _, v in ipairs(get_entities_by_type(enemies)) do
                local e = get_entity(v)
                local x, y, l = get_position(v)
                local px, py, pl = get_position(players[1].uid)
                local machete_ent = get_entity(players[1].holding_uid)
                local machete_angle = machete_ent.angle
                if machete_angle ~= 0 and machete_ent:overlaps_with(e) and players[1].animation_frame > 65 then
                    if test_flag(players[1].flags, 17) and test_flag(e.flags, 17) then
                        e.health = 0
                        e.flags = set_flag(e.flags, 29)
                        play_vanilla_sound(VANILLA_SOUND.ENEMIES_KILLED_ENEMY)
                        play_vanilla_sound(VANILLA_SOUND.SHARED_IMPALED)
                        generate_particles(PARTICLEEMITTER.HITEFFECT_STARS_SMALL, e.uid)
                        generate_particles(PARTICLEEMITTER.HITEFFECT_SMACK, e.uid)
                    end
                    if not test_flag(players[1].flags, 17) and not test_flag(e.flags, 17) then
                        e.health = 0
                        e.flags = set_flag(e.flags, 29)
                        play_vanilla_sound(VANILLA_SOUND.ENEMIES_KILLED_ENEMY)
                        play_vanilla_sound(VANILLA_SOUND.SHARED_IMPALED)
                        generate_particles(PARTICLEEMITTER.HITEFFECT_STARS_SMALL, e.uid)
                        generate_particles(PARTICLEEMITTER.HITEFFECT_SMACK, e.uid)
                    end
                end
            end
        end
    end
end
function bring_butterflyknife_over()
    butterflyknife_machetes = {}
    if player_was_holding_butterflyknife == true then
        player_was_holding_butterflyknife = false
        replace_machete_butterflyknife(players[1].holding_uid)
    end    
    if player_is_holding_butterflyknife == true then
        player_is_holding_butterflyknife = true
        player_was_holding_butterflyknife = true
        replace_machete_butterflyknife(players[1].holding_uid)
    end
end
function clear_butterflyknifes()
    butterflyknife_machetes = {}
    player_is_holding_butterflyknife = false
    player_was_holding_butterflyknife = false 
end

set_callback(clear_butterflyknifes, ON.RESET)
set_callback(clear_butterflyknifes, ON.DEATH)
set_callback(bring_butterflyknife_over, ON.TRANSITION)
set_callback(bring_butterflyknife_over, ON.LEVEL)
set_callback(do_butterflyknife_effect, ON.FRAME)
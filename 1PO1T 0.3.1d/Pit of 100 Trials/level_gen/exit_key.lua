enemy_with_key = -1
exit_key_effect_uid = -1
exit_key_uid = -1
exit_key_spawned = false
exit_key_last_known_x = 0
exit_key_last_known_y = 0

function manage_effect_exit_key()
    local exit_key = get_entity(exit_key_effect_uid)
    local enemy_with_key_ent = get_entity(enemy_with_key)
    if (exit_key ~= nil) and (enemy_with_key_ent ~= nil) then
        local ewkx, ewky, ewkyl = get_position(enemy_with_key)
        if test_flag(enemy_with_key_ent.flags, 17) then
            exit_key.x = ewkx-(enemy_with_key_ent.velocityx*3)+0.6
            exit_key.flags = set_flag(exit_key.flags, 17)
        else
            exit_key.x = ewkx-(enemy_with_key_ent.velocityx*3)-0.6
            exit_key.flags = clr_flag(exit_key.flags, 17)
        end
        exit_key.y = ewky-(enemy_with_key_ent.velocityy*1.5)-0.35
    else
        kill_entity(exit_key_effect_uid)
        exit_key_effect_uid = -1
    end
end
function manage_exit_key()
    if level_type ~= "DEFAULT" then return end
    --track last known spot of exit key
    if exit_key_spawned then
        local key = get_entity(exit_key_uid)
        if key ~= nil then
            exit_key_last_known_x = key.x
            exit_key_last_known_y = key.y
        end
    end
    --spawn the exit key if the entity holding it dies or stops existing
    local enemy = get_entity(enemy_with_key)
    if enemy ~= nil and not exit_key_spawned then
        if enemy.health == 0 then
            local ex, ey, el = get_position(enemy_with_key)
            exit_key_spawned = true
            enemy_with_key = -1
            exit_key_uid = spawn(ENT_TYPE.ITEM_KEY, ex, ey, el, 0, 0)
            local key = get_entity(exit_key_uid)
            key:set_texture(texturevars.item_fancykey)
        end
    elseif enemy == nil and not exit_key_spawned then
        exit_key_spawned = true
        enemy_with_key = -1
        exit_key_uid = spawn(ENT_TYPE.ITEM_KEY, exit_key_last_known_x, exit_key_last_known_y, 0, 0, 0)
        local key = get_entity(exit_key_uid)
        key:set_texture(texturevars.item_fancykey)  
    end
    if exit_key_spawned and get_entity(exit_key_uid) == nil and game_controller.exit_spawned == false and enemy_with_key == -1 then
        local ex, ey, el = get_position(players[1].uid)
        exit_key_uid = spawn(ENT_TYPE.ITEM_KEY, ex, ey-0.5, el, 0, 0)    
        local key = get_entity(exit_key_uid)
        key:set_texture(texturevars.item_fancykey) 
        spawn(ENT_TYPE.FX_TELEPORTSHADOW, ex, ey-0.5, el, 0, 0)
        --sfx
        play_vanilla_sound(VANILLA_SOUND.SHARED_TELEPORT) 
    end
end
function clear_exit_key()
    enemy_with_key = -1
    exit_key_effect_uid = -1
    exit_key_uid = -1
    exit_key_spawned = false
    exit_key_last_known_x = 0
    exit_key_last_known_y = 0
end

set_callback(clear_exit_key, ON.PRE_LEVEL_GENERATION)
set_callback(manage_exit_key, ON.FRAME)
set_callback(manage_effect_exit_key, ON.FRAME)
cursegun_freezerays = {}
cursegun_shots = {}
cursegun_cooldowns = {}
player_is_holding_cursegun = false
player_was_holding_cursegun = false

function replace_freezeray_cursegun(freezeray_uid) 
    local ent = get_entity(freezeray_uid)
    if not ent then return end
    ent:set_texture(texturevars.cursegun_item_texture)
    generate_particles(PARTICLEEMITTER.CURSEDPOT_SMOKE, freezeray_uid)
    table.insert(cursegun_freezerays, freezeray_uid)
    table.insert(cursegun_cooldowns, 45)
end
function is_cursegun(freezeray_uid)
    for _, v in ipairs(cursegun_freezerays) do
        if freezeray_uid == v then return true end
    end
    return false
end
function is_holding_cursegun(player_uid)
    if player_uid == false then return nil end
    local player = get_entity(player_uid)
    for _, v in ipairs(cursegun_freezerays) do
        if players[1].holding_uid == v then return true end
    end
    return false
end
function spawn_cursegun(x, y, l, xvel, yvel)
    local cursegun = get_entity(spawn(ENT_TYPE.ITEM_FREEZERAY, x, y, l, xvel, yvel))
    replace_freezeray_cursegun(cursegun.uid)
end
function do_cursegun_effect()
    if players[1] ~= nil then
        player_is_holding_cursegun = is_holding_cursegun(players[1].uid)
    end
    for i, k in ipairs(cursegun_freezerays) do
        local cursegun = get_entity(k)
        if cursegun ~= nil then
            cursegun.cooldown = 80
            --check if the player can fire
            if players[1] ~= nil then
                local px, py, pl = get_position(players[1].uid)
                if players[1].holding_uid == k and players[1].state ~= 5 then
                    local player_slot = state.player_inputs.player_slot_1
                    if cursegun_cooldowns[i] == 45 and players[1].state == 12 then
                        play_vanilla_sound(VANILLA_SOUND.SHARED_BUBBLE_BURST_BIG)
                        cursegun_cooldowns[i] = 44
                        if test_flag(players[1].flags, 17) then
                            players[1].velocityx = 0.15
                            players[1].velocityy = 0.04
                            local curseshot = get_entity(spawn(ENT_TYPE.ITEM_PASTEBOMB, px-0.6, py, pl, -0.22, 0.045))
                            curseshot:set_texture(texturevars.curseball_item_texture)
                            table.insert(cursegun_shots, curseshot.uid)
                            curseshot.flags = set_flag(curseshot.flags, 4)
                            curseshot.flags = set_flag(curseshot.flags, 5)
                            curseshot.flags = clr_flag(curseshot.flags, 13)
                            curseshot.flags = clr_flag(curseshot.flags, 14)
                            set_timeout(function()
                                curseshot.flags = clr_flag(curseshot.flags, 4)
                                curseshot.flags = clr_flag(curseshot.flags, 5)
                                curseshot.flags = set_flag(curseshot.flags, 13)
                                --if the curseball is inside of a wall teleport it out before this graceperiod
                                for _, l in ipairs(get_entities_overlapping_hitbox(0, MASK.FLOOR | MASK.ACTIVEFLOOR, get_hitbox(curseshot.uid), curseshot.layer)) do
                                    local floor = get_entity(l)
                                    local bx, by, bl = get_position(curseshot.uid)
                                    if test_flag(floor.flags, 3) then
                                        curseshot.flags = set_flag(curseshot.flags, 28)
                                        local curse1 = get_entity(spawn(ENT_TYPE.ITEM_CURSING_CLOUD, bx, by, bl, -0.05, 0))
                                        curse1.flags = set_flag(curse1.flags, 17)
                                        local curse2 = get_entity(spawn(ENT_TYPE.ITEM_CURSING_CLOUD, bx, by, bl, 0.05, 0))
                                        play_vanilla_sound(VANILLA_SOUND.FX_FX_CURSE)
                                        play_vanilla_sound(VANILLA_SOUND.ENEMIES_GHOST_SPLIT)
                                        generate_particles(PARTICLEEMITTER.CURSEDPOT_SMOKE, curseshot.uid)
                                        curseshot.x = -900 
                                    end
                                end
                            end, 1)
                        else
                            players[1].velocityx = -0.15
                            players[1].velocityy = 0.04
                            local curseshot = get_entity(spawn(ENT_TYPE.ITEM_PASTEBOMB, px+0.6, py, pl, 0.22, 0.045))
                            curseshot:set_texture(texturevars.curseball_item_texture)
                            table.insert(cursegun_shots, curseshot.uid)
                            curseshot.flags = set_flag(curseshot.flags, 4)
                            curseshot.flags = set_flag(curseshot.flags, 5)
                            curseshot.flags = clr_flag(curseshot.flags, 13)
                            curseshot.flags = clr_flag(curseshot.flags, 14)
                            set_timeout(function()
                                curseshot.flags = clr_flag(curseshot.flags, 4)
                                curseshot.flags = clr_flag(curseshot.flags, 5)
                                curseshot.flags = set_flag(curseshot.flags, 13)
                                --if the curseball is inside of a wall teleport it out before this graceperiod
                                for p, l in ipairs(get_entities_overlapping_hitbox(0, MASK.FLOOR | MASK.ACTIVEFLOOR, get_hitbox(curseshot.uid), curseshot.layer)) do
                                    local floor = get_entity(l)
                                    local bx, by, bl = get_position(curseshot.uid)
                                    if test_flag(floor.flags, 3) then
                                        curseshot.flags = set_flag(curseshot.flags, 28)
                                        local curse1 = get_entity(spawn(ENT_TYPE.ITEM_CURSING_CLOUD, bx, by, bl, -0.05, 0))
                                        curse1.flags = set_flag(curse1.flags, 17)
                                        local curse2 = get_entity(spawn(ENT_TYPE.ITEM_CURSING_CLOUD, bx, by, bl, 0.05, 0))
                                        play_vanilla_sound(VANILLA_SOUND.FX_FX_CURSE)
                                        play_vanilla_sound(VANILLA_SOUND.ENEMIES_GHOST_SPLIT)
                                        curseshot.x = -900
                                    end
                                end
                            end, 1)
                        end
                        if players[1]:is_button_held(1) then
                            players[1].velocityy = 0.2
                        end
                    end
                end
            end
        end
    end
    --manage freezeray cooldowns
    for i, k in ipairs(cursegun_cooldowns) do
        if cursegun_cooldowns[i] < 45 then
            cursegun_cooldowns[i] = cursegun_cooldowns[i] - 1
        end
        if cursegun_cooldowns[i] == 0 then
            cursegun_cooldowns[i] = 45
        end
    end
    --curseball
    for i, v in ipairs(cursegun_shots) do
        local bomb = get_entity(v)
        if bomb ~= nil then
            local bx, by, bl = get_position(v)
            if bomb.velocityy == 0 then
                bomb.flags = set_flag(bomb.flags, 28)
                local curse1 = get_entity(spawn(ENT_TYPE.ITEM_CURSING_CLOUD, bx, by, bl, -0.05, 0))
                curse1.flags = set_flag(curse1.flags, 17)
                local curse2 = get_entity(spawn(ENT_TYPE.ITEM_CURSING_CLOUD, bx, by, bl, 0.05, 0))
                play_vanilla_sound(VANILLA_SOUND.FX_FX_CURSE)
                play_vanilla_sound(VANILLA_SOUND.ENEMIES_GHOST_SPLIT)
                generate_particles(PARTICLEEMITTER.CURSEDPOT_SMOKE, v)
                bomb.x = -900
                table.remove(cursegun_shots, i) 
            end
        end  
    end
end
function bring_cursegun_over()
    cursegun_freezerays = {}
    cursegun_shots = {}
    cursegun_cooldowns = {}
    if player_was_holding_cursegun == true then
        player_was_holding_cursegun = false
        replace_freezeray_cursegun(players[1].holding_uid)
    end
    if player_is_holding_cursegun == true then
        player_is_holding_cursegun = true
        player_was_holding_cursegun = true
        replace_freezeray_cursegun(players[1].holding_uid)
    end
end
function clear_curseguns()
    cursegun_freezerays = {}
    cursegun_shots = {}
    cursegun_cooldowns = {}
    player_is_holding_cursegun = false
    player_was_holding_cursegun = false
end



set_callback(clear_curseguns, ON.RESET)
set_callback(clear_curseguns, ON.DEATH)
set_callback(bring_cursegun_over, ON.TRANSITION)
set_callback(bring_cursegun_over, ON.LEVEL)
set_callback(do_cursegun_effect, ON.FRAME)
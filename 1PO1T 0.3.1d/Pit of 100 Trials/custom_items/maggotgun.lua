maggotgun_freezerays = {}
maggotgun_shots = {}
maggotgun_cooldowns = {}
player_is_holding_maggotgun = false
player_was_holding_maggotgun = false

function replace_freezeray_maggotgun(freezeray_uid) 
    local ent = get_entity(freezeray_uid)
    if not ent then return end
    ent:set_texture(texturevars.maggotgun_item_texture)
    table.insert(maggotgun_freezerays, freezeray_uid)
    table.insert(maggotgun_cooldowns, 25)
end
function is_maggotgun(freezeray_uid)
    for _, v in ipairs(maggotgun_freezerays) do
        if freezeray_uid == v then return true end
    end
    return false
end
function is_holding_maggotgun(player_uid)
    if player_uid == false then return nil end
    local player = get_entity(player_uid)
    for _, v in ipairs(maggotgun_freezerays) do
        if players[1].holding_uid == v then return true end
    end
    return false
end
function spawn_maggotgun(x, y, l, xvel, yvel)
    local maggotgun = get_entity(spawn(ENT_TYPE.ITEM_FREEZERAY, x, y, l, xvel, yvel))
    replace_freezeray_maggotgun(maggotgun.uid)
end
function do_maggotgun_effect()
    if players[1] ~= nil then
        player_is_holding_maggotgun = is_holding_maggotgun(players[1].uid)
    end
    for i, k in ipairs(maggotgun_freezerays) do
        local maggotgun = get_entity(k)
        if maggotgun ~= nil then
            if maggotgun.cooldown ~= nil then
                maggotgun.cooldown = 80
            end
            if maggotgun.overlay == nil then
                maggotgun.angle = 7.15
                maggotgun.flags = set_flag(maggotgun.flags, 17)
                maggotgun.offsety = 0.18
            else
                maggotgun.angle = 0
            end
            --check if the player can fire
            if players[1] ~= nil then
                local px, py, pl = get_position(players[1].uid)
                if players[1].holding_uid == k and players[1].state ~= 5 then
                    local player_slot = state.player_inputs.player_slot_1
                    if maggotgun_cooldowns[i] == 25 and players[1].state == 12 then
                        play_vanilla_sound(VANILLA_SOUND.ITEMS_WEBGUN)
                        play_vanilla_sound(VANILLA_SOUND.ITEMS_WEBGUN_HIT)
                        play_vanilla_sound(VANILLA_SOUND.ENEMIES_EGGSAC_BURST)
                        maggotgun_cooldowns[i] = 24
                        players[1].velocityy = 0.1
                        if test_flag(players[1].flags, 17) then
                            players[1].velocityx = 0.2
                            for i=1, 6, 1 do
                                local maggot = get_entity(spawn(ENT_TYPE.ITEM_ROCK, px-0.8-math.random(-2, 2)/10, py+0.1+math.random(-50, 400)/1000, pl, -math.random(10, 20)/100, math.random(100, 250)/1000))
                                maggot.flags = set_flag(maggot.flags, 17)
                                maggot:set_texture(texturevars.maggotrock_item_texture)
                                generate_particles(PARTICLEEMITTER.GRUB_TRAIL, maggot.uid)
                                table.insert(maggotgun_shots, maggot.uid)
                            end
                        else
                            players[1].velocityx = -0.2
                            for i=1, 6, 1 do
                                local maggot = get_entity(spawn(ENT_TYPE.ITEM_ROCK, px+0.8+math.random(-2, 2)/10, py+0.1+math.random(-50, 400)/1000, pl, math.random(10, 20)/100, math.random(100, 250)/1000))
                                maggot:set_texture(texturevars.maggotrock_item_texture)
                                generate_particles(PARTICLEEMITTER.GRUB_TRAIL, maggot.uid)
                                table.insert(maggotgun_shots, maggot.uid)
                            end      
                        end
                    end
                end
            end
        end
    end
    for i, v in ipairs(maggotgun_shots) do
        local ent = get_entity(v)
        if ent ~= nil then
            ent.angle = ent.angle - (ent.velocityx + ent.velocityy)*3
            if ent.velocityx == 0 and ent.velocityy == 0 then
                set_timeout(function()
                local grub = get_entity(spawn(ENT_TYPE.MONS_GRUB, ent.x, ent.y, ent.layer, 0, 0))
                local gx, gy, gl = get_position(grub.uid)
                grub.animation_frame = 0
                grub.width = grub.width/2
                grub.height = grub.height/2
                grub.hitboxx = grub.hitboxx/2   
                grub.hitboxy = grub.hitboxy/2
                grub:set_draw_depth(25)
                set_timeout(function()
                    if get_entity(grub.uid) ~= nil then
                        local fly = get_entity(spawn(ENT_TYPE.ITEM_FLY, gx, gy+0.5, gl, -0.04, 0))
                        fly.flags = set_flag(fly.flags, 17)
                        if math.random(2) == 1 then
                            play_looped_sound_at_entity(VANILLA_SOUND.ENEMIES_MUMMY_FLIES_LOOP, fly.uid)
                        end
                        local fly = get_entity(spawn(ENT_TYPE.ITEM_FLY, gx, gy+0.5, gl, 0.04, 0))
                        kill_entity(grub.uid)
                    end    
                end, 30+math.random(-15, 15))
                ent.x = -900
                end, 3)
            end
        end
    end
    --manage gun cooldowns
    for i, k in ipairs(maggotgun_cooldowns) do
        if maggotgun_cooldowns[i] < 25 then
            maggotgun_cooldowns[i] = maggotgun_cooldowns[i] - 1
        end
        if maggotgun_cooldowns[i] == 0 then
            maggotgun_cooldowns[i] = 25
        end
    end
end
function bring_maggotgun_over()
    maggotgun_freezerays = {}
    maggotgun_shots = {}
    maggotgun_cooldowns = {}
    if player_was_holding_maggotgun == true then
        player_was_holding_maggotgun = false
        replace_freezeray_maggotgun(players[1].holding_uid)
    end
    if player_is_holding_maggotgun == true then
        player_is_holding_maggotgun = true
        player_was_holding_maggotgun = true
        replace_freezeray_maggotgun(players[1].holding_uid)
    end
end
function clear_maggotguns()
    maggotgun_freezerays = {}
    maggotgun_shots = {}
    maggotgun_cooldowns = {}
    player_is_holding_maggotgun = false
    player_was_holding_maggotgun = false
end



set_callback(clear_maggotguns, ON.RESET)
set_callback(clear_maggotguns, ON.DEATH)
set_callback(bring_maggotgun_over, ON.TRANSITION)
set_callback(bring_maggotgun_over, ON.LEVEL)
set_callback(do_maggotgun_effect, ON.FRAME)
beg_angry = false
beg_attack_floor = 0
beg_spawned = false
beg_id = -1
beg_passive_id = -1
beg_lives = 5
beg_hunter_spoke = false

function find_valid_beg_spawn()
    local px, py, pl = get_position(players[1].uid)
    local valid_spawn = false
    local xroll = math.random(-7, 7)
    local yroll = math.random(-7, 7)
    local validx = 0
    local validy = 0
    local tries = 0
    --keep trying to find a valid spot
    while valid_spawn == false do
        --check if the given spot is free
        if is_valid_beg_spawn(px+xroll, py+yroll, pl) == true then
            --if it is, break the loop by setting valid_spawn to true
            valid_spawn = true
            validx = px+xroll
            validy = py+yroll
        else
            --if it isnt, reroll and try again
            xroll = math.random(-7, 7)
            yroll = math.random(-7, 7)
        end
        if tries >= 500 then --failsafe for if no spot is found
            return px, py
        end
        tries = tries+1
    end
    return validx, validy
end
function is_valid_beg_spawn(x, y, l)
    --check if the spawn is out of bounds
    if x < 1 or x > 80 then
        return false
    end
    if y < 57 or y > 124 then
        return false
    end

    --checks if the given spot is empty
    if get_entities_at(0, 0, x, y, l, 1)[1] == nil then
        return true
    end
    return false
end
function spawn_beg()
    spawn_x, spawn_y = find_valid_beg_spawn()
    beg_id = spawn(ENT_TYPE.MONS_HUNDUNS_SERVANT, spawn_x, spawn_y, 0, 0, 0)
    beg_spawned = true
    spawn(ENT_TYPE.FX_TELEPORTSHADOW, spawn_x, spawn_y, 0, 0, 0)
    play_vanilla_sound(VANILLA_SOUND.SHARED_TELEPORT)
    local beg = get_entity(beg_id)
    beg.flags = clrflag(beg.flags, 25) -- disable 'passes through player'
    beg.move_state = 6 -- activate aggro AI
end
function check_beg_spawn()
    beg_id = -1
    beg_spawned = false
    if beg_angry and game_controller.floor >= beg_attack_floor and determine_given_floor_type(game_controller.floor) == "DEFAULT" and beg_lives > 0 then
        set_timeout(function()
            spawn_beg()
        end, 22*60)
    elseif beg_angry and game_controller.floor >= beg_attack_floor and determine_given_floor_type(game_controller.floor) == "DEFAULT" and beg_lives <= 0 then
        spawn_passive_beg()
    end
end
function reset_beg_hunter()
    beg_angry = false
    beg_attack_floor = 0
    beg_spawned = false
    beg_id = -1
    beg_passive_id = -1
    beg_lives = 5
    beg_hunter_spoke = false
end
function respawn_beg()
    if determine_given_floor_type(game_controller.floor) == "DEFAULT" then
        if #get_entities_by_type(ENT_TYPE.MONS_HUNDUNS_SERVANT) == 0 and beg_angry and beg_spawned and game_controller.floor >= beg_attack_floor and beg_lives > 0 then
            spawn_beg()
        end
        if #get_entities_by_type(ENT_TYPE.MONS_HUNDUNS_SERVANT) ~= 0 and beg_angry and beg_spawned and game_controller.floor >= beg_attack_floor and beg_lives > 0 then
            if players[1] ~= nil then
                if distance(players[1].uid, beg_id) > 10 then
                    local beg = get_entity(beg_id)
                    beg:remove()
                    spawn_beg()
                end
            end
        end
    end
end
function spawn_passive_beg()
    local spawn_x, spawn_y, _ = get_position(players[1].uid)
    local roll = math.random(-1, 1)
    beg_id = -1
    beg_passive_id = spawn(ENT_TYPE.MONS_HUNDUNS_SERVANT, spawn_x+roll, spawn_y, 0, 0, 0)
    spawn(ENT_TYPE.FX_TELEPORTSHADOW, spawn_x+roll, spawn_y, 0, 0, 0)
    play_vanilla_sound(VANILLA_SOUND.SHARED_TELEPORT)
    beg_spawned = true
    beg_angry = false
end
function manage_passive_beg()
    if get_entity(beg_passive_id) ~= nil then
        local beg = get_entity(beg_passive_id)
        local player_within_range = false
        local bx, by, bl = get_position(beg_passive_id)
        local px, py, pl = get_position(players[1].uid)
        if (distance(players[1].uid, beg_passive_id) < 3) and (py < by+1) and (py > by-1) then
            player_within_range = true
        end
        if player_within_range and not beg_hunter_spoke then
            beg_hunter_spoke = true
            say_override(beg_passive_id, "I'm impressed! Most who provoke me are dead by now, yet still you stand! Here, take this!", 1, false)
            set_timeout(function()
                local bx, by, bl = get_position(beg_passive_id)
                if get_entity(beg_passive_id) ~= nil then
                    local tc = get_entity(spawn(ENT_TYPE.ITEM_PICKUP_TRUECROWN, bx, by, bl, 0, 0.1))
                    tc.flags = set_flag(tc.flags, 4)
                    set_timeout(function()
                        tc.flags = clr_flag(tc.flags, 4)
                    end, 3)
                    local rock = get_entity(spawn(ENT_TYPE.ITEM_ROCK, bx-0.1, by, bl, 2, 0))
                    rock.flags = set_flag(rock.flags, 1)
                    set_timeout(function()
                        kill_entity(rock.uid)
                    end, 2)
                end
            end, 5*60)
        end
    end
end
set_callback(respawn_beg, ON.FRAME)
set_callback(manage_passive_beg, ON.FRAME)
set_callback(check_beg_spawn, ON.POST_LEVEL_GENERATION)
set_po1t_callback(function() if level_type == "DEFAULT" and beg_angry then beg_lives = beg_lives-1 end end, PO1T_ON.EXIT_UNLOCKED)
set_callback(reset_beg_hunter, ON.DEATH)
set_callback(reset_beg_hunter, ON.RESET)
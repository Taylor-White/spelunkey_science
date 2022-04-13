
local boss_controller = {
    --BOMB DISABLER
    spawned_bombs = {}; --UIDS of bombs that were attemped to be used so that we can return them
    spawned_ropes = {};
    --QUILLBACK
    quillback_killed = false;
    quillback_active = false;
    quillback_spawned_minions = false;
    quillback_state = 0;
    quillback_anger_timer = 120;
    quillback_uid = -1;
    quill_health_previous = 10;
    quillback_gibs_timer = 120;
    quillback_last_x = 0;
    quillback_last_y = 0;
    quillback_size = 0;

    quillback_roll_timer = 140;
    quillback_attack_choice = 0; --1 would be jump and smash that does damage

    caveman_lizards = {};

    attack_cooldown = 90; --time before quillback will use the stomp attack again
    attack_direction = 1; --the direction willback will move in during the stomp
    attack_spin_cooldown = 30; --time before quillback will get gravity back and fall onto the ground. this starts running after he does his fancy little spin
    hit_ground = true; --used for the stun effect along with other effects
}
function boss_controller.reset() 
    boss_controller.spawned_bombs = {}
    boss_controller.spawned_ropes = {}

    --QUILLBACK
    boss_controller.quillback_killed = false
    boss_controller.quillback_active = false
    boss_controller.quillback_spawned_minions = false
    boss_controller.quillback_state = 0
    boss_controller.quillback_anger_timer = 120
    boss_controller.quillback_uid = -1
    boss_controller.quill_health_previous = 10
    boss_controller.quillback_gibs_timer = 120
    boss_controller.quillback_last_x = 0
    boss_controller.quillback_last_y = 0
    boss_controller.quillback_size = 0

    boss_controller.quillback_roll_timer = 140
    boss_controller.quillback_attack_choice = 0

    boss_controller.caveman_lizards = {}

    boss_controller.attack_cooldown = 90
    boss_controller.attack_direction = 1
    boss_controller.attack_spin_cooldown = 30
    boss_controller.hit_ground = true
end


--MANAGE BOSSES
set_callback(function()
    if boss_controller.quillback_active == true and players[1] ~= nil then
        --adjust quillbacks visuals relative to his HP
        local quill = get_entity(boss_controller.quillback_uid)
        --glorious gib-splosion
        if quill == nil then
            --kill any leftover caveman
            for _, v in ipairs(get_entities_by_type(ENT_TYPE.MONS_CAVEMAN, ENT_TYPE.MONS_HORNEDLIZARD)) do
                kill_entity(v)
            end
            if boss_controller.quillback_gibs_timer > 0 then
                if boss_controller.quillback_gibs_timer == 120 then --screen shake
                    shake_camera(119, 119, 5, 5, 5, true)
                    custom_music.stop_music()
                    spawn_playerbag_as_custom_pickup(boss_controller.quillback_last_x, boss_controller.quillback_last_y, 0, math.random(-1, 1)/40, math.random(1, 5)/50, "GROUNDPOUND")
                end
                if math.random(6) == 1 then
                    play_vanilla_sound(VANILLA_SOUND.TRAPS_BOULDER_EMERGE)
                end
                boss_controller.quillback_gibs_timer = boss_controller.quillback_gibs_timer - 1
                local rubble = get_entity(spawn(ENT_TYPE.ITEM_RUBBLE, boss_controller.quillback_last_x+math.random(-20, 20)/10, boss_controller.quillback_last_y+math.random(-20, 20)/10, 0, math.random(-2, 2)/15, math.random(1, 5)/15))
                rubble.animation_frame = 12
                local rubble = get_entity(spawn(ENT_TYPE.ITEM_RUBBLE, boss_controller.quillback_last_x+math.random(-20, 20)/10, boss_controller.quillback_last_y+math.random(-20, 20)/10, 0, math.random(-2, 2)/15, math.random(1, 5)/15))
                rubble.animation_frame = 5
                local rubble = get_entity(spawn(ENT_TYPE.ITEM_RUBBLE, boss_controller.quillback_last_x+math.random(-20, 20)/10, boss_controller.quillback_last_y+math.random(-20, 20)/10, 0, math.random(-2, 2)/15, math.random(1, 5)/15))
                rubble.animation_frame = 12
                local rubble = get_entity(spawn(ENT_TYPE.ITEM_RUBBLE, boss_controller.quillback_last_x+math.random(-20, 20)/10, boss_controller.quillback_last_y+math.random(-20, 20)/10, 0, math.random(-2, 2)/15, math.random(1, 5)/15))
                rubble.animation_frame = 5
                local rubble = get_entity(spawn(ENT_TYPE.ITEM_RUBBLE, boss_controller.quillback_last_x+math.random(-20, 20)/10, boss_controller.quillback_last_y+math.random(-20, 20)/10, 0, math.random(-2, 2)/15, math.random(1, 5)/15))
                rubble.animation_frame = 12
                local rubble = get_entity(spawn(ENT_TYPE.ITEM_RUBBLE, boss_controller.quillback_last_x+math.random(-20, 20)/10, boss_controller.quillback_last_y+math.random(-20, 20)/10, 0, math.random(-2, 2)/15, math.random(1, 5)/15))
                rubble.animation_frame = 5
                local rubble = get_entity(spawn(ENT_TYPE.ITEM_RUBBLE, boss_controller.quillback_last_x+math.random(-20, 20)/10, boss_controller.quillback_last_y+math.random(-20, 20)/10, 0, math.random(-2, 2)/15, math.random(1, 5)/15))
                --BLOOD
                for i=1, 20, 1 do
                    spawn(ENT_TYPE.ITEM_BLOOD, boss_controller.quillback_last_x+math.random(-20, 20)/10, boss_controller.quillback_last_y+math.random(-20, 20)/10, 0, math.random(-2, 2)/15, math.random(1, 5)/8)
                end
                --SPAWN EXIT
                if boss_controller.quillback_gibs_timer == 0 then
                    game_controller.floor = game_controller.floor + 1 --advance progression
                    game_controller.current_theme = THEME.CITY_OF_GOLD
                    door(17.5, 83.1, 0, game_controller.current_world, 1, game_controller.current_theme)
                    spawn(ENT_TYPE.BG_DOOR_LARGE, 18, 83+0.175+1.85, 0, 0, 0)
                    boss_controller.quillback_active = false
                    game_controller.exit_spawned = true
                    --return players stuff
                    honorbound_controller.set_honorbound_state(false)
                end 
            end
        end
        if quill == nil then return end
        --custom horned lizard / caveman thingie sounds
        for i, v in ipairs(boss_controller.caveman_lizards) do
            local ent = get_entity(v)
            if ent == nil then table.remove(boss_controller.caveman_lizards, i) end
            if ent ~= nil then
                if ent.state == 1 and ent.move_state == 2 then
                        play_vanilla_sound(VANILLA_SOUND.ENEMIES_CAVEMAN_TRIGGER)
                        play_vanilla_sound(VANILLA_SOUND.ENEMIES_BOSS_CAVEMAN_JUMP)
                end
                if ent.health == 0 and distance(ent.uid, players[1].uid) < 6 then --death sound
                    local roll = math.random(4)
                    if roll == 1 then
                        play_sound(assets.snd_caveman_die_1, 0.0075)
                    end
                    if roll == 2 then
                        play_sound(assets.snd_caveman_die_2, 0.0075)
                    end
                    if roll == 3 then
                        play_sound(assets.snd_caveman_die_3, 0.0075)
                    end
                    if roll == 4 then
                        play_sound(assets.snd_caveman_die_4, 0.0075)
                    end
                end
            end
        end
        boss_controller.quillback_last_x = quill.x
        boss_controller.quillback_last_y = quill.y
        if boss_controller.quillback_size == 1 then
            quill.hitboxy = 0.96
            quill.hitboxx = 0.88
            quill.color.g = 0.75
            quill.color.b = 0.75
            quill.color.r = 1
            quill.height = 2.4
            quill.width = 2.4  
        end
        if boss_controller.quillback_size == 2 then
            quill.hitboxy = 1.27
            quill.hitboxx = 1.17
            quill.color.g = 0.3
            quill.color.b = 0.3
            quill.color.r = 1
            quill.height = 3.18
            quill.width = 3.18
        end
        --kill whatever HURT quillback >:( (destroys throwables)
        if boss_controller.quill_health_previous > quill.health then
            for _, v in ipairs(get_entities_by_type(ENT_TYPE.ITEM_ROCK, ENT_TYPE.ITEM_METAL_ARROW, ENT_TYPE.ITEM_WOODEN_ARROW, ENT_TYPE.ITEM_BROKEN_ARROW, ENT_TYPE.ITEM_SKULL, ENT_TYPE.ITEM_POT, ENT_TYPE.MONS_CAVEMAN, ENT_TYPE.ITEM_CHEST, ENT_TYPE.MONS_HORNEDLIZARD)) do
                if distance(v, quill.uid) < quill.hitboxx*2 then
                    local ent = get_entity(v)
                    if ent.type.id ~= ENT_TYPE.MONS_CAVEMAN and ent.type.id ~= ENT_TYPE.MONS_HORNEDLIZARD then
                        generate_particles(PARTICLEEMITTER.CURSEDEFFECT_SKULL, v)
                        play_vanilla_sound(VANILLA_SOUND.PLAYER_DEATH_GHOST)
                    end
                    if ent.type.id == ENT_TYPE.MONS_HORNEDLIZARD and distance(players[1].uid, boss_controller.quillback_uid) < 6 then
                        local roll = math.random(4)
                        if roll == 1 then
                            play_sound(assets.snd_caveman_die_1, 0.007)
                        end
                        if roll == 2 then
                            play_sound(assets.snd_caveman_die_2, 0.007)
                        end
                        if roll == 3 then
                            play_sound(assets.snd_caveman_die_3, 0.007)
                        end
                        if roll == 4 then
                            play_sound(assets.snd_caveman_die_4, 0.007)
                        end
                    end
                    ent.x = -900
                end
            end
        end
        boss_controller.quill_health_previous = quill.health
        --AI STATES
        if boss_controller.quillback_state == 0 then --PHASE 1
            --spawn minions
            if boss_controller.quillback_spawned_minions == false and quill.move_state == 7 then
                boss_controller.quillback_spawned_minions = true
                local caveman1 = -1
                if not test_flag(quill.flags, 17) then
                    caveman1 = get_entity(spawn(ENT_TYPE.MONS_HORNEDLIZARD, quill.x-0.8, quill.y+1, 0, -8, 0.2))
                    caveman1.flags = set_flag(caveman1.flags, 17)
                else
                    caveman1 = get_entity(spawn(ENT_TYPE.MONS_HORNEDLIZARD, quill.x+0.8, quill.y+1, 0, 8, 0.2))
                end
                caveman1:set_texture(texturevars.quillback_minion_texture)
                caveman1.flags = set_flag(caveman1.flags, 4)
                table.insert(boss_controller.caveman_lizards, caveman1.uid)
                set_timeout(function()
                    caveman1.flags = clr_flag(caveman1.flags, 4)
                end, 20)
            end
            if quill.move_state ~= 7 then
                boss_controller.quillback_spawned_minions = false
            end
            --exit first phase
            if quill.health < 8 then
                if quill.standing_on_uid ~= -1 and quill.move_state == 5 then --make sure quill is on the ground first
                    boss_controller.quillback_state = 2 --angry state, jump and get bigger + redder
                end
            end
        end
        if boss_controller.quillback_state == 1 then --PHASE 2
            local ent = get_entity(v)
            --exit second phase
            if quill.health <= 1 then
                if quill.standing_on_uid ~= -1 then --make sure quill is on the ground first
                    quill.health = 5
                    boss_controller.quillback_state = 2 --angry state, jump and get bigger + redder
                end
            end
            --chase state (go towards player)  
            quill.state = 30
            if quill.move_state == 30 then
                boss_controller.attack_cooldown = boss_controller.attack_cooldown - 1
                    if boss_controller.attack_cooldown <= 50 then
                            if players[1].x > quill.x then
                                    quill.velocityx = 0.04
                                    quill.flags = clr_flag(quill.flags, 17)
                            else
                                    quill.velocityx = -0.04
                                    quill.flags = set_flag(quill.flags, 17)
                            end
                    else
                            quill.velocityx = 0
                    end
                    --shake the screen and stuff when quill hits the ground
                    if boss_controller.hit_ground == false and quill.standing_on_uid ~= -1 then
                        boss_controller.hit_ground = true
                        shake_camera(10, 10, 10, 10, 10, true)
                        play_vanilla_sound(VANILLA_SOUND.TRAPS_BOULDER_EMERGE)
                        play_vanilla_sound(VANILLA_SOUND.ENEMIES_BOSS_CAVEMAN_LAND)
                        --spawn more cavemen
                        local roll = math.random(4)
                        if roll == 1 or roll == 2 or roll == 3 then
                            local caveman1 = -1
                            if test_flag(quill.flags, 17) then
                                caveman1 = get_entity(spawn(ENT_TYPE.MONS_HORNEDLIZARD, quill.x-0.8, quill.y+1, 0, -8, 0.2))
                                caveman1.flags = set_flag(caveman1.flags, 17)
                            else
                                caveman1 = get_entity(spawn(ENT_TYPE.MONS_HORNEDLIZARD, quill.x+0.8, quill.y+1, 0, 8, 0.2))
                            end
                            caveman1:set_texture(texturevars.quillback_minion_texture)
                            table.insert(boss_controller.caveman_lizards, caveman1.uid)
                            caveman1.flags = set_flag(caveman1.flags, 4)
                            set_timeout(function()
                                caveman1.flags = clr_flag(caveman1.flags, 4)
                            end, 20)
                        end
                    end
                    --make sure quill is close enough and the attack cooldown is over
                    if distance(quill.uid, players[1].uid) < 6 and boss_controller.attack_cooldown <= 0 and quill.standing_on_uid ~= -1 then
                            quill.move_state = 31
                            boss_controller.attack_cooldown = 90
                            if quill.health < 3 then
                                boss_controller.attack_cooldown = 20
                            end
                            boss_controller.hit_ground = false
                            --determine attack direction
                            if players[1].x > quill.x then
                                boss_controller.attack_direction = 1
                            else
                                boss_controller.attack_direction = -1
                            end                               
                    end
            end
            --jump in the air
            if quill.move_state == 31 then
                    --only add yvel when quill is on something
                    if quill.standing_on_uid ~= -1 then
                            quill.velocityy = 0.25
                            play_vanilla_sound(VANILLA_SOUND.ENEMIES_BOSS_CAVEMAN_JUMP)
                    end
                    --move towards the player (unless we're already close enough)
                    if distance(quill.uid, players[1].uid) > 0.05 then
                            if boss_controller.attack_direction == 1 then
                                    quill.velocityx = 0.16
                            elseif boss_controller.attack_direction == -1 then
                                    quill.velocityx = -0.16
                            end
                    else
                            quill.velocityx = 0
                    end
                    --once we start falling exit this state
                    if quill.velocityy < 0 then
                            quill.move_state = 32
                            play_vanilla_sound(VANILLA_SOUND.SHARED_TRIP)
                    end
            end
            --do a spin in the air before ground pounding
            if quill.move_state == 32 then
                boss_controller.attack_spin_cooldown = boss_controller.attack_spin_cooldown-1
                    quill.velocityy = 0
                    --make quill spin
                    if boss_controller.attack_spin_cooldown > 10 then
                            if boss_controller.attack_direction == 1 then
                                    quill.angle = quill.angle - 0.33
                            end
                            if boss_controller.attack_direction == -1 then
                                    quill.angle = quill.angle + 0.33
                            end
                    else
                            quill.angle = 0      
                    end
                    quill.flags = set_flag(quill.flags, 10) --no gravitys

                    if boss_controller.attack_spin_cooldown <= 0 then
                        boss_controller.attack_spin_cooldown = 30
                            quill.flags = clr_flag(quill.flags, 10)
                            quill.angle = 0
                            quill.velocityy = -0.3
                            quill.move_state = 30
                    end
            end
        end
        --PHASE 3
        if boss_controller.quillback_state == 3 then
            ---STATE 30
            if quill.move_state == 30 then
                boss_controller.attack_cooldown = boss_controller.attack_cooldown - 1
                    if boss_controller.attack_cooldown <= 50 then
                            if players[1].x > quill.x then
                                    quill.velocityx = 0.04
                                    quill.flags = clr_flag(quill.flags, 17)
                            else
                                    quill.velocityx = -0.04
                                    quill.flags = set_flag(quill.flags, 17)
                            end
                    else
                            quill.velocityx = 0
                    end
                    --make sure quill is close enough and the attack cooldown is over
                    if distance(quill.uid, players[1].uid) < 8 and boss_controller.attack_cooldown <= 0 and quill.standing_on_uid ~= -1 then
                            quill.move_state = 31
                            boss_controller.attack_cooldown = 90
                            boss_controller.attack_spin_cooldown = 30
                            --determine attack direction
                            if players[1].x > quill.x then
                                boss_controller.attack_direction = 1
                            else
                                boss_controller.attack_direction = -1
                            end                               
                    end
                    --shake the ground
                    if boss_controller.hit_ground == false and quill.standing_on_uid ~= -1 then
                        boss_controller.hit_ground = true
                        shake_camera(10, 10, 10, 10, 10, true)
                        play_vanilla_sound(VANILLA_SOUND.TRAPS_BOULDER_EMERGE)
                        play_vanilla_sound(VANILLA_SOUND.ENEMIES_BOSS_CAVEMAN_LAND)
                        --spawn more cavemen
                        if math.random(1) == 1 then
                            local caveman1 = -1
                            if test_flag(quill.flags, 17) then
                                caveman1 = get_entity(spawn(ENT_TYPE.MONS_HORNEDLIZARD, quill.x-0.8, quill.y+1, 0, -8, 0.2))
                                caveman1.flags = set_flag(caveman1.flags, 17)
                            else
                                caveman1 = get_entity(spawn(ENT_TYPE.MONS_HORNEDLIZARD, quill.x+0.8, quill.y+1, 0, 8, 0.2))
                            end
                            caveman1:set_texture(texturevars.quillback_minion_texture)
                            table.insert(boss_controller.caveman_lizards, caveman1.uid)
                            caveman1.flags = set_flag(caveman1.flags, 4)
                            set_timeout(function()
                                caveman1.flags = clr_flag(caveman1.flags, 4)
                            end, 20)
                        end
                    end
            end
            --STATE 32
            --do a spin in the air before ground pounding
            if quill.move_state == 32 then
                quill.state = 30
                boss_controller.attack_spin_cooldown = boss_controller.attack_spin_cooldown-1
                    quill.velocityy = 0
                    --make quill spin
                    if boss_controller.attack_spin_cooldown > 10 then
                            if boss_controller.attack_direction == 1 then
                                    quill.angle = quill.angle - 0.33
                            end
                            if boss_controller.attack_direction == -1 then
                                    quill.angle = quill.angle + 0.33
                            end
                    else
                            quill.angle = 0      
                    end
                    quill.flags = set_flag(quill.flags, 10) --no gravity
                    if boss_controller.attack_spin_cooldown <= 0 then
                            boss_controller.attack_spin_cooldown = 30
                            boss_controller.attack_cooldown = 40
                            quill.flags = clr_flag(quill.flags, 10)
                            quill.angle = 0
                            quill.velocityy = -0.4
                            quill.move_state = 30
                    end
            end
            --STATE 11
            --phase 3 roll
            if quill.move_state == 11 then
                --make it so quill can go faaaast
                if test_flag(quill.flags, 17) then
                    quill.x = quill.x - quill.velocityx/2
                else
                    quill.x = quill.x - quill.velocityx/2
                end
                if quill.standing_on_uid ~= -1 then
                    quill.velocityy = 0.5
                    --shake the screen and stuff when quill hits the ground
                    boss_controller.hit_ground = true
                    shake_camera(10, 10, 10, 10, 10, true)
                    play_vanilla_sound(VANILLA_SOUND.TRAPS_BOULDER_EMERGE)
                    play_vanilla_sound(VANILLA_SOUND.ENEMIES_BOSS_CAVEMAN_LAND)
                    --spawn more cavemen
                    if math.random(2) == 1 and quill.move_state ~= 11 then
                        local caveman1 = -1
                        if test_flag(quill.flags, 17) then
                            caveman1 = get_entity(spawn(ENT_TYPE.MONS_HORNEDLIZARD, quill.x-0.8, quill.y+1, 0, -8, 0.2))
                            caveman1.flags = set_flag(caveman1.flags, 17)
                        else
                            caveman1 = get_entity(spawn(ENT_TYPE.MONS_HORNEDLIZARD, quill.x+0.8, quill.y+1, 0, 8, 0.2))
                        end
                        caveman1:set_texture(texturevars.quillback_minion_texture)
                        table.insert(boss_controller.caveman_lizards, caveman1.uid)
                        table.insert(boss_controller.caveman_lizards, caveman1.uid)
                        caveman1.flags = set_flag(caveman1.flags, 4)
                        set_timeout(function()
                            caveman1.flags = clr_flag(caveman1.flags, 4)
                        end, 20)
                    end
                end
            end
            --STATE 5
            --return to state 30 and landing
            if quill.move_state == 5 and quill.standing_on_uid ~= -1 then
                quill.move_state = 30
                boss_controller.attack_cooldown = 90
                boss_controller.attack_spin_cooldown = 30 
            end
            --STAE 31
            --jump in the air and decide an attack
            if quill.move_state == 31 then
                --jump in the air
                if quill.standing_on_uid ~= -1 then
                    quill.velocityy = 0.305
                    play_vanilla_sound(VANILLA_SOUND.ENEMIES_BOSS_CAVEMAN_JUMP)
                end
                if quill.velocityy < 0.02 then
                    boss_controller.hit_ground = false
                    local roll = math.random(3)
                    if roll == 1 then
                        quill.move_state = 32
                        play_vanilla_sound(VANILLA_SOUND.SHARED_TRIP)
                    end
                    if roll == 2 then
                        quill.move_state = 32
                        play_vanilla_sound(VANILLA_SOUND.SHARED_TRIP)
                    end
                    if roll == 3 then
                        quill.move_state = 32
                        play_vanilla_sound(VANILLA_SOUND.SHARED_TRIP)
                    end 
                end
                --move towards the player (unless we're already close enough)
                if distance(quill.uid, players[1].uid) > 0.05 then
                    if players[1].x > quill.x then
                            quill.velocityx = 0.2
                    else
                            quill.velocityx = -0.2
                    end
                else
                    quill.velocityx = 0
                end
            end
        end
        --END OF PHASE 3


         -- ANGRY PHASE
        if boss_controller.quillback_state == 2 then
            boss_controller.quillback_anger_timer = boss_controller.quillback_anger_timer-1
            quill.state = 30
            quill.move_state = 50
            if quill.standing_on_uid ~= -1 then
                shake_camera(5, 5, 5, 5, 5, true)
                quill.velocityy = 0.15
                play_vanilla_sound(VANILLA_SOUND.ENEMIES_BOSS_CAVEMAN_JUMP, 1)
                play_vanilla_sound(VANILLA_SOUND.ENEMIES_BOSS_CAVEMAN_LAND)
            end
            if boss_controller.quillback_anger_timer == 0 then
                boss_controller.quillback_anger_timer = 120
                boss_controller.quillback_size = boss_controller.quillback_size+1
                shake_camera(10, 10, 10, 10, 10, true)
                quill.move_state = 30
                --go to next phase
                if boss_controller.quillback_size == 1 then
                    boss_controller.quillback_state = 1 --PHASE 2
                    quill.health = 4
                    boss_controller.hit_ground = true
                end
                if boss_controller.quillback_size == 2 then
                    boss_controller.quillback_state = 3 --PHASE 3
                    quill.health = 3
                    boss_controller.hit_ground = true
                end
            end
        end
        --destroy all items that cant be used in the fight
        for _, v in ipairs(get_entities_by_type(ENT_TYPE.ITEM_BOMB, ENT_TYPE.ITEM_PASTEBOMB, ENT_TYPE.ITEM_BULLET, ENT_TYPE.ITEM_ROPE)) do
            local ent = get_entity(v)
            if ent.x > -900 then
                generate_particles(PARTICLEEMITTER.CURSEDEFFECT_SKULL, v)
                play_vanilla_sound(VANILLA_SOUND.PLAYER_DEATH_GHOST)
                ent.flags = set_flag(ent.flags, 28)
            end
            ent.x = -900
            --return bombs if the player tried using one
            local already_spawned = false
            for _, k in ipairs(boss_controller.spawned_bombs) do
                if v == k then
                    already_spawned = true
                end
            end
            local already_spawned_rope = false
            for _, k in ipairs(boss_controller.spawned_ropes) do
                if v == k then
                    already_spawned_rope = true
                end
            end            
            if (ent.type.id == ENT_TYPE.ITEM_BOMB or ent.type.id == ENT_TYPE.ITEM_PASTEBOMB) and already_spawned == false then
                players[1].inventory.bombs = players[1].inventory.bombs + 1
                table.insert(boss_controller.spawned_bombs, ent.uid)
            end
            if ent.type.id == ENT_TYPE.ITEM_ROPE and already_spawned_rope == false then
                players[1].inventory.ropes = players[1].inventory.ropes + 1
                table.insert(boss_controller.spawned_ropes, ent.uid)
            end
        end
    end
end, ON.FRAME)

return boss_controller
meta.name = "Pit of 100 Trials"
meta.version = "0.3.1"
meta.description = "On the dark side of the moon lay a separate cave entrance. A deep, dark pit fabled to contain 100 floors of combat. None know what lay on the 100th floor, as none have lived to tell the tale. The only thing which is certain is how strangely alluring it is. Will you be the one to complete The Pit of 100 Trials? Only one way to find out! This mod adds a lot, so make sure to explore everything! (Including your journal!)"
meta.author = "erictran"

register_option_bool("enable_custom_music", "Enable custom music?", "Highly reccomended. Just make sure to turn off the vanilla music! If you want to play without music or without custom music, then disable this option.", false)
register_option_float("custom_music_volume", "Custom Music Volume", "Volume of the custom music. This is relative to your regular in game sound settings.", 0.2, 0, 1)
--thank you to fenesd for this!!!
function lerp(a, b, t)
    return a + (b - a) * t
end
function in_range(x, y1, y2) --checks if a value is within a range
    if x >= y1 and x <= y2 then
        return true
    end
    return false
end
--temp for quillback damage
local quillback_db = get_type(ENT_TYPE.MONS_CAVEMAN_BOSS)
quillback_db.damage = 1
function draw_perk_tier(xoffset, perk)
    if perk == 'MIDASTOUCH' then
        if game_controller.has_midastouch == 1 then
            draw_image(assets.ico_perk_tier_one, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        elseif game_controller.has_midastouch == 2 then
            draw_image(assets.ico_perk_tier_two, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        elseif game_controller.has_midastouch >= 3 then
            draw_image(assets.ico_perk_tier_three, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        end
    elseif perk == "CRATEPERK" then
        if game_controller.has_crateperk == 1 then
            draw_image(assets.ico_perk_tier_one, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        elseif game_controller.has_crateperk == 2 then
            draw_image(assets.ico_perk_tier_two, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        elseif game_controller.has_crateperk >= 3 then
            draw_image(assets.ico_perk_tier_three, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        end
    elseif perk == "PAYOFFPAIN" then
        if game_controller.has_payoffpain == 1 then
            draw_image(assets.ico_perk_tier_one, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        elseif game_controller.has_payoffpain == 2 then
            draw_image(assets.ico_perk_tier_two, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        elseif game_controller.has_payoffpain >= 3 then
            draw_image(assets.ico_perk_tier_three, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        end
    elseif perk == "FIREWHIP" then
        if game_controller.has_firewhip == 1 then
            draw_image(assets.ico_perk_tier_one, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        elseif game_controller.has_firewhip == 2 then
            draw_image(assets.ico_perk_tier_two, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        elseif game_controller.has_firewhip >= 3 then
            draw_image(assets.ico_perk_tier_three, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        end
    elseif perk == "RETURNPOSTAGE" then
        if game_controller.has_returnpostage >= 1 then
            draw_image(assets.ico_perk_tier_one, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        end
    elseif perk == "STUNSHIELD" then
        if game_controller.has_stunshield == 1 then
            draw_image(assets.ico_perk_tier_one, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        elseif game_controller.has_stunshield == 2 then
            draw_image(assets.ico_perk_tier_two, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        elseif game_controller.has_stunshield >= 3 then
            draw_image(assets.ico_perk_tier_three, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        end
    elseif perk == "SPARKSHIELD" then
        if game_controller.has_sparkshield == 1 then
            draw_image(assets.ico_perk_tier_one, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        elseif game_controller.has_sparkshield == 2 then
            draw_image(assets.ico_perk_tier_two, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        elseif game_controller.has_sparkshield >= 3 then
            draw_image(assets.ico_perk_tier_three, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        end
    elseif perk == "GROUNDPOUND" then
        if game_controller.has_groundpound >= 1 then
            draw_image(assets.ico_perk_tier_one, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        end
    elseif perk == "ROPERECLAIMER" then
        if has_ropereclaimer >= 1 then
            draw_image(assets.ico_perk_tier_one, -0.96+(0.07*(xoffset-1)), 0.66, -0.9+(0.07*(xoffset-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        end
    end
end
function get_perk_description(perk_name)
    if perk_name == "MIDASTOUCH" then
        return custom_shop.item_descriptions[2], custom_shop.item_names[2]
    elseif perk_name == "CRATEPERK" then
        return custom_shop.item_descriptions[11], custom_shop.item_names[11]
    elseif perk_name == "PAYOFFPAIN" then
        return custom_shop.item_descriptions[15], custom_shop.item_names[15]
    elseif perk_name == "FIREWHIP" then
        return custom_shop.item_descriptions[20], custom_shop.item_names[20]
    elseif perk_name == "RETURNPOSTAGE" then
        return custom_shop.item_descriptions[12], custom_shop.item_names[12]
    elseif perk_name == "STUNSHIELD" then
        return custom_shop.item_descriptions[18], custom_shop.item_names[18]
    elseif perk_name == "SPARKSHIELD" then
        return custom_shop.item_descriptions[19], custom_shop.item_names[19]
    elseif perk_name == "GROUNDPOUND" then
        return custom_shop.item_descriptions[22], custom_shop.item_names[22]
    elseif perk_name == "ROPERECLAIMER" then
        return custom_shop.item_descriptions[30], custom_shop.item_names[30]
    end
    return ""
end


--load modules
texturevars = require "texturevars" --these are the texture definitions for my custom textures
floors = require "floors" --this is a big table containing arrays of enemy IDs to use for spawning on each floor
assets = require "assets/assets" --this is my external assets (sounds, visuals etc.)
require "po1t_callback_controller"
custom_shop = require "custom_shop" --table that contains data for the custom shop
yang = require "yang"
enemies = require "enemies"
game_controller = require "game_controller"
custom_music = require "custom_music"
perk_controller = require "perk_controller"
backpack_controller = require "backpack_controller"
boss_controller = require "boss_controller"
honorbound_controller = require "honorbound_controller"
override_crates = require "override_crates"
generate_floor = require "generate_floor"
require "level_gen/level_gen"
require "enemy_types/enemy_types"
require "custom_pickups"
require "fx"
require "custom_tilecodes"
require "custom_items/custom_items"
require "npcs/npcs"
require "chances"
require "level_types"
require "perks/perks"

show_pos = false --debug

--FUNCTIONS
function reset_game_controllers()
    --reset other controllers
    boss_controller.reset()
    override_crates.reset()
    honorbound_controller.reset()

    --GAME CONTROLLER
    game_controller.progress = 0
    game_controller.floor = 1
    game_controller.enemies_left = 0
    game_controller.spawn_x = 0
    game_controller.spawn_y = 0
    game_controller.exit_spawned = false
    game_controller.godmode_graceperiod = 120
    game_controller.current_theme = THEME.DWELLING
    game_controller.current_world = 1

    game_controller.max_health = 5

    game_controller.current_enemies_left = {}

    game_controller.enemy_with_key = -1; --UID of entity holding the exit key
    game_controller.exit_key_effect_uid = -1;
    game_controller.exit_key_uid = -1;
    game_controller.exit_key_last_known_x = 0;
    game_controller.exit_key_last_known_y = 0;

    game_controller.brokenkapala_timer = 120
    game_controller.brokenkapala_timer_max = 120

    game_controller.kapala_blood_previous = 0

    game_controller.camp_music_playing = false;

    game_controller.equipped_perks = {}

    game_controller.enemy_spawner_max_x = 0
    game_controller.enemy_spawner_max_y = 0

    game_controller.current_floor_width = 2;
    game_controller.current_floor_height = 2;

    game_controller.ammo = 12
    game_controller.has_midastouch = 0
    game_controller.has_crateperk = 0
    game_controller.has_returnpostage = 0
    game_controller.has_brokenkapala = 0
    game_controller.has_payoffpain = 0
    game_controller.has_payoffpain_start = 0
    game_controller.has_stunshield = 0
    game_controller.has_sparkshield = 0
    game_controller.has_firewhip = 0
    game_controller.has_groundpound = 0

    game_controller.shotgun_fired = false

    game_controller.yangchallenge_showmessage = false --used so the message yang says isnt spammed over and over
    game_controller.yangchallenge_buymessage = false
    game_controller.yangchallenge_active = false
    game_controller.yangchallenge_spawned = false
    game_controller.yangchallenge_spawntime = 1800
    game_controller.yangchallenge_angry = false

    game_controller.boss_ceiling_spawned = false
    game_controller.boss_intro_music_stop = false
    game_controller.boss_started = false

    --all custom weapons will use a similar system to this

    --CUSTOM STATUSES
    game_controller.activate_shrink = false
    game_controller.is_shrunk = false

    --spark shield
    game_controller.player_sparktrap_uid = nil
    game_controller.sparkshield_timer = 600
    
    --ground pound
    game_controller.groundpound_timer = 31
    game_controller.can_groundpound = false
    game_controller.can_breakfloor = true
    game_controller.crush_floor = -1

    --PERK CONTROLLER
    perk_controller.is_equipped = {}
    perk_controller.is_in_perk_inventory = false
    perk_controller.selected_slot = 1
    perk_controller.inventory_button_pressed = false
    perk_controller.inventory_enable = false
    perk_controller.left_button_pressed = false
    perk_controller.left_enable = false
    perk_controller.right_button_pressed = false
    perk_controller.right_enable = false
    perk_controller.jump_button_pressed = false
    perk_controller.jump_enable = false

    --BACKPACK
    backpack_controller.backpack_button_pressed = false
    backpack_controller.backpack_enable = false
    backpack_controller.items = {} --list of items, uses my custom items with their names in string form as IDs
    backpack_controller.items_uids = {}
    backpack_controller.is_in_backpack = false;
    backpack_controller.selected_slot = 1
    backpack_controller.max_slots = 3
    --SHOP INVENTORY
    custom_shop.items = {}
    custom_shop.items_by_price = {}
    custom_shop.items_by_type = {}
    custom_shop.items_by_name = {}
    custom_shop.items_by_description = {}

    --playerbags
    game_controller.special_playerbags = {}
    game_controller.special_playerbag_effects = {}
    --miniboss room
    game_controller.miniboss_active = 0
    game_controller.miniboss_walls = {}
    game_controller.miniboss_enemies = {}
    game_controller.miniboss_x = 0 --miniboss room position x
    game_controller.miniboss_y = 0 --miniboss room position y

    --repelgel
    game_controller.repelgel_active = false;
end


function set_playerbag_db(type)
    entity_db = get_type(541)
    if type ~= "SHOP" and type ~= "DEFAULT" then
      return
    end
    if type == "SHOP" then
        entity_db.default_flags = set_flag(entity_db.default_flags, 28)
    end
    if type == "DEFAULT" then
        entity_db.default_flags = clr_flag(entity_db.default_flags, 28)
    end
end
function set_yang_db(type)
    entity_db = get_type(ENT_TYPE.MONS_YANG)
    if type ~= "MUTE" and type ~= "DEFAULT" then
      return
    end
    if type == "MUTE" then
        entity_db.sound_killed_by_player = 0
        entity_db.sound_killed_by_other = 0
    end
    if type == "DEFAULT" then
    end
end
--colors
white = rgba(255, 255, 255, 255)
black = rgba(0, 0, 0, 255)
--EVENTS
--ON.START
set_callback(function()
    state.level = game_controller.floor
    local roll = math.random(50)
    local chosen_main_music = determine_main_music()
    custom_music.current_music = custom_music.set_music(chosen_main_music)
    custom_music.set_volume_instant(game_controller.default_music_volume)
    custom_music.stop_music() --stop any potentially playing music
    custom_music.play_music()
    --set player health to 5
    players[1].health = 5
    --override crates
    override_crates.active = true
end,
ON.START)
--ON.RESET
set_callback(function()
    reset_game_controllers()
end, 
ON.RESET)
--ON.POST_ROOM_GENERATION
set_callback(function()
    --determine if this is a key floor or not
    if state.theme ~= THEME.BASE_CAMP then
        --get the spawn cords
        if players[1] ~= nil then
            local px, py, pl = get_position(players[1].uid)
            game_controller.spawn_x = px
            game_controller.spawn_y = py+0.1
        end
        --determine the maximum spawn range for entities
        game_controller.enemy_spawner_max_x = 2+(generate_floor.room_width*10)
        game_controller.enemy_spawner_max_y = 120-(generate_floor.room_height*10)

        --determine where enemies can spawn
        local valid_floor_spawns = {}
        local valid_ceiling_spawns = {}
        local original_floor_spawns = {}
        local original_ceiling_spawns = {}
        local floor_types = {ENT_TYPE.FLOORSTYLED_STONE, ENT_TYPE.FLOORSTYLED_MINEWOOD, ENT_TYPE.FLOOR_JUNGLE, ENT_TYPE.FLOOR_GENERIC}
        local xoffset = 0
        local yoffset = 0
        for i, v in ipairs(get_entities_by_type(floor_types)) do
            local fx, fy, fl = get_position(v)
            local ent_uids_above_floor = get_entities_at(0, MASK.FLOOR | MASK.LAVA | MASK.ACTIVEFLOOR, fx, fy+1, 0, 1)
            local ent_uids_below_floor = get_entities_at(0, MASK.FLOOR | MASK.LAVA | MASK.ACTIVEFLOOR, fx, fy-1, 0, 1)
            local distance_from_spawn = math.sqrt( (fx-game_controller.spawn_x)^2 + (fy-game_controller.spawn_y)^2 )
            --check for entities above and below this floor
            --determine if this tile is in a side room (the ones that can be used to spawn enemies)
            local indx, indy = get_room_index(fx, fy)
            if get_room_template(indx, indy, 0) == ROOM_TEMPLATE.SIDE and (distance_from_spawn > 4.5) then
                if (ent_uids_above_floor[1] == nil) or (ent_uids_below_floor[1] == nil) then
                    if (ent_uids_above_floor[1] == nil) then
                        table.insert(valid_floor_spawns, v)
                        table.insert(original_floor_spawns, v)
                    end
                    if (ent_uids_below_floor[1] == nil) then
                        table.insert(valid_ceiling_spawns, v)
                        table.insert(original_ceiling_spawns, v)
                    end         
                elseif (ent_uids_above_floor[1] ~= nil) or (ent_uids_below_floor[1] ~= nil) then
                    if (ent_uids_above_floor[1] ~= nil) then
                        if not (test_flag(get_entity(ent_uids_above_floor[1]).flags, 3)) then
                            table.insert(valid_floor_spawns, v)
                            table.insert(original_floor_spawns, v)
                        end
                    end
                    if (ent_uids_below_floor[1] ~= nil) then
                        if not (test_flag(get_entity(ent_uids_below_floor[1]).flags, 3)) then
                            table.insert(valid_ceiling_spawns, v)
                            table.insert(original_ceiling_spawns, v)
                        end
                    end
                end
            end
        end
        --spawn the enemies
        --hijack enemy spawns for level types
        local enemy_list = floors[game_controller.floor]
        if is_special_level then
            if is_caveman then
                enemy_list = floor_caveman
            end
        end
        for i, entity_type_id in ipairs(enemy_list) do --itterate through each enemy type in the floor list
            if level_type ~= "DEFAULT" then break end
            local spawned_entity = -1
            local as_shadow_ent = false
            local as_explosive_ent = false
            local as_armored_ent = false
            local as_infested_ent = false
            local as_ghostly_ent = false
            local as_cursed_ent = false
            local as_gilded_ent = false
            local as_recursive_ent = false
            local as_caveman_hornedlizard = false
            local as_caveman_snake = false

            local roll = math.random(1, 100)
            if in_range(roll, 1, 4) then
                as_shadow_ent = true
            end
            if in_range(roll, 5, 7) then
                as_armored_ent = true
            end
            if in_range(roll, 8, 10) then
                as_explosive_ent = true
            end
            if in_range(roll, 11, 13) then
                as_infested_ent = true
            end
            if in_range(roll, 14, 16) then
                as_ghostly_ent = true
            end
            if in_range(roll, 17, 18) then
                as_cursed_ent = true
            end
            if in_range(roll, 19, 20) then
                as_gilded_ent = true
            end
            if in_range(roll, 21, 22) then
                as_recursive_ent = true
            end
            --hijack enemy spawning if this is a shadow level
            if is_special_level then
                if is_shadow then
                    as_shadow_ent = true
                    as_explosive_ent = false
                    as_armored_ent = false
                    as_infested_ent = false
                    as_ghostly_ent = false
                    as_cursed_ent = false
                    as_gilded_ent = false
                    as_recursive_ent = false
                    as_caveman_hornedlizard = false
                    as_caveman_snake = false
                end
            end
            --special spawns for caveman level
            local caveman_roll = math.random(100)
            if is_caveman then
                if in_range(caveman_roll, 1, 10) then
                    as_caveman_hornedlizard = true
                end  
                if in_range(caveman_roll, 11, 17) then
                    as_caveman_snake = true
                end  
            end
            if is_ceiling_enemy(entity_type_id) and #valid_ceiling_spawns ~= 0 then --spawn ceiling enemies
                yoffset = -1
                xoffset = 0
                --choose a tile to spawn an enemy on
                local roll = math.random(#valid_ceiling_spawns)
                local chosen_ceiling_spawn = valid_ceiling_spawns[roll]
                
                local fx, fy, fl = get_position(chosen_ceiling_spawn)
                if as_armored_ent == true and entity_type_id ~= ENT_TYPE.MONS_MOLE then
                    spawned_entity = get_entity(spawn_as_armored(entity_type_id, fx+xoffset, fy+yoffset, 0, 0, 0))
                elseif as_shadow_ent == true then
                    spawned_entity = get_entity(spawn_as_shadow(entity_type_id, fx+xoffset, fy+yoffset, 0, 0, 0))
                elseif as_explosive_ent == true then
                    spawned_entity = get_entity(spawn_as_explosive(entity_type_id, fx+xoffset, fy+yoffset, 0, 0, 0))
                elseif as_infested_ent == true then
                    spawned_entity = get_entity(spawn_as_infested(entity_type_id, fx+xoffset, fy+yoffset, 0, 0, 0))
                elseif as_ghostly_ent == true then
                    spawned_entity = get_entity(spawn(entity_type_id, fx+xoffset, fy+yoffset, 0, 0, 0))
                elseif as_cursed_ent == true then
                    spawned_entity = get_entity(spawn(entity_type_id, fx+xoffset, fy+yoffset, 0, 0, 0))
                elseif as_gilded_ent == true then
                    spawned_entity = get_entity(spawn_as_gilded(entity_type_id, fx+xoffset, fy+yoffset, 0, 0, 0))
                elseif as_recursive_ent == true then
                    spawned_entity = get_entity(spawn_as_recursive(entity_type_id, fx+xoffset, fy+yoffset, 0, 0, 0))
                elseif as_caveman_hornedlizard == true then
                    spawned_entity = get_entity(spawn_caveman_as_lizard(fx+xoffset, fy+yoffset, 0, 0, 0))
                elseif as_caveman_snake == true then
                    spawned_entity = get_entity(spawn_caveman_as_snake(fx+xoffset, fy+yoffset, 0, 0, 0))
                else
                    spawned_entity = get_entity(spawn(entity_type_id, fx+xoffset, fy+yoffset, 0, 0, 0))
                end
                table.remove(valid_ceiling_spawns, roll)
                table.insert(game_controller.current_enemies_left, spawned_entity.uid) --put enemy into the list of enemies that need to be killed
            elseif #valid_floor_spawns ~= 0 then --spawn floor enemies
                yoffset = 1
                xoffset = 0
                if entity_type_id == ENT_TYPE.MONS_FIREBUG then --move firebugs to chains
                    local chains = get_entities_by_type(ENT_TYPE.FLOOR_CHAINANDBLOCKS_CHAIN)
                    local roll = math.random(1, #chains)
                    local rx, ry, rz = get_position(chains[roll])
                    xoffset = rx
                    yoffset = ry
                end
                --choose a tile to spawn an enemy on
                local roll = math.random(#valid_floor_spawns)
                local chosen_floor_spawn = valid_floor_spawns[roll]

                local fx, fy, fl = get_position(chosen_floor_spawn)
                if entity_type_id == ENT_TYPE.MONS_FIREBUG then fx = 0 fy = 0 fl = 0 end --remove the spawn location if this is a firebug
                if as_armored_ent == true and entity_type_id ~= ENT_TYPE.MONS_MOLE then
                    spawned_entity = get_entity(spawn_as_armored(entity_type_id, fx+xoffset, fy+yoffset, 0, 0, 0))
                elseif as_shadow_ent == true then
                    spawned_entity = get_entity(spawn_as_shadow(entity_type_id, fx+xoffset, fy+yoffset, 0, 0, 0))
                elseif as_explosive_ent == true then
                    spawned_entity = get_entity(spawn_as_explosive(entity_type_id, fx+xoffset, fy+yoffset, 0, 0, 0))
                elseif as_infested_ent == true then
                    spawned_entity = get_entity(spawn_as_infested(entity_type_id, fx+xoffset, fy+yoffset, 0, 0, 0))
                elseif as_ghostly_ent == true then
                    spawned_entity = get_entity(spawn(entity_type_id, fx+xoffset, fy+yoffset, 0, 0, 0))
                elseif as_cursed_ent == true then
                    spawned_entity = get_entity(spawn(entity_type_id, fx+xoffset, fy+yoffset, 0, 0, 0))
                elseif as_gilded_ent == true then
                    spawned_entity = get_entity(spawn_as_gilded(entity_type_id, fx+xoffset, fy+yoffset, 0, 0, 0))
                elseif as_recursive_ent == true then
                    spawned_entity = get_entity(spawn_as_recursive(entity_type_id, fx+xoffset, fy+yoffset, 0, 0, 0))
                elseif as_caveman_hornedlizard == true then
                    spawned_entity = get_entity(spawn_caveman_as_lizard(fx+xoffset, fy+yoffset, 0, 0, 0))
                elseif as_caveman_snake == true then
                    spawned_entity = get_entity(spawn_caveman_as_snake(fx+xoffset, fy+yoffset, 0, 0, 0))
                else
                    spawned_entity = get_entity(spawn(entity_type_id, fx+xoffset, fy+yoffset, 0, 0, 0))
                end
                table.remove(valid_floor_spawns, roll)
                table.insert(game_controller.current_enemies_left, spawned_entity.uid) --put enemy into the list of enemies that need to be killed
            end
            --make one random enemy have the key
            if (enemy_with_key == -1) and (math.random(7) == 1) and level_type == "DEFAULT" and entity_type_id ~= ENT_TYPE.MONS_MOLE then
                enemy_with_key = spawned_entity.uid
                exit_key_effect_uid = spawn(ENT_TYPE.ITEM_KEY, spawned_entity.x, spawned_entity.y, 0, 0, 0)
                local exit_key = get_entity(exit_key_effect_uid)
                exit_key:set_texture(texturevars.item_fancykey)
                exit_key.flags = clr_flag(exit_key.flags, 13)
                exit_key.flags = clr_flag(exit_key.flags, 14)
                exit_key.flags = set_flag(exit_key.flags, 10)
                exit_key.flags = set_flag(exit_key.flags, 5)
                exit_key.flags = clr_flag(exit_key.flags, 18)
                exit_key.flags = clr_flag(exit_key.flags, 18)
                exit_key:set_draw_depth(1)
            end
            if (i == #floors[game_controller.floor]) and enemy_with_key == -1 and level_type == "DEFAULT" and entity_type_id ~= ENT_TYPE.MONS_MOLE  then
                enemy_with_key = spawned_entity.uid
                exit_key_effect_uid = spawn(ENT_TYPE.ITEM_KEY, spawned_entity.x, spawned_entity.y, 0, 0, 0)
                local exit_key = get_entity(exit_key_effect_uid)
                exit_key:set_texture(texturevars.item_fancykey)
                exit_key.flags = clr_flag(exit_key.flags, 13)
                exit_key.flags = clr_flag(exit_key.flags, 14)
                exit_key.flags = set_flag(exit_key.flags, 10)
                exit_key.flags = set_flag(exit_key.flags, 5)
                exit_key.flags = clr_flag(exit_key.flags, 18)
                exit_key:set_draw_depth(1)
            end
        end
        --remove unwanted items
        local unwanted_items = {}
        if state.theme ~= THEME.CITY_OF_GOLD then
            unwanted_items = {ENT_TYPE.BG_KALI_STATUE, ENT_TYPE.MONS_PET_DOG, ENT_TYPE.MONS_PET_CAT, ENT_TYPE.MONS_PET_HAMSTER}
        else
            unwanted_items = {ENT_TYPE.BG_KALI_STATUE}
        end
        for _, v in ipairs(get_entities_by_type(unwanted_items)) do
            local ent = get_entity(v)
            ent.x = -10
        end
        --retxture the door locked door (temp)
        for _, v in ipairs(get_entities_by_type(ENT_TYPE.BG_DOOR)) do
            for _, k in ipairs(get_entities_by_type(ENT_TYPE.FLOOR_DOOR_EXIT)) do
                local ent = get_entity(v)
                local exit = get_entity(k)
                if ent:overlaps_with(exit) then
                    if state.theme == THEME.DWELLING then
                        ent:set_texture(texturevars.lockeddoor_dwelling)
                    end
                end
            end
        end
        --remove ghost pot(s)
        for _, v in ipairs(get_entities_by_type(ENT_TYPE.ITEM_CURSEDPOT)) do
            local pot = get_entity(v)
            pot.x = -5
            pot.flags = set_flag(pot.flags, 28)
        end
        --STOP MAKING PUNCH TRAPS (and other traps) SPAWN RIGHT NEXT TO THE DANG DOOR
        for _, v in ipairs(get_entities_by_type(ENT_TYPE.FLOOR_TOTEM_TRAP)) do
            local fx, fy, fl = get_position(v)
            for _, l in ipairs(get_entities_by_type(ENT_TYPE.BG_DOOR)) do
                local dx, dy, dl = get_position(l)
                local distance_from_door = math.sqrt( (fx-dx)^2 + (fy-dy)^2 )
                if distance_from_door < 4.5 then
                    move_entity(v, -10, fy, 0, 0)
                end
            end
            for _, j in ipairs(get_entities_at(ENT_TYPE.FLOORSTYLED_TEMPLE, 0, fx, fy+1, 0, 1.5)) do --no idea if this works hopefully it does
                kill_entity(v)
            end
        end
        --i also hate cobwebs,, dumbest game mechanic in spelunky to date.
        for _, v in ipairs(get_entities_by_type(ENT_TYPE.ITEM_WEB)) do
            kill_entity(v)
        end
        --lock the exit door
        for _, v in ipairs(get_entities_by_type(ENT_TYPE.FLOOR_DOOR_EXIT)) do
            local door = get_entity(v)
            local dx, dy, dl = get_position(v)
            lock_door_at(dx, dy)
        end
        for _, v in ipairs(get_entities_by_type(ENT_TYPE.FLOOR_BORDERTILE)) do
            local fx, fy, fl = get_position(v)
            local old_floor = get_entity(v)
            old_floor:remove()
            local new_floor = get_entity(spawn_on_floor(ENT_TYPE.FLOOR_GENERIC, fx, fy, fl))
            new_floor.flags = set_flag(new_floor.flags, 6)
            if is_shadow then
                new_floor.color.r = 0
                new_floor.color.g = 0
                new_floor.color.b = 0
                new_floor.color.a = 0.9
            end
        end
    end
end,
ON.POST_LEVEL_GENERATION)

--ON.LEVEL
set_callback(function()
    --temp
    --[[
    if level_type == "SHOP" then
        for _, v in ipairs(get_entities_by_type(ENT_TYPE.FLOOR_DOOR_ENTRANCE)) do
            game_controller.exit_spawned = true
            local exx, exy, ell = get_position(v)
            --ADVANCE PROGRESSION
            game_controller.floor = game_controller.floor + 1
            run_po1t_callback(PO1T_ON.EXIT_UNLOCKED)
            door(exx, exy+0.1, ell, game_controller.current_world, 1, game_controller.current_theme)
        end
    end
    ]]
    game_controller.yangchallenge_showmessage = false
    --override animation frames for groundpound
    set_post_statemachine(players[1].uid, function() 
        if players[1] ~= nil then
            if game_controller.groundpound_timer <= 30 and players[1].health > 0 then 
                    players[1].animation_frame = 135 
            end
        end
        if players[1].health > game_controller.max_health then
            players[1].health = game_controller.max_health
        end
    end)
    --see if the player has payoffpain equipped on the start of a level
    if game_controller.has_payoffpain > 0 then
        game_controller.has_payoffpain_start = true
    end
    --return volume to normal amount
    custom_music.set_volume(game_controller.default_music_volume, 0.01)

    --manage game controller stuff
    game_controller.exit_spawned = false
    game_controller.godmode_graceperiod = 120

    state.level = game_controller.floor

    --be crateful effect
    if game_controller.has_crateperk > 0 and level_type == "DEFAULT" then
        if game_controller.has_crateperk == 1 then --1 crate
            if math.fmod(game_controller.floor, 2) == 0 then
                local px, py, pl = get_position(players[1].uid)
                spawn(ENT_TYPE.ITEM_CRATE, px-1, py, 0, 0 ,0)
            end
        elseif game_controller.has_crateperk == 2 then --2 crates
            if math.fmod(game_controller.floor, 2) == 0 then
                local px, py, pl = get_position(players[1].uid)
                spawn(ENT_TYPE.ITEM_CRATE, px-1, py, 0, 0 ,0)
                spawn(ENT_TYPE.ITEM_CRATE, px+1, py, 0, 0 ,0)
            end
        elseif game_controller.has_crateperk >= 3 then --2 crates every level
            local px, py, pl = get_position(players[1].uid)
            spawn(ENT_TYPE.ITEM_CRATE, px-1, py, 0, 0 ,0)
            spawn(ENT_TYPE.ITEM_CRATE, px+1, py, 0, 0 ,0)
        end
    end
    --display the floor were on
    if state.theme ~= THEME.CITY_OF_GOLD and level_type == "DEFAULT" and not is_special_level then
        toast_override(tostring("Floor " .. game_controller.floor))
    end
    --shops
    if state.theme == THEME.CITY_OF_GOLD then
        spawn(784, game_controller.spawn_x, game_controller.spawn_y+0.15, 0, 0, 0)
        local px, py, pl = get_position(players[1].uid)
        --create the playerbag items and add them to our list
        custom_shop.items[1] = spawn(541, 4.5, 107.95, 0, 0, 0)
        custom_shop.items[2] = spawn(541, 6, 107.95, 0, 0, 0)
        custom_shop.items[3] = spawn(541, 7.5, 107.95, 0, 0, 0)
        custom_shop.items[4] = spawn(541, 9, 107.95, 0, 0, 0)
        custom_shop.items[5] = spawn(541, 10.5, 107.95, 0, 0, 0)
    
        custom_shop.items[6] = spawn(541, 14.5, 107.95, 0, 0, 0)
        custom_shop.items[7] = spawn(541, 16, 107.95, 0, 0, 0)
        custom_shop.items[8] = spawn(541, 17.5, 107.95, 0, 0, 0)
        custom_shop.items[9] = spawn(541, 19, 107.95, 0, 0, 0)
        custom_shop.items[10] = spawn(541, 20.5, 107.95, 0, 0, 0)

        custom_shop.items[11] = spawn(541, 4.5, 115.95, 0, 0, 0)
        custom_shop.items[12] = spawn(541, 6, 115.95, 0, 0, 0)
        custom_shop.items[13] = spawn(541, 7.5, 115.95, 0, 0, 0)
        custom_shop.items[14] = spawn(541, 9, 115.95, 0, 0, 0)
        custom_shop.items[15] = spawn(541, 10.5, 115.95, 0, 0, 0)
    
        custom_shop.items[16] = spawn(541, 14.5, 115.95, 0, 0, 0)
        custom_shop.items[17] = spawn(541, 16, 115.95, 0, 0, 0)
        custom_shop.items[18] = spawn(541, 17.5, 115.95, 0, 0, 0)
        custom_shop.items[19] = spawn(541, 19, 115.95, 0, 0, 0)
        custom_shop.items[20] = spawn(541, 20.5, 115.95, 0, 0, 0)
        
        --spawn yang + his stuff on floor 12
        if game_controller.floor == 12 then
            spawn(ENT_TYPE.MONS_YANG, px+3, py+2.9, 0, 0, 0)
            custom_shop.items[21] = spawn(541, px-1, py+2.9, 0, 0, 0)
        end
        --attribute a type to these items
        for i, v in ipairs(custom_shop.items) do
            --disable AI for these playerbags
            local ent = get_entity(v)
            ent.flags = set_flag(ent.flags, 28)
            local roll = math.random(100+game_controller.floor)
            if roll > 95+game_controller.floor then
                custom_shop.items_by_type[i] = custom_shop.item_veryrare[math.random(#custom_shop.item_veryrare)]
            elseif roll > 75 and roll <= 95+game_controller.floor then
                custom_shop.items_by_type[i] = custom_shop.item_rare[math.random(#custom_shop.item_rare)]
            else
                custom_shop.items_by_type[i] = custom_shop.item_common[math.random(#custom_shop.item_common)]
            end
            if i == 21 then  --yangs challenge item shoulnt be turned into a regular item
                custom_shop.items_by_type[i] = "YANGCHALLENGE"
                break 
            end
        end
        --get details for items
        for i, item_type in ipairs(custom_shop.items_by_type) do
            if item_type == "SPIKESHOES" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[1]
                custom_shop.items_by_name[i] = custom_shop.item_names[1]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[1]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.spikeshoes_texture)
            end
            if item_type == "MIDASTOUCH" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[2]
                custom_shop.items_by_name[i] = custom_shop.item_names[2]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[2]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.midastouch_texture)
            end
            if item_type == "AMMO" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[3]
                custom_shop.items_by_name[i] = custom_shop.item_names[3]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[3]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.ammo_texture)
            end
            if item_type == "TURKEY" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[4]
                custom_shop.items_by_name[i] = custom_shop.item_names[4]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[4]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.turkey_texture)
            end
            if item_type == "BOMBBAG" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[5]
                custom_shop.items_by_name[i] = custom_shop.item_names[5]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[5]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.bombbag_texture)
            end
            if item_type == "MACHETE" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[6]
                custom_shop.items_by_name[i] = custom_shop.item_names[6]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[6]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.machete_texture)
            end
            if item_type == "KAPALA" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[7]
                custom_shop.items_by_name[i] = custom_shop.item_names[7]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[7]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.kapala_texture)
            end
            if item_type == "JETPACK" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[8]
                custom_shop.items_by_name[i] = custom_shop.item_names[8]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[8]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.jetpack_texture)
            end
            if item_type == "EXCALIBUR" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[9]
                custom_shop.items_by_name[i] = custom_shop.item_names[9]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[9]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.excalibur_texture)
            end
            if item_type == "ROPEPILE" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[10]
                custom_shop.items_by_name[i] = custom_shop.item_names[10]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[10]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.ropepile_texture)
            end
            if item_type == "CRATEPERK" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[11]
                custom_shop.items_by_name[i] = custom_shop.item_names[11]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[11]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.crateperk_texture)
            end
            if item_type == "RETURNPOSTAGE" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[12]
                custom_shop.items_by_name[i] = custom_shop.item_names[12]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[12]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.returnpostage_texture)
            end
            if item_type == "SHOTGUN" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[13]
                custom_shop.items_by_name[i] = custom_shop.item_names[13]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[13]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.shotgun_texture)
            end
            if item_type == "BROKENKAPALA" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[14]
                custom_shop.items_by_name[i] = custom_shop.item_names[14]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[14]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.brokenkapala_texture)
            end
            if item_type == "PAYOFFPAIN" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[15]
                custom_shop.items_by_name[i] = custom_shop.item_names[15]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[15]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.payoffpain_texture)
            end
            if item_type == "YANGCHALLENGE" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[16]
                custom_shop.items_by_name[i] = custom_shop.item_names[16]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[16]
                ent = get_entity(custom_shop.items[i])
                
            end
            if item_type == "BUTCHERKNIFE" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[17]
                custom_shop.items_by_name[i] = custom_shop.item_names[17]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[17]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.butcherknife_texture)
            end
            if item_type == "STUNSHIELD" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[18]
                custom_shop.items_by_name[i] = custom_shop.item_names[18]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[18]
                ent = get_entity(custom_shop.items[i])
            end
            if item_type == "SPARKSHIELD" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[19]
                custom_shop.items_by_name[i] = custom_shop.item_names[19]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[19]
                ent = get_entity(custom_shop.items[i])
            end
            if item_type == "FIREWHIP" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[20]
                custom_shop.items_by_name[i] = custom_shop.item_names[20]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[20]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.firewhip_texture)
            end
            if item_type == "BUTTERFLYKNIFE" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[21]
                custom_shop.items_by_name[i] = custom_shop.item_names[21]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[21]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.butcherknife_texture)
            end
            if item_type == "HPUP" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[23]
                custom_shop.items_by_name[i] = custom_shop.item_names[23]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[23]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.hpup_texture)
            end
            if item_type == "BPEXPANDER" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[24]
                custom_shop.items_by_name[i] = custom_shop.item_names[24]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[24]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.bpexpander_texture)
            end
            if item_type == "TONIC" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[25]
                custom_shop.items_by_name[i] = custom_shop.item_names[25]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[25]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.tonic_texture)
            end
            if item_type == "TEA" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[26]
                custom_shop.items_by_name[i] = custom_shop.item_names[26]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[26]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.tea_texture)
            end
            if item_type == "MEAL" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[27]
                custom_shop.items_by_name[i] = custom_shop.item_names[27]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[27]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.meal_texture)
            end
            if item_type == "REPELGEL" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[28]
                custom_shop.items_by_name[i] = custom_shop.item_names[28]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[28]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.repelgel_texture)
            end
            if item_type == "ROPERECLAIMER" then
                custom_shop.items_by_price[i] = custom_shop.item_prices[30]
                custom_shop.items_by_name[i] = custom_shop.item_names[30]
                custom_shop.items_by_description[i] = custom_shop.item_descriptions[30]
                ent = get_entity(custom_shop.items[i])
                ent:set_texture(texturevars.payoffpain_texture)
            end
        end
    end
    --start off yang timer (if we should)
    if game_controller.yangchallenge_active == true and game_controller.yangchallenge_spawntime == 1800 and level_type == "DEFAULT" then
        game_controller.yangchallenge_spawntime = game_controller.yangchallenge_spawntime-1 --this makes the timer 1799, which basically "kicks off" the timer in the ON.FRAME callback
        --this way, yangs dont spawn when you first start the challenge
    end
end,
ON.LEVEL)

--ON.FRAME
set_callback(function()
    --shrink effect
    if game_controller.activate_shrink == true and get_entity(players[1].uid) ~= nil then
        game_controller.activate_shrink = false
        if game_controller.is_shrunk == false then
            game_controller.is_shrunk = true
            play_sound(assets.snd_shrink)
            generate_particles(160, players[1].uid)
            local shrink_factor = 1.5
            players[1].width = players[1].width/shrink_factor
            players[1].height = players[1].height/shrink_factor
            players[1].hitboxx = players[1].hitboxx/shrink_factor
            players[1].hitboxy = players[1].hitboxy/shrink_factor
        end
    end


    --unlock the exit with the key
    if level_type == "DEFAULT" then
        for _, v in ipairs(get_entities_by_type(ENT_TYPE.FLOOR_DOOR_EXIT)) do
            local exit = get_entity(v)
            local exx, exy, exl = get_position(v)
            local exit_key = get_entity(exit_key_uid)
            if (exit ~= nil) and (exit_key ~= nil) then
                if exit:overlaps_with(exit_key) then
                    kill_entity(exit_key.uid)
                    play_vanilla_sound(VANILLA_SOUND.SHARED_DOOR_UNLOCK)
                    game_controller.exit_spawned = true
                    --ADVANCE PROGRESSION
                    game_controller.floor = game_controller.floor + 1
                    run_po1t_callback(PO1T_ON.EXIT_UNLOCKED)
                    door(exx, exy+0.1, 0, game_controller.current_world, 1, game_controller.current_theme)
                    --make the door look open
                    for _, k in ipairs(get_entities_by_type(ENT_TYPE.BG_DOOR)) do
                        local bg = get_entity(k)
                        if bg:overlaps_with(exit) then
                            bg.animation_frame = 1
                        end
                    end
                end
            end
        end
    elseif level_type == "SHOP" and game_controller.exit_spawned == false then
        local exx, exy, exl = get_position(get_entities_by_type(ENT_TYPE.FLOOR_DOOR_ENTRANCE)[1])
        game_controller.exit_spawned = true
        game_controller.floor = game_controller.floor + 1
        run_po1t_callback(PO1T_ON.EXIT_UNLOCKED)
        door(exx, exy+0.1, 0, game_controller.current_world, 1, game_controller.current_theme)
    end

    --repelgel (maybe move this into an event that isnt on.frame so we can control stuff like player alpha..)
    if game_controller.repelgel_active == true then
        god(true)
        players[1].color.a = 0.5
        players[1]:is_poisoned(false)
        players[1]:poison(-1)
        players[1].more_flags = clr_flag(players[1].more_flags, 15)
        --cap HP (curse sets it to 1)
        if players[1].health < game_controller.repelgel_health_before_use then
            players[1].health = game_controller.repelgel_health_before_use
        end
    elseif players[1] ~= nil then
            god(false)
            players[1].color.a = 1
    end
    --activate miniboss
    if players[1] ~= nil and state.theme == THEME.DWELLING and game_controller.floor == 11 then
        local px, py, pl = get_position(players[1].uid)
        if px > 77 and py > 112 then --start the miniboss
            if game_controller.miniboss_active == 0 then
                --walls and enemies
                local enemy_choices = {ENT_TYPE.MONS_CAVEMAN, ENT_TYPE.MONS_JIANGSHI, ENT_TYPE.MONS_MOLE, ENT_TYPE.MONS_SNAKE}
                local enemy1 = spawn_as_shadow(enemy_choices[math.random(#enemy_choices)], 75, 118, 0, 0, 0)
                table.insert(game_controller.miniboss_enemies, enemy1)
                local flipme = get_entity(enemy1)
                flipme.flags = clr_flag(flipme.flags, 17)
                generate_particles(160, enemy1)
                local enemy2 = spawn_as_shadow(enemy_choices[math.random(#enemy_choices)], 82, 118, 0, 0, 0)
                table.insert(game_controller.miniboss_enemies, enemy2)
                generate_particles(160, enemy2)
                local wall1 = get_entity(spawn(ENT_TYPE.FLOOR_BORDERTILE, 73, 118, 0, 0, 0))
                wall1:add_decoration(FLOOR_SIDE.RIGHT)
                wall1:add_decoration(FLOOR_SIDE.LEFT)
                table.insert(game_controller.miniboss_walls, wall1)
                local wall2 = get_entity(spawn(ENT_TYPE.FLOOR_BORDERTILE, 73, 119, 0, 0, 0))
                wall2:add_decoration(FLOOR_SIDE.RIGHT)
                wall2:add_decoration(FLOOR_SIDE.LEFT)
                table.insert(game_controller.miniboss_walls, wall2)
                shake_camera(10, 10, 10, 10, 10, true)
                play_vanilla_sound(VANILLA_SOUND.TRAPS_BOULDER_EMERGE)
                play_vanilla_sound(VANILLA_SOUND.SHARED_SMOKE_TELEPORT)
                game_controller.miniboss_active = 1
            end
        end
    end
    --manage / end miniboss
    if game_controller.miniboss_active == 1 then
        --check if the miniboss entities are dead
        local all_dead = true
        for _, v in ipairs(game_controller.miniboss_enemies) do
            if get_entity(v) ~= nil then
                all_dead = false
            end
        end
        if all_dead == true then
            --spawn the reward and destroy the walls
            game_controller.miniboss_active = 2
            kill_entity(game_controller.miniboss_walls[1].uid)
            kill_entity(game_controller.miniboss_walls[2].uid)
            shake_camera(5, 5, 5, 5, 5, true)
            spawn(ENT_TYPE.ITEM_LOCKEDCHEST, 77, 118, 0, 0, 0)
            spawn(ENT_TYPE.ITEM_LOCKEDCHEST, 79, 118, 0, 0, 0)
            play_vanilla_sound(VANILLA_SOUND.UI_SECRET2)
        end
    end
    --have the locked chest open up with tons of goodies inside
    for _, v in ipairs(get_entities_by_type(ENT_TYPE.ITEM_LOCKEDCHEST)) do
        local ent = get_entity(v)
        local x, y, l = get_position(v)
        if math.abs(ent.velocityx) > 0.05 or math.abs(ent.velocityy) > 0.1 then
                generate_particles(PARTICLEEMITTER.HITEFFECT_STARS_BIG, v)
                generate_particles(PARTICLEEMITTER.HITEFFECT_STARS_SMALL, v)
                generate_particles(PARTICLEEMITTER.CONTACTEFFECT_SPARKS, v)
                generate_particles(PARTICLEEMITTER.HITEFFECT_RING, v)
                generate_particles(PARTICLEEMITTER.HITEFFECT_SMACK, v)
                generate_particles(PARTICLEEMITTER.SCEPTERKILL_SPARKLES, v)
                generate_particles(PARTICLEEMITTER.SCEPTERKILL_SPARKS, v)
                generate_particles(PARTICLEEMITTER.SCEPTERKILL_SPARKLES, v)
                generate_particles(PARTICLEEMITTER.SCEPTERKILL_SPARKS, v)
                generate_particles(PARTICLEEMITTER.SCEPTERKILL_SPARKLES, v)
                generate_particles(PARTICLEEMITTER.SCEPTERKILL_SPARKS, v)
                play_vanilla_sound(VANILLA_SOUND.SHARED_OPEN_CHEST)
                play_vanilla_sound(VANILLA_SOUND.SHARED_OPEN_CRATE)
                play_vanilla_sound(VANILLA_SOUND.SHARED_DOOR_UNLOCK)
                play_vanilla_sound(VANILLA_SOUND.ITEMS_UDJAT_BLINK)
                local reward_index = {"MIDASTOUCH", "CRATEPERK", "FIREWHIP", "STUNSHIELD", "SPARKSHIELD", "SPARKSHIELD", "PAYOFFPAIN", "AMMO", "AMMO", "TONIC", "TONIC", "TEA", "MEAL", "RETURNPOSTAGE", "HPUP", "HPUP", "HPUP", "BPEXPANDER", "BPEXPANDER", "BPEXPANDER","AMMO", "AMMO", "AMMO", "ROPERECLAIMER"}
                if math.random(100) == 1 then
                    reward_index = {"GROUNDPOUND"}
                end
                if math.random(100) == 1 then
                    local knife = spawn(ENT_TYPE.ITEM_MACHETE, x, y, l, math.random(-1, 1)/40, math.random(1, 5)/50)
                    replace_machete_butcherknife(knife)
                elseif math.random(30) == 1 then
                    local knife = spawn(ENT_TYPE.ITEM_MACHETE, x, y, l, math.random(-1, 1)/40, math.random(1, 5)/50)
                elseif math.random(5) == 1 then
                    spawn(ENT_TYPE.ITEM_FREEZERAY, x, y, l, math.random(-1, 1)/40, math.random(1, 5)/50)
                end
                if math.random(50) == 1 then
                    spawn(ENT_TYPE.ITEM_PICKUP_BOMBBOX, x, y, l, math.random(-1, 1)/40, math.random(1, 5)/50)
                end
                if math.random(8) == 1 then
                    spawn(ENT_TYPE.ITEM_PICKUP_BOMBBAG, x, y, l, math.random(-1, 1)/40, math.random(1, 5)/50)
                end
                if math.random(50) == 1 then
                    spawn(ENT_TYPE.ITEM_SHOTGUN, x, y, l, math.random(-1, 1)/40, math.random(1, 5)/50)
                end
                if math.random(100) == 1 then
                    spawn(ENT_TYPE.ITEM_PICKUP_COOKEDTURKEY, x, y, l, math.random(-1, 1)/40, math.random(1, 5)/50)
                end
                if math.random(8) == 1 then
                    spawn(ENT_TYPE.ITEM_PICKUP_COOKEDTURKEY, x, y, l, math.random(-1, 1)/40, math.random(1, 5)/50)
                end
                if math.random(50) == 1 then
                    spawn(ENT_TYPE.ITEM_PICKUP_ROYALJELLY, x, y, l, math.random(-1, 1)/40, math.random(1, 5)/50)
                end
                if math.random(10) ~= 1 then --first perk has a small chance to not even drop
                    spawn_playerbag_as_custom_pickup(x, y, l, math.random(-1, 1)/40, math.random(1, 5)/50, reward_index[math.random(#reward_index)])
                end
                kill_entity(v)
        end
    end
    --custom item pickups
    if #game_controller.special_playerbags > 0 then
        for i, v in ipairs(game_controller.special_playerbags) do
            local ent = get_entity(v)
            if ent ~= nil and ent.type.id == ENT_TYPE.ITEM_PICKUP_PLAYERBAG and players[1] ~= nil then --should a uid of a previous playerbag become the uid of something else, this will make sure that its still a playerbag.
                if ent:overlaps_with(players[1]) and not test_flag(players[1].flags, 29) and test_flag(ent.more_flags, 6) == false then
                    --perform the effects of the picked up item
                    if game_controller.special_playerbag_effects[i] == "MIDASTOUCH" then
                        custom_shop.spawn_item("MIDASTOUCH")
                    elseif game_controller.special_playerbag_effects[i] == "AMMO" then
                        custom_shop.spawn_item("AMMO")
                    elseif game_controller.special_playerbag_effects[i] == "CRATEPERK" then
                        custom_shop.spawn_item("CRATEPERK")
                    elseif game_controller.special_playerbag_effects[i] == "RETURNPOSTAGE" then
                        custom_shop.spawn_item("RETURNPOSTAGE")
                    elseif game_controller.special_playerbag_effects[i] == "PAYOFFPAIN" then
                        custom_shop.spawn_item("PAYOFFPAIN")
                    elseif game_controller.special_playerbag_effects[i] == "YANGCHALLENGE" then
                        custom_shop.spawn_item("YANGCHALLENGE")
                    elseif game_controller.special_playerbag_effects[i] == "STUNSHIELD" then
                        custom_shop.spawn_item("STUNSHIELD")
                    elseif game_controller.special_playerbag_effects[i] == "SPARKSHIELD" then
                        custom_shop.spawn_item("SPARKSHIELD")
                    elseif game_controller.special_playerbag_effects[i] == "FIREWHIP" then
                        custom_shop.spawn_item("FIREWHIP")
                    elseif game_controller.special_playerbag_effects[i] == "GROUNDPOUND" then
                        custom_shop.spawn_item("GROUNDPOUND")
                    elseif game_controller.special_playerbag_effects[i] == "HPUP" then
                        custom_shop.spawn_item("HPUP")
                    elseif game_controller.special_playerbag_effects[i] == "BPEXPANDER" then
                        custom_shop.spawn_item("BPEXPANDER")
                    elseif game_controller.special_playerbag_effects[i] == "ROPERECLAIMER" then
                        custom_shop.spawn_item("ROPERECLAIMER")
                    elseif game_controller.special_playerbag_effects[i] == "TONIC" or game_controller.special_playerbag_effects[i] == "TEA" or game_controller.special_playerbag_effects[i] == "MEAL" or game_controller.special_playerbag_effects[i] == "REPELGEL" then
                        if backpack_controller.items[backpack_controller.max_slots] == nil then
                            table.insert(backpack_controller.items, game_controller.special_playerbag_effects[i])
                        else
                            backpack_controller.perform_consumable_effect(game_controller.special_playerbag_effects[i])
                        end
                    end
                end
            end
        end
    end
    --cap max health
    if players[1] ~= nil then
        --close the boss room ceiling once the player falls
        if level_type == "BOSS" then
            local px, py, pl = get_position(players[1].uid)
            if py < 89 and game_controller.boss_ceiling_spawned == false then
                --SPAWN THE BOSS
                local quill = get_entity(spawn(ENT_TYPE.MONS_CAVEMAN_BOSS, 12, 83, 0, 0, 0))
                quill.flags = set_flag(quill.flags, 17)
                boss_controller.quillback_uid = quill.uid
                boss_controller.quillback_active = true
                generate_particles(160, quill.uid)
                play_vanilla_sound(VANILLA_SOUND.SHARED_SMOKE_TELEPORT)
                --SFX OF CEILING CLOSING
                play_vanilla_sound(VANILLA_SOUND.TRAPS_BOULDER_EMERGE)
                shake_camera(10, 10, 10, 10, 10, true)
                custom_music.stop_music()
                set_timeout(function()
                    custom_music.current_music = custom_music.set_music(assets.mu_boss)
                    custom_music.set_volume_instant(game_controller.default_music_volume)
                    custom_music.play_music()
                end, 40)
                --spawn the floors
                game_controller.boss_ceiling_spawned = true
                for i=1, 10, 1 do
                    local floor = get_entity(spawn(ENT_TYPE.FLOOR_BORDERTILE, 12+i, 91, 0, 0, 0))
                    floor:add_decoration(FLOOR_SIDE.BOTTOM)
                    local floor = get_entity(spawn(ENT_TYPE.FLOOR_BORDERTILE, 12+i, 92, 0, 0, 0))
                    local floor = get_entity(spawn(ENT_TYPE.FLOOR_BORDERTILE, 12+i, 93, 0, 0, 0))
                    local floor = get_entity(spawn(ENT_TYPE.FLOOR_BORDERTILE, 12+i, 94, 0, 0, 0))
                    local floor = get_entity(spawn(ENT_TYPE.FLOOR_BORDERTILE, 12+i, 95, 0, 0, 0))
                    local floor = get_entity(spawn(ENT_TYPE.FLOOR_BORDERTILE, 12+i, 96, 0, 0, 0))
                    local floor = get_entity(spawn(ENT_TYPE.FLOOR_BORDERTILE, 12+i, 97, 0, 0, 0))
                    local floor = get_entity(spawn(ENT_TYPE.FLOOR_BORDERTILE, 12+i, 98, 0, 0, 0))
                    local floor = get_entity(spawn(ENT_TYPE.FLOOR_BORDERTILE, 12+i, 99, 0, 0, 0))
                    floor:add_decoration(FLOOR_SIDE.TOP)
                end
            end
        end
        --if sparkshield is disabled, destroy the sparktrap and reset the timer
        if game_controller.has_sparkshield == 0 then
            if game_controller.player_sparktrap_uid ~= nil then
                kill_entity(game_controller.player_sparktrap_uid)
            end
            game_controller.player_sparktrap_uid = nil
            game_controller.sparkshield_timer = 600
        end
        --make sparkshield rotate differently
        local sparkshield = get_entity(game_controller.player_sparktrap_uid)
        local px, py, pl = get_position(players[1].uid)
        if sparkshield ~= nil then
            sparkshield.state = 0
            sparkshield.move_state = 0
            sparkshield.some_state = 0
            sparkshield.rotation_center_x = players[1].x
            sparkshield.rotation_center_y = players[1].y
            sparkshield.angle = sparkshield.angle - 0.25
        end
        --make sparkshield not suck
        if game_controller.has_sparkshield > 0 then
            for _, v in ipairs(get_entities_by_type(enemies)) do
                local ent = get_entity(v)
                local spark = get_entity(game_controller.player_sparktrap_uid)
                if spark ~= nil and ent ~= nil then
                    local ex, ey, el = get_position(v)
                    local sx, sy, sl = get_position(spark.uid)
                    if spark:overlaps_with(ent) then
                        if ent.health <= 5 then
                            kill_entity(v)
                        end
                    end
                end
            end
        end
        --check if the player should have a perk active
        --set counts to zero
        game_controller.has_midastouch = 0
        game_controller.has_crateperk = 0
        game_controller.has_returnpostage = 0
        game_controller.has_payoffpain = 0
        game_controller.has_stunshield = 0
        game_controller.has_sparkshield = 0
        game_controller.has_firewhip = 0
        game_controller.has_groundpound = 0
        has_ropereclaimer = 0
        if honorbound_controller.perks == false then
            for i, v in ipairs(game_controller.equipped_perks) do
                if v == "MIDASTOUCH" then
                    if perk_controller.is_equipped[i] then
                        game_controller.has_midastouch = game_controller.has_midastouch + 1
                    end
                end
                if v == "CRATEPERK" then
                    if perk_controller.is_equipped[i] then
                        game_controller.has_crateperk = game_controller.has_crateperk + 1
                    end
                end
                if v == "RETURNPOSTAGE" then
                    if perk_controller.is_equipped[i] then
                        game_controller.has_returnpostage = game_controller.has_returnpostage + 1
                    end
                end
                if v == "PAYOFFPAIN" then
                    if perk_controller.is_equipped[i] then
                        game_controller.has_payoffpain = game_controller.has_payoffpain + 1
                    end
                    --make sure the player doesnt disable payoffpain whenever they want and still get the effects
                    if game_controller.has_payoffpain == 0 then
                        game_controller.has_payoffpain_start = false
                    end
                end
                if v == "STUNSHIELD" then
                    if perk_controller.is_equipped[i] then
                        game_controller.has_stunshield = game_controller.has_stunshield + 1
                    end
                end
                if v == "SPARKSHIELD" then
                    if perk_controller.is_equipped[i] then
                        game_controller.has_sparkshield = game_controller.has_sparkshield + 1
                    end
                end
                if v == "FIREWHIP" then
                    if perk_controller.is_equipped[i] then
                        game_controller.has_firewhip = game_controller.has_firewhip + 1
                    end
                end
                if v == "GROUNDPOUND" then
                    if perk_controller.is_equipped[i] then
                        game_controller.has_groundpound = game_controller.has_groundpound + 1
                    end
                end
                if v == "ROPERECLAIMER" then
                    if perk_controller.is_equipped[i] then
                        has_ropereclaimer = has_ropereclaimer + 1
                    end
                end
            end
        end

        if state.pause == 1 and state.ingame == 1 then
            custom_music.set_volume(game_controller.paused_music_volume, 0.01)
        end
        if state.pause == 0 and state.ingame == 1 then
            custom_music.set_volume(game_controller.default_music_volume, 0.01)
        end
        --debug
        for _, player in ipairs(players) do
            x, y, l = get_position(players[1].uid)
            if show_pos == true then
                message("x: " ..tostring(x) .. " y: " .. tostring(y))
            end
        end
        --spawn yang (if we should)
        if game_controller.yangchallenge_active == true and game_controller.yangchallenge_spawned == false and game_controller.yangchallenge_spawntime <= 1799 then
            game_controller.yangchallenge_spawntime = game_controller.yangchallenge_spawntime-1
            if game_controller.yangchallenge_spawntime == 1200 then
                game_controller.yangchallenge_spawned = true
                --regular yang (nothing special here)
                yang_orig = get_entity(spawn(ENT_TYPE.MONS_YANG, game_controller.spawn_x+math.random(-100, 100)/100, game_controller.spawn_y-0.1, 0, math.random(-100, 100)/100, math.random(100, 200)/100))
                yang_orig_mov = get_entity(yang_orig.uid):as_movable()
                yang_orig_mov.flags = clrflag(yang_orig_mov.flags, 25) -- disable 'passes through player'
                yang_orig_mov.move_state = 6 -- activate aggro AI
                entity_remove_item(ENT_TYPE.ITEM_CROSSBOW, yang_orig.uid) --remove the crossbow in their inventory that they wont pull out and give them one manually
                if game_controller.yangchallenge_angry == false then
                    pick_up(yang_orig_mov.uid, spawn(ENT_TYPE.ITEM_CROSSBOW, yang_orig_mov.x, yang_orig_mov.y, 0, 0, 0)) --give yang a crossbow
                end
                if game_controller.yangchallenge_angry == true then
                    --yang one (of eleven!)
                    yang_one = get_entity(spawn(ENT_TYPE.MONS_YANG, game_controller.spawn_x+math.random(-100, 100)/100, game_controller.spawn_y-0.1, 0, math.random(-100, 100)/100, math.random(100, 200)/100))

                    yang_two = get_entity(spawn(ENT_TYPE.MONS_YANG, game_controller.spawn_x+math.random(-100, 100)/100, game_controller.spawn_y-0.1, 0, math.random(-100, 100)/100, math.random(100, 200)/100))

                    yang_three = get_entity(spawn(ENT_TYPE.MONS_YANG, game_controller.spawn_x+math.random(-100, 100)/100, game_controller.spawn_y-0.1, 0, math.random(-100, 100)/100, math.random(100, 200)/100)) 

                end
                --piss off yangs
                for _, v in ipairs(get_entities_by_type(ENT_TYPE.MONS_YANG)) do
                    local e = get_entity(v):as_movable()
                    e.flags = clrflag(e.flags, 25) -- disable 'passes through player'
                    e.move_state = 6 -- activate aggro AI
                    entity_remove_item(ENT_TYPE.ITEM_CROSSBOW, e.uid) --remove the crossbow in their inventory that they wont pull out and give them one manually
                    pick_up(e.uid, spawn(ENT_TYPE.ITEM_CROSSBOW, e.x, e.y, 0, 0, 0)) --give yang a crossbow
                end
            end
        end
        --groundpound
        if game_controller.has_groundpound > 0 then
            local player_slot = state.player_inputs.player_slot_1
            if players[1].standing_on_uid ~= -1 then
                game_controller.can_groundpound = true
            end
            --detect ground pound (down + jump)
            if players[1]:is_button_pressed(1) and (test_flag(player_slot.buttons, 12) and not test_flag(player_slot.buttons, 9) and not test_flag(player_slot.buttons, 10)) then
                    --make sure the player is in a state to do a ground pound
                    if players[1].state == 9 and game_controller.groundpound_timer == 31 and game_controller.can_groundpound == true and test_flag(players[1].more_flags, 14) then
                        game_controller.groundpound_timer = 30 --start groundpound timer
                            play_vanilla_sound(VANILLA_SOUND.SHARED_TRIP)
                            game_controller.can_groundpound = false
                    end
            end
            if game_controller.groundpound_timer <= 30 then
                    if game_controller.crush_floor ~= -1 then
                        game_controller.crush_floor.x = players[1].x
                        game_controller.crush_floor.y = players[1].y-1.15
                    end
                    game_controller.groundpound_timer = game_controller.groundpound_timer - 1
                    steal_input(players[1].uid)
                    players[1].airtime = 0
                    if game_controller.groundpound_timer == 30 then
                            set_flag(players[1].flags, 10)
                    end
                    if game_controller.groundpound_timer > 0 then
                            players[1].y = players[1].y - players[1].velocityy
                            players[1].x = players[1].x - players[1].velocityx
                    end
                    if test_flag(players[1].flags, 17) then
                            players[1].angle = players[1].angle+0.33
                    else
                            players[1].angle = players[1].angle-0.33
                    end
                    if game_controller.groundpound_timer <= 10 then
                            players[1].angle = 0
                            for _, v in ipairs(get_entities_by_type(ENT_TYPE.ITEM_WEB)) do
                                    if distance(v, players[1].uid) < 1 then
                                            kill_entity(v)
                                    end
                            end
                    end
                    if game_controller.groundpound_timer == 5 then
                            clr_flag(players[1].flags, 10)
                            players[1].velocityy = -0.4
                            game_controller.can_breakfloor = true
                            local px, py, pl = get_position(players[1].uid)
                            game_controller.crush_floor = get_entity(spawn(ENT_TYPE.ACTIVEFLOOR_CRUSH_TRAP, px, py-1.15, pl, 0, 0))
                            game_controller.crush_floor.flags = set_flag(game_controller.crush_floor.flags, 1)
                            game_controller.crush_floor.flags = clr_flag(game_controller.crush_floor.flags, 13)
                            game_controller.crush_floor.state = 30
                            game_controller.crush_floor.move_state = 30
                            game_controller.crush_floor.height = 0.2
                            game_controller.crush_floor.width = 0.45
                            game_controller.crush_floor.hitboxy = 0.2
                            game_controller.crush_floor.hitboxx = 0.45
                    end
                    --things that make it so you cant break floor
                    if players[1].velocityy > 0 then
                            game_controller.can_breakfloor = false
                    end
                    if game_controller.groundpound_timer < 0 and (players[1].standing_on_uid ~= -1 or players[1].state == 4) then
                            local floor = get_entity(players[1].standing_on_uid)
                            if floor == nil then
                                    return_input(players[1].uid)
                                    game_controller.groundpound_timer = 31
                                    game_controller.can_breakfloor = false
                                    game_controller.crush_floor.x = -900
                                    game_controller.crush_floor.y = -900
                                    kill_entity(game_controller.crush_floor.uid)
                                    game_controller.crush_floor = -1
                                    return
                            end
                            if floor.type.id ~= ENT_TYPE.FLOOR_BORDERTILE and floor.type.id ~= ENT_TYPE.FLOOR_DOOR_PLATFORM and players[1].stun_timer == 0 and players[1].health > 0 and not test_flag(floor.flags, 6) and game_controller.can_breakfloor == true then
                                    game_controller.crush_floor.x = -900
                                    game_controller.crush_floor.y = -900
                                    kill_entity(game_controller.crush_floor.uid)
                                    game_controller.crush_floor = -1
                                    kill_entity(players[1].standing_on_uid)
                                    shake_camera(7, 7, 7, 7, 7, false)
                                    play_vanilla_sound(VANILLA_SOUND.SHARED_DESTRUCTIBLE_BREAK)
                                    play_vanilla_sound(VANILLA_SOUND.SHARED_RUBBLE_BREAK)
                                    play_vanilla_sound(VANILLA_SOUND.SHARED_COLLISION_SURFACE)
                                    play_vanilla_sound(VANILLA_SOUND.ITEMS_ROPE_ATTACH)
                            else
                                shake_camera(7, 7, 7, 7, 7, false)
                                play_vanilla_sound(VANILLA_SOUND.SHARED_DESTRUCTIBLE_BREAK)
                                play_vanilla_sound(VANILLA_SOUND.SHARED_RUBBLE_BREAK)
                                play_vanilla_sound(VANILLA_SOUND.SHARED_COLLISION_SURFACE)
                            end
                            return_input(players[1].uid)
                            game_controller.groundpound_timer = 31
                            game_controller.can_breakfloor = false
                            if game_controller.crush_floor ~= -1 then
                                game_controller.crush_floor.x = -900
                                game_controller.crush_floor.y = -900
                                kill_entity(game_controller.crush_floor.uid)
                                game_controller.crush_floor = -1
                            end
                    end
            end
        end
        --firewhip effect
        if game_controller.has_firewhip > 0 then
            if players[1].uid > 0 then
                e = get_entity(players[1].uid):as_movable()
                local px, py, pl = get_position(players[1].uid)
                --shoot fireballs!!
                if players[1].holding_uid == -1 then
                    --get fireball speed
                    local speed = 0.25
                    local fireballs = 1
                    if game_controller.has_firewhip == 1 then
                        speed = 0.25
                        fireballs = 1
                    elseif game_controller.has_firewhip == 2 then
                        speed = 0.32
                        fireballs = 3
                    elseif game_controller.has_firewhip >= 3 then
                        speed = 0.5
                        fireballs = 6
                    end
                    if e.animation_frame == 64 and game_controller.firewhip_back_spawned == false then
                        game_controller.firewhip_back_spawned = true
                        for i=1, fireballs, 1 do
                            if test_flag(e.flags, 17) == true then
                                local fireball = get_entity(spawn(ENT_TYPE.ITEM_FIREBALL, px+1, py, 0, 0, 0))
                                fireball.velocityx = 0.12
                                fireball.velocityy = 0.075
                            else
                                local fireball = get_entity(spawn(ENT_TYPE.ITEM_FIREBALL, px-1, py, 0, 0, 0))
                                fireball.angle = 180
                                fireball.velocityx = -0.12
                                fireball.velocityy = 0.075
                            end
                        end
                    end
                    if e.animation_frame == 69 and game_controller.firewhip_front_spawned == false then
                        game_controller.firewhip_front_spawned = true
                        for i=1, fireballs, 1 do
                            if test_flag(e.flags, 17) == true then
                                local fireball = get_entity(spawn(ENT_TYPE.ITEM_FIREBALL, px-0.5-math.random(6)/10, py-math.random(2)/10, 0, 0, 0))
                                fireball.angle = 180
                                fireball.velocityx = -speed
                                fireball.velocityy =  math.random(-1, 1)/50
                            else
                                local fireball = get_entity(spawn(ENT_TYPE.ITEM_FIREBALL, px+0.5+math.random(6)/10, py-math.random(2)/10, 0, 0, 0))
                                fireball.velocityx = speed
                                fireball.velocityy =  math.random(-1, 1)/50
                            end
                        end
                    end
                end
            end
        end
        if players[1].animation_frame ~= 64 then
            game_controller.firewhip_back_spawned = false
        end
        if players[1].animation_frame ~= 69 then
            game_controller.firewhip_front_spawned = false
        end
        --spark shield effect
        if game_controller.has_sparkshield > 0 then
            local sparktrap = get_entity(game_controller.player_sparktrap_uid)
            if sparktrap ~= nil then
                if sparktrap.type.id == ENT_TYPE.ITEM_SPARK then
                    if game_controller.sparkshield_timer ~= 600 then
                        game_controller.sparkshield_timer = game_controller.sparkshield_timer - 1
                    end
                    if game_controller.sparkshield_timer == 0 then
                        game_controller.sparkshield_timer = 600
                        kill_entity(game_controller.player_sparktrap_uid)
                        game_controller.player_sparktrap_uid = nil
                    end
                end
            end
            --check if player health has changed (aka taking damage) to trigger effect
            if game_controller.player_health_previous > players[1].health then
                if game_controller.sparkshield_timer == 600 then
                    game_controller.sparkshield_timer = 599 --start sparkshield timer
                end
                if game_controller.player_sparktrap_uid == nil then
                    game_controller.player_sparktrap_uid = spawn_entity_over(ENT_TYPE.ITEM_SPARK, players[1].uid, 0, 0)
                end
                if game_controller.player_sparktrap_uid ~= nil then
                    if get_entity(game_controller.player_sparktrap_uid) == nil then
                        game_controller.player_sparktrap_uid = spawn_entity_over(ENT_TYPE.ITEM_SPARK, players[1].uid, 0, 0)
                    end
                end
            end
        end
        --stun shield effect
        if game_controller.has_stunshield > 0 then -- i am very pleased that for once programming in a perk was quite easy..
            local player_ent = get_entity(players[1].uid):as_movable()
            if game_controller.has_stunshield == 1 then
                if player_ent.stun_timer > 40 then
                    player_ent.stun_timer = 40
                end
            elseif game_controller.has_stunshield == 2 then
                if player_ent.stun_timer > 20 then
                    player_ent.stun_timer = 20
                end
            elseif game_controller.has_stunshield >= 3 then
                if player_ent.stun_timer > 1 then
                    player_ent.stun_timer = 1
                end
            end
        end
        --PERK EFFECTS
        --midas touch effect
        if game_controller.has_midastouch > 0 then
            for i,v in ipairs(get_entities_by_type(enemies)) do
                e = get_entity(v):as_movable()
                x, y, l = get_position(v)
                if e.health == 0 and e.color.r == 1.0 then
                    e.color.r = 0.99999
                    if math.random(4) == 1 then
                        --different tiers
                        if game_controller.has_midastouch == 1 then
                            for i = 1, math.random(2, 3) do
                                spawn(502, x, y, l, math.random(-2, 2)/10, math.random(1, 2)/10)
                            end
                        elseif game_controller.has_midastouch == 2 then
                            for i = 1, math.random(5, 6) do
                                spawn(502, x, y, l, math.random(-2, 2)/10, math.random(1, 2)/10)
                            end
                        elseif game_controller.has_midastouch >= 3 then
                            for i = 1, math.random(8, 9) do
                                spawn(502, x, y, l, math.random(-2, 2)/10, math.random(1, 2)/10)
                            end
                        end
                    end
                end
            end
        end
        --MANAGE SHOTGUN
        player_slot = state.player_inputs.player_slot_1
        if players[1] ~= nil then
            if players[1].holding_uid > 0 then
                e = get_entity(players[1].uid):as_movable()
                player_item = get_entity(players[1].holding_uid):as_gun()
                --manage shotgun ammo
                if players[1].holding_uid ~= -1 and player_item ~= nil then
                    --lock the gun when out of ammo
                    if (player_item.type.id == ENT_TYPE.ITEM_SHOTGUN or player_item.type.id == ENT_TYPE.ITEM_FREEZERAY) and game_controller.ammo <= 0 and not is_cursegun(player_item.uid) then --if we are holding a shotgun (no ammo)
                        player_item.cooldown = 80
                    end
                    --reduce ammo under the given conditions
                    if (player_item.type.id == ENT_TYPE.ITEM_SHOTGUN or player_item.type.id == ENT_TYPE.ITEM_FREEZERAY) and not is_cursegun(player_item.uid) then
                        if game_controller.shotgun_fired == false then
                            if test_flag(player_slot.buttons, 2) and not test_flag(player_slot.buttons, 12) then
                                if player_item.cooldown == 49 then
                                    game_controller.shotgun_fired = true
                                    game_controller.ammo = game_controller.ammo - 1
                                elseif game_controller.ammo <= 0 then
                                    play_vanilla_sound(VANILLA_SOUND.PLAYER_NO_ITEM)
                                    game_controller.shotgun_fired = true
                                end
                            end
                        end
                    end
                end
            end
        end
        if not test_flag(player_slot.buttons, 2) then
            game_controller.shotgun_fired = false
        end
        --return postage effect
        if game_controller.has_returnpostage > 0 then
            e = get_entity(players[1].uid):as_movable()
            if e.invincibility_frames_timer == 80 then
                for _, v in ipairs(get_entities_by_type(enemies)) do --should use a list that doesnt include boss enemies since that would trivialize them
                    dist = distance(players[1].uid, v)
                    if dist < 1 then
                        kill_entity(v)
                    end
                end
            end
        end
        --MORE PERK EFFECTS
        --pay off pain extra damage effect
        if game_controller.has_payoffpain_start == true then
            if game_controller.player_health_previous > players[1].health then
                local damage_difference = game_controller.player_health_previous - players[1].health
                local damage = damage_difference
                if game_controller.has_payoffpain == 1 then
                    damage = damage_difference*2 - damage_difference
                elseif game_controller.has_payoffpain == 2 then
                    damage = damage_difference*4 - damage_difference
                elseif game_controller.has_payoffpain >= 3 then
                    damage = damage_difference*8 - damage_difference
                end
                --deal extra damage
                if players[1].health - damage >= 0 then
                    players[1].health = players[1].health - damage
                    if players[1].health == 0 then
                        players[1].health = 0
                        players[1].flags = set_flag(e.flags, 29)
                    end
                else
                    players[1].health = 0
                    players[1].flags = set_flag(e.flags, 29)
                end
            end
        end
        --pay off pain turn loose gold into rubys
        if game_controller.has_payoffpain_start == true then
            local replace = {}
            local new_item = -1
            if game_controller.has_payoffpain == 1 then
                replace = {ENT_TYPE.ITEM_GOLDBARS, ENT_TYPE.ITEM_GOLDBAR, ENT_TYPE.ITEM_GOLDCOIN, 501, 506, ENT_TYPE.ITEM_SAPPHIRE, ENT_TYPE.ITEM_EMERALD, ENT_TYPE.ITEM_SAPPHIRE_SMALL, ENT_TYPE.ITEM_RUBY_SMALL, ENT_TYPE.ITEM_EMERALD_SMALL}
                new_item = ENT_TYPE.ITEM_RUBY
            elseif game_controller.has_payoffpain == 2 then
                replace = {ENT_TYPE.ITEM_GOLDBARS, ENT_TYPE.ITEM_GOLDBAR, ENT_TYPE.ITEM_GOLDCOIN, 501, 506, ENT_TYPE.ITEM_SAPPHIRE, ENT_TYPE.ITEM_EMERALD, ENT_TYPE.ITEM_SAPPHIRE_SMALL, ENT_TYPE.ITEM_RUBY_SMALL, ENT_TYPE.ITEM_EMERALD_SMALL, ENT_TYPE.ITEM_RUBY} 
                new_item = ENT_TYPE.ITEM_DIAMOND
            elseif game_controller.has_payoffpain >= 3 then
                replace = {ENT_TYPE.ITEM_GOLDBARS, ENT_TYPE.ITEM_GOLDBAR, ENT_TYPE.ITEM_GOLDCOIN, 501, 506, ENT_TYPE.ITEM_SAPPHIRE, ENT_TYPE.ITEM_EMERALD, ENT_TYPE.ITEM_SAPPHIRE_SMALL, ENT_TYPE.ITEM_RUBY_SMALL, ENT_TYPE.ITEM_EMERALD_SMALL, ENT_TYPE.ITEM_RUBY, ENT_TYPE.ITEM_DIAMOND}
                new_item = ENT_TYPE.ITEM_IDOL
            end
            for _, v in ipairs(get_entities_by_type(replace)) do
                local x, y, l = get_position(v)
                move_entity(v, -900, 0, 0, 0, 0)
                spawn(new_item, x, y, l, 0, 0)
            end
        end
        --update player previous health for next frame
        game_controller.player_health_previous = players[1].health

        --broken kapala
        --decrease drain timer
        if players[1] ~= nil then
            if entity_has_item_type(players[1].uid, ENT_TYPE.ITEM_POWERUP_KAPALA) == true and game_controller.has_brokenkapala then
                for _, v in ipairs(get_entities_by_type(ENT_TYPE.ITEM_POWERUP_KAPALA)) do
                    e = get_entity(v)
                end
                game_controller.brokenkapala_timer = game_controller.brokenkapala_timer - 1
                --decrease blood in kapala
                if game_controller.brokenkapala_timer == 0 then
                    if e.amount_of_blood - 1 >= 0 then
                        e.amount_of_blood = e.amount_of_blood - 1
                        play_sound(assets.snd_kapala_lose_blood)
                        game_controller.brokenkapala_timer = game_controller.brokenkapala_timer_max
                    end
                end
                --reset timer if blood is collected
                if e.amount_of_blood ~= nil then
                    if game_controller.kapala_blood_previous < e.amount_of_blood then
                        game_controller.brokenkapala_timer = game_controller.brokenkapala_timer_max
                    end
                    game_controller.kapala_blood_previous = e.amount_of_blood
                end
            end
        end
        --make yang say funny thing
        if state.theme == THEME.ABZU then
            for _, v in ipairs(get_entities_by_type(ENT_TYPE.MONS_YANG)) do
                dist = distance(players[1].uid, v)
                local ent = get_entity(v)
                if dist < 4.5 and game_controller.yangchallenge_showmessage == false then
                    game_controller.yangchallenge_showmessage = true
                    say_override(v, "Looks like this is as far as it goes.. Guess there's nothing to do now but jump into that pit of lava...", 1, false)
                end
                if dist > 4.5 and game_controller.yangchallenge_showmessage == true then
                    game_controller.yangchallenge_showmessage = false
                end
                --make yang face the player
                local px, py, pl = get_position(players[1].uid)
                if px > ent.x then
                    ent.flags = clr_flag(ent.flags, 17)
                else
                    ent.flags = set_flag(ent.flags, 17)
                end
                --make yang poof if he gets hurt (or healed i guess ?)
                if ent.health ~= 10 or ent.move_state == 6 then
                    generate_particles(160, ent.uid)
                    ent.y = 1000
                    kill_entity(ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.SHARED_SMOKE_TELEPORT)              
                end
                --if the player tries to whip yang make him dissapear
                for _, j in ipairs(get_entities_by_type(ENT_TYPE.ITEM_WHIP, ENT_TYPE.ITEM_WHIP_FLAME)) do
                    local whip = get_entity(j)
                    if whip:overlaps_with(ent) or ent.health ~= 10 then
                        generate_particles(160, ent.uid)
                        ent.y = 1000
                        kill_entity(ent.uid)
                        play_vanilla_sound(VANILLA_SOUND.SHARED_SMOKE_TELEPORT)              
                    end
                end
                if players[1].health <= 0 and ent.y < 100 then
                    --spawn a beg
                    local beg = spawn(ENT_TYPE.MONS_HUNDUNS_SERVANT, ent.x, ent.y, 0, 0, 0)
                    local beg_ent = get_entity(beg)
                    beg_ent.move_state = 30
                    ent.y = 1000
                    say_override(beg, "Hah! What a gullible fool!", 1, false)
                    generate_particles(160, beg)
                    play_vanilla_sound(VANILLA_SOUND.SHARED_SMOKE_TELEPORT)
                end
            end
        end
        --yang challenge
        if state.theme == THEME.CITY_OF_GOLD then
            for _, v in ipairs(get_entities_by_type(ENT_TYPE.MONS_YANG)) do
                dist = distance(players[1].uid, v)
                e = get_entity(v):as_movable()
                --calculate if the message yang sends should reappear
                if dist > 4.5 then
                    game_controller.yangchallenge_showmessage = false
                end
                --send yangs message when you buy the challenge
                if game_controller.yangchallenge_active == true and game_controller.yangchallenge_buymessage == false then
                    game_controller.yangchallenge_buymessage = true
                    say_override(v, "Wonderful! I'll be seeing you soon!", 1, false)
                end
                --actually send the message
                yang_interval = set_interval(function()
                    --make sure player is close enough
                    ex, ey, el = get_position(v)
                    px, py, pl = get_position(players[1].uid)
                    --compare y levels of yang and player to make sure the player isnt below yang or too high above himself
                    proper_y_level = false
                    if py < ey+1 and py > ey-1 then
                        proper_y_level = true
                    end
                    if dist < 2.75 and proper_y_level == true and state.theme == THEME.CITY_OF_GOLD then
                        if e.move_state == 0 then
                            if game_controller.yangchallenge_showmessage == false and game_controller.yangchallenge_buymessage == false then
                                game_controller.yangchallenge_showmessage = true
                                say_override(v, "Hello traveller! Say, are you interested in my 'challenge?' C'mon, it'll spice things up!", 0, false)
                                clear_callback(yang_interval)
                            end
                        end
                    end
                end, 180)
            end
        end
        --have yang "poof" like tun does upon death
        for _, v in ipairs(get_entities_by_type(ENT_TYPE.MONS_YANG)) do
            e = get_entity(v):as_movable()
            if e.health == 0 then
                --if yang dies in cog then enable the challenge
                if state.theme == THEME.CITY_OF_GOLD then
                    game_controller.yangchallenge_active = true
                    game_controller.yangchallenge_angry = true
                    say(v, "This isn't over! Wait until my brothers hear about this!", 2, false)
                end
                --make the smoke effect + sound
                generate_particles(160, v)
                play_vanilla_sound(VANILLA_SOUND.SHARED_SMOKE_TELEPORT) 
                --move yang away to hide his sound
                e.x = -999
                kill_entity(v)
                --reward extra l00t based on depth
                if math.random(100) < game_controller.floor and game_controller.yangchallenge_angry == false then --give a crate using this formula (-25 + depth)
                    spawn(ENT_TYPE.ITEM_CRATE, e.x, e.y, 0, 0, 0)
                end
            end
        end
    end
end,
ON.FRAME)
--ON.CAMP
--update the entity DB for this decoration
set_callback(function()
    --customize dbs
    set_yang_db("MUTE")
    --get rid of certain chars
    for _, v in ipairs(get_entities_by_type(ENT_TYPE.CHAR_ANA_SPELUNKY, ENT_TYPE.CHAR_AMAZON, ENT_TYPE.CHAR_LISE_SYSTEM, ENT_TYPE.CHAR_GUY_SPELUNKY, ENT_TYPE.CHAR_CLASSIC_GUY, ENT_TYPE.CHAR_OTAKU, ENT_TYPE.CHAR_AU, ENT_TYPE.CHAR_PRINCESS_AIRYN, ENT_TYPE.CHAR_GREEN_GIRL, ENT_TYPE.CHAR_AMAZON, ENT_TYPE.CHAR_LISE_SYSTEM, ENT_TYPE.CHAR_MANFRED_TUNNEL, ENT_TYPE.CHAR_TINA_FLAN, ENT_TYPE.CHAR_VALERIE_CRUMP, ENT_TYPE.CHAR_DEMI_VON_DIAMONDS, ENT_TYPE.CHAR_PILOT, ENT_TYPE.CHAR_DIRK_YAMAOKA, ENT_TYPE.CHAR_MARGARET_TUNNEL, ENT_TYPE.CHAR_ROFFY_D_SLOTH, ENT_TYPE.CHAR_BANDA, ENT_TYPE.CHAR_COCO_VON_DIAMONDS)) do
        local ent = get_entity(v)
        if players[1].type.id ~= ent.type.id then --dont kill the player
            ent.y = 900
        end
    end
end,
ON.CAMP)
set_callback(function()
    if state.theme == THEME.BASE_CAMP and game_controller.camp_music_playing == false then
        --play camp music
        game_controller.camp_music_playing = true
        custom_music.current_music = custom_music.set_music(assets.mu_camp)
        custom_music.set_volume_instant(game_controller.default_music_volume)
        custom_music.stop_music() --stop any potentially playing music
        custom_music.play_music()
    end
    --lower volume when player starts a run
    if players[1] ~= nil and state.theme == THEME.BASE_CAMP then
        if players[1].state == 20 then
            custom_music.set_volume(0, 0.01)
        end
    end
end, ON.GAMEFRAME)
set_callback(function()
    game_controller.camp_music_playing = false
end, ON.SCREEN)
--ON.GUIFRAME
set_callback(function()
    --determine if the text scaling should be changed at all
    local screenx, screeny = get_window_size()
    local screencalc = (screenx + screeny)/3000
    game_controller.text_scaling = screencalc
    local scaling = game_controller.text_scaling
    --draw extra hud elements (shotgun shells, etc)
    local player_alive = false
    if players[1] ~= nil then
        if players[1].health > 0 and players[1].state ~= 19 then
            player_alive = true
        end
    end
    --draw what the perks do when you highlight them
    if perk_controller.is_in_perk_inventory == true and state.pause == 0 and state.ingame == 1 and player_alive == true then
        local desc, name = get_perk_description(game_controller.equipped_perks[perk_controller.selected_slot])
        local text = tostring(name) .. ":\n" .. tostring(desc)
        local size = 50*scaling
        if desc ~= "" then
            draw_image(assets.ui_textbox, -0.9, -0.9, 0.9, -0.5, 0, 0, 1, 1, white, 0, 0, 0)
            draw_text(-0.85, -0.54, size, text, black)
        end
    end
    if state.pause == 0 and state.ingame == 1 and state.screen == 12 and player_alive == true then
        draw_image(assets.ui_shells, -0.64, 0.924, -0.70, 0.83, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
        draw_text(-0.655, 0.89, 29*scaling, tostring(game_controller.ammo), 0xFFFFFFFF)
        --max health
        draw_text(-0.91, 0.895, 48*scaling, "___", 0xFFFFFFFF)
        draw_text(-0.905, 0.82, 50*scaling, tostring(game_controller.max_health), 0xFFFFFFFF)
    end
    --draw item names + stats (for items)
    if state.pause == 0 and state.ingame == 1 and state.theme == THEME.CITY_OF_GOLD and state.screen == 12 then
        for i, item in ipairs(custom_shop.items) do
            if item ~= nil then
                local ent = get_entity(item)
                px, py, pl = get_position(players[1].uid)
            
                local dist = distance(players[1].uid, item)
                local size = 50*scaling
                local text = tostring(custom_shop.items_by_name[i]) .. ":\n" .. tostring(custom_shop.items_by_description[i]) .. "\nPress your door button to buy for " .. tostring(custom_shop.items_by_price[i]) .. "$."
                if dist < 0.4 then
                    draw_image(assets.ui_textbox, -0.9, -0.9, 0.9, -0.5, 0, 0, 1, 1, white, 0, 0, 0)
                    draw_text(-0.85, -0.54, size, text, black)

                    
                    --purchase items
                    if state.player_inputs.player_slot_1.buttons == 32 then
                        local px, py, pl = get_position(players[1].uid)
                        --thanks dregu for showing me this!!!
                        local money = players[1].inventory.money + players[1].inventory.collected_money_total + state.money_shop_total
                        item_price = custom_shop.items_by_price[i]
                        if money >= item_price then
                            state.money_shop_total = state.money_shop_total - item_price
                            play_vanilla_sound(VANILLA_SOUND.SHOP_SHOP_BUY)
                            ent.x = -5
                            if custom_shop.items_by_type[i] == "SPIKESHOES" then
                                custom_shop.spawn_item("SPIKESHOES")
                            elseif custom_shop.items_by_type[i] == "MIDASTOUCH" then
                                spawn_playerbag_as_custom_pickup(px, py, pl, 0, 0, "MIDASTOUCH")
                            elseif custom_shop.items_by_type[i] == "AMMO" then
                                spawn_playerbag_as_custom_pickup(px, py, pl, 0, 0, "AMMO")
                            elseif custom_shop.items_by_type[i] == "TURKEY" then
                                custom_shop.spawn_item("TURKEY")
                            elseif custom_shop.items_by_type[i] == "BOMBBAG" then
                                custom_shop.spawn_item("BOMBBAG")
                            elseif custom_shop.items_by_type[i] == "MACHETE" then
                                custom_shop.spawn_item("MACHETE")
                            elseif custom_shop.items_by_type[i] == "KAPALA" then
                                custom_shop.spawn_item("KAPALA")
                            elseif custom_shop.items_by_type[i] == "JETPACK" then
                                custom_shop.spawn_item("JETPACK")
                            elseif custom_shop.items_by_type[i] == "EXCALIBUR" then
                                custom_shop.spawn_item("EXCALIBUR")
                            elseif custom_shop.items_by_type[i] == "ROPEPILE" then
                                custom_shop.spawn_item("ROPEPILE")
                            elseif custom_shop.items_by_type[i] == "CRATEPERK" then
                                spawn_playerbag_as_custom_pickup(px, py, pl, 0, 0, "CRATEPERK")
                            elseif custom_shop.items_by_type[i] == "RETURNPOSTAGE" then
                                spawn_playerbag_as_custom_pickup(px, py, pl, 0, 0, "RETURNPOSTAGE")
                            elseif custom_shop.items_by_type[i] == "SHOTGUN" then
                                custom_shop.spawn_item("SHOTGUN")
                            elseif custom_shop.items_by_type[i] == "BROKENKAPALA" then
                                custom_shop.spawn_item("BROKENKAPALA")
                            elseif custom_shop.items_by_type[i] == "PAYOFFPAIN" then
                                spawn_playerbag_as_custom_pickup(px, py, pl, 0, 0, "PAYOFFPAIN")
                            elseif custom_shop.items_by_type[i] == "YANGCHALLENGE" then
                                spawn_playerbag_as_custom_pickup(px, py, pl, 0, 0, "YANGCHALLENGE")
                            elseif custom_shop.items_by_type[i] == "BUTCHERKNIFE" then
                                custom_shop.spawn_item("BUTCHERKNIFE")
                            elseif custom_shop.items_by_type[i] == "BUTTERFLYKNIFE" then
                                custom_shop.spawn_item("BUTTERFLYKNIFE")
                            elseif custom_shop.items_by_type[i] == "STUNSHIELD" then
                                spawn_playerbag_as_custom_pickup(px, py, pl, 0, 0, "STUNSHIELD")
                            elseif custom_shop.items_by_type[i] == "SPARKSHIELD" then
                                spawn_playerbag_as_custom_pickup(px, py, pl, 0, 0, "SPARKSHIELD")
                            elseif custom_shop.items_by_type[i] == "FIREWHIP" then
                                spawn_playerbag_as_custom_pickup(px, py, pl, 0, 0, "FIREWHIP")
                            elseif custom_shop.items_by_type[i] == "GROUNDPOUND" then
                                spawn_playerbag_as_custom_pickup(px, py, pl, 0, 0, "GROUNDPOUND")
                            elseif custom_shop.items_by_type[i] == "HPUP" then
                                spawn_playerbag_as_custom_pickup(px, py, pl, 0, 0, "HPUP")
                            elseif custom_shop.items_by_type[i] == "BPEXPANDER" then
                                spawn_playerbag_as_custom_pickup(px, py, pl, 0, 0, "BPEXPANDER")
                            elseif custom_shop.items_by_type[i] == "TONIC" then
                                spawn_playerbag_as_custom_pickup(px, py, pl, 0, 0, "TONIC")
                            elseif custom_shop.items_by_type[i] == "TEA" then
                                spawn_playerbag_as_custom_pickup(px, py, pl, 0, 0, "TEA")
                            elseif custom_shop.items_by_type[i] == "MEAL" then
                                spawn_playerbag_as_custom_pickup(px, py, pl, 0, 0, "MEAL")
                            elseif custom_shop.items_by_type[i] == "REPELGEL" then
                                spawn_playerbag_as_custom_pickup(px, py, pl, 0, 0, "REPELGEL")
                            elseif custom_shop.items_by_type[i] == "ROPERECLAIMER" then
                                spawn_playerbag_as_custom_pickup(px, py, pl, 0, 0, "ROPERECLAIMER")
                            end
                        end    
                    end
                end
            end
        end
    end
    --draw perks and backpack contents
    if state.pause == 0 and state.ingame == 1 and state.screen == 12 then
        draw_text(-0.96, 0.74, 29*scaling, "Perks:", 0xFFFFFFFF)
        draw_line(-0.96, 0.68, -0.45, 0.68, 2, 0xFFFFFFFF)
        draw_text(-0.96, 0.54, 29*scaling, "Backpack:", 0xFFFFFFFF)
        draw_line(-0.96, 0.48, -0.45, 0.48, 2, 0xFFFFFFFF)

        for i in pairs(game_controller.equipped_perks) do
            --DRAW SHADOW
            if perk_controller.is_equipped[i] == true then --SHADOW
                draw_image(assets.ico_perk_shadow, -0.96+(0.07*(i-1)), 0.66, -0.9+(0.07*(i-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            --DRAW ICON
            if game_controller.equipped_perks[i] == "MIDASTOUCH" then
                draw_image(assets.ico_midas, -0.96+(0.07*(i-1)), 0.66, -0.9+(0.07*(i-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if game_controller.equipped_perks[i] == "RETURNPOSTAGE" then
                draw_image(assets.ico_returnpostage, -0.96+(0.07*(i-1)), 0.66, -0.9+(0.07*(i-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if game_controller.equipped_perks[i] == "CRATEPERK" then
                draw_image(assets.ico_crateperk, -0.96+(0.07*(i-1)), 0.66, -0.9+(0.07*(i-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if game_controller.equipped_perks[i] == "PAYOFFPAIN" then
                draw_image(assets.ico_doublepain, -0.96+(0.07*(i-1)), 0.66, -0.9+(0.07*(i-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if game_controller.equipped_perks[i] == "STUNSHIELD" then
                draw_image(assets.ico_doublepain, -0.96+(0.07*(i-1)), 0.66, -0.9+(0.07*(i-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if game_controller.equipped_perks[i] == "SPARKSHIELD" then
                draw_image(assets.ico_doublepain, -0.96+(0.07*(i-1)), 0.66, -0.9+(0.07*(i-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if game_controller.equipped_perks[i] == "FIREWHIP" then
                draw_image(assets.ico_firewhip, -0.96+(0.07*(i-1)), 0.66, -0.9+(0.07*(i-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if game_controller.equipped_perks[i] == "GROUNDPOUND" then
                draw_image(assets.ico_groundpound, -0.96+(0.07*(i-1)), 0.66, -0.9+(0.07*(i-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if game_controller.equipped_perks[i] == "ROPERECLAIMER" then
                draw_image(assets.ico_doublepain, -0.96+(0.07*(i-1)), 0.66, -0.9+(0.07*(i-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            --DRAW PERK TIER
            if perk_controller.is_equipped[i] == true then --PERK TIER
                draw_perk_tier(i, game_controller.equipped_perks[i])
            end
            if perk_controller.selected_slot == i and perk_controller.is_in_perk_inventory then --HIGHLIGHT
                draw_image(assets.ico_highlight, -0.96+(0.07*(i-1)), 0.66, -0.9+(0.07*(i-1)), 0.55, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
        end
        --draw all slots the player has to use in their backpack
        for i=1, backpack_controller.max_slots, 1 do
            draw_image(assets.ico_shadow, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0) --SHADOW
            if backpack_controller.selected_slot == i and backpack_controller.is_in_backpack then --HIGHLIGHT
                draw_image(assets.ico_highlight, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
        end
        for i in pairs(backpack_controller.items) do
            if backpack_controller.items[i] == "JETPACK" then
                draw_image(assets.ico_jetpack, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "SHOTGUN" then
                draw_image(assets.ico_shotgun, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "EXCALIBUR" then
                draw_image(assets.ico_excalibur, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "BUTCHERKNIFE" then
                draw_image(assets.ico_butcherknife, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "BUTTERFLYKNIFE" then
                draw_image(assets.ico_butterflyknife, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "MACHETE" then
                draw_image(assets.ico_machete, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "ROCK" then
                draw_image(assets.ico_rock, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "ARROW" then
                draw_image(assets.ico_arrow, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "ARROW_BUTT" then
                draw_image(assets.ico_arrow_butt, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "SKULL" then
                draw_image(assets.ico_skull, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "TONIC" then
                draw_image(assets.ico_tonic, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "TEA" then
                draw_image(assets.ico_tea, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "MEAL" then
                draw_image(assets.ico_meal, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "REPELGEL" then
                draw_image(assets.ico_repelgel, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "SCEPTER" then
                draw_image(assets.ico_scepter, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "IDOL" then
                draw_image(assets.ico_idol, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "CAPE" then
                draw_image(assets.ico_cape, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "WEBGUN" then
                draw_image(assets.ico_webgun, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "FREEZERAY" then
                draw_image(assets.ico_freezeray, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "PLASMACANNON" then
                draw_image(assets.ico_plasmacannon, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "TELEPORTER" then
                draw_image(assets.ico_teleporter, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "BOOMERANG" then
                draw_image(assets.ico_boomerang, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "CROSSBOW" then
                draw_image(assets.ico_crossbow, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "METALARROW" then
                draw_image(assets.ico_metalarrow, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "TELEPACK" then
                draw_image(assets.ico_telepack, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "VLADSCAPE" then
                draw_image(assets.ico_vladscape, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "MATTOCK" then
                draw_image(assets.ico_mattock, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "HOVERPACK" then
                draw_image(assets.ico_hoverpack, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "TORCH" then
                draw_image(assets.ico_torch, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "COBOW" then
                draw_image(assets.ico_cobow, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "LIGHTARROW" then
                draw_image(assets.ico_lightarrow, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "TUSKIDOL" then
                draw_image(assets.ico_tuskidol, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "MINE" then
                draw_image(assets.ico_mine, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "POWERPACK" then
                draw_image(assets.ico_powerpack, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "LAVAPOT" then
                draw_image(assets.ico_lavapot, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "SNAPTRAP" then
                draw_image(assets.ico_snaptrap, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "KEY" then
                draw_image(assets.ico_key, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "WOODENSHIELD" then
                draw_image(assets.ico_woodenshield, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "METALSHIELD" then
                draw_image(assets.ico_shield, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "CAVEMAN" then
                draw_image(assets.ico_caveman, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "CURSEGUN" then
                draw_image(assets.ico_cursegun, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
            if backpack_controller.items[i] == "MAGGOTGUN" then
                draw_image(assets.ico_maggotgun, -0.96+(0.07*(i-1)), 0.46, -0.9+(0.07*(i-1)), 0.35, 0, 0, 1, 1, 0xFFFFFFFF, 0, 0, 0)
            end
        end
    end
    --draw the broken kapala symbol on the kapala
    if game_controller.has_brokenkapala == true then
        if state.pause == 0 and state.ingame == 1 and state.screen == 12 then
            
        end
    end
    --stop music when changing to certain screens
    if (state.screen == 4 or state.screen == 9 or state.screen == 14 or state.screen == 11) and state.theme ~= THEME.BASE_CAMP then
        custom_music.set_volume(0, 0.01)
    end
end,
ON.GUIFRAME)
--ON.TRANSITION
set_callback(function()
    --stop repelgel
    game_controller.repelgel_active = false
    --clear out any custom playerbags
    game_controller.special_playerbags = {}
    game_controller.special_playerbag_effects = {}

    --clear out miniboss stuff
    game_controller.miniboss_active = 0
    game_controller.miniboss_enemies = {}
    game_controller.miniboss_walls = {}

    --clear out enemies to kill
    game_controller.current_enemies_left = {}

    --reset sparkshield stuff
    game_controller.sparkshield_timer = 600
    game_controller.player_sparktrap_uid = -1

    --SHOP INVENTORY
    custom_shop.items = {}
    custom_shop.items_by_price = {}
    custom_shop.items_by_type = {}
    custom_shop.items_by_name = {}
    custom_shop.items_by_description = {}

    --custom key effect
    game_controller.enemy_with_key = -1; --UID of entity holding the exit key
    game_controller.exit_key_effect_uid = -1;
    game_controller.exit_key_uid = -1;
end,
ON.TRANSITION)

--reset yang timer on every screen transition (because it should)
set_callback(function()
    game_controller.yangchallenge_spawntime = 1800
    game_controller.yangchallenge_spawned = false --this needs to be reset too
end, ON.TRANSITION)
--reset game variables on death
set_callback(function()
    reset_game_controllers()
    custom_music.set_volume(0, 0.01)
end, 
ON.DEATH)

--update settings and manage music volume
set_callback(function()
    game_controller.default_music_volume = options.custom_music_volume
    if options.custom_music_volume ~= 0 then
        game_controller.paused_music_volume = options.custom_music_volume/5
    else
        game_controller.paused_music_volume = 0
    end
end, ON.GUIFRAME)

--remove random item drops
set_drop_chance(DROPCHANCE.BONEBLOCK_SKELETONKEY, -1)
set_drop_chance(DROPCHANCE.CROCMAN_TELEPACK, -1)
set_drop_chance(DROPCHANCE.HANGINGSPIDER_WEBGUN, -1)
set_drop_chance(DROPCHANCE.JIANGSHIASSASSIN_SPIKESHOES, -1)
set_drop_chance(DROPCHANCE.JIANGSHI_SPRINGSHOES, -1)
set_drop_chance(DROPCHANCE.MOLE_MATTOCK, -1)
set_drop_chance(DROPCHANCE.MOSQUITO_HOVERPACK, -1)
set_drop_chance(DROPCHANCE.ROBOT_METALSHIELD, -1)
set_drop_chance(DROPCHANCE.SKELETON_SKELETONKEY, -1)
set_drop_chance(DROPCHANCE.UFO_PARACHUTE, -1)
set_drop_chance(DROPCHANCE.YETI_PITCHERSMITT, -1)
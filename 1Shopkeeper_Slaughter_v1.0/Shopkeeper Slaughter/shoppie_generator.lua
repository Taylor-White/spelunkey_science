shoppie_generators = {}

function manage_shoppie_generators()
    for _, v in ipairs(shoppie_generators) do
        if get_entity(v) ~= nil then
            local ent = get_entity(v)
            local x, y, l = get_position(v)
            --pre shoppie warning
            if ent.timer == 90 and shopkeeper_slaughter.shoppie_warnings_left > 0  then
                shopkeeper_slaughter.shoppie_warnings_left = shopkeeper_slaughter.shoppie_warnings_left - 1
                local ent = get_entity(spawn(ENT_TYPE.LOGICAL_DM_CRATE_SPAWNING, x, y-0.4, l, 0, 0))
                set_timeout(function()
                    kill_entity(ent.uid)
                end, 90)
            end
            if ent.timer == 3 and shopkeeper_slaughter.shoppies_left > 0 then
                set_timeout(function()
                    shopkeeper_slaughter.shoppies_left = shopkeeper_slaughter.shoppies_left - 1
                end, 1)
                local shoppie = get_entity(spawn_shopkeeper(x, y-0.05, l))
                if shoppie ~= nil then
                    shoppie.velocityy = -0.04
                    shoppie.flags = clr_flag(shoppie.flags, 13)
                    set_timeout(function()
                        shoppie.flags = set_flag(shoppie.flags, 29)
                        --disarm the shoppie
                        local shotgun = get_entity(shoppie.holding_uid)
                        drop(shoppie.uid, shotgun.uid)
                        shotgun:destroy()
                        --optionally re-arm the shoppie
                        pick_up(shoppie.uid, spawn(determine_shopkeeper_weapon(), x, y, l, 0, 0))

                    end, 1)
                    shoppie.flags = set_flag(shoppie.flags, 10)
                    shoppie.flags = set_flag(shoppie.flags, 6)
                    shoppie.flags = set_flag(shoppie.flags, 5)
                    shoppie.flags = set_flag(shoppie.flags, 4)
                    play_vanilla_sound(VANILLA_SOUND.TRAPS_GENERATOR_GENERATE)
                    set_timeout(function()
                        shoppie.flags = set_flag(shoppie.flags, 13)
                        shoppie.flags = clr_flag(shoppie.flags, 29)
                        shoppie.flags = clr_flag(shoppie.flags, 10)
                        shoppie.flags = clr_flag(shoppie.flags, 6)
                        shoppie.flags = clr_flag(shoppie.flags, 5)
                        shoppie.flags = clr_flag(shoppie.flags, 4)
                    end, 20)
                    ent.timer = shopkeeper_slaughter.base_spawn_time
                end
            end
            if shopkeeper_slaughter.shoppies_left <= 0 then
                ent.timer = -1
            end
        end
    end
    --properly update shoppie count
    if shopkeeper_slaughter.active then
        local alive_shoppies = 0
        for _, v in ipairs(get_entities_by_type(ENT_TYPE.MONS_SHOPKEEPERCLONE)) do
            local ent = get_entity(v)
            if ent.health > 0 then
                alive_shoppies = alive_shoppies + 1
            end
        end      
        shopkeeper_slaughter.shoppie_count = shopkeeper_slaughter.shoppies_left + alive_shoppies
    end
end

set_callback(manage_shoppie_generators, ON.GAMEFRAME)
set_callback(function() shoppie_generators = {} end, ON.PRE_LEVEL_GENERATION)

define_tile_code("shoppie_generator")
set_pre_tile_code_callback(function(x, y, layer)
    local shoppie_generator = get_entity(spawn(ENT_TYPE.FLOOR_FACTORY_GENERATOR, x, y, layer, 0, 0))
    shoppie_generator.set_timer = shopkeeper_slaughter.base_spawn_time - math.random(-200, 200)
    shoppie_generator.timer = shoppie_generator.set_timer
    table.insert(shoppie_generators, shoppie_generator.uid)
end, "shoppie_generator")
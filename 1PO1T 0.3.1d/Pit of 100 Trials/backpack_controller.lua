
local backpack_controller = {
    backpack_button = 48;
    backpack_button_pressed = false;
    backpack_enable = false;
    items = {}; --list of items, uses my custom items with their names in string form as IDs
    items_uids = {};
    is_in_backpack = false; 
    selected_slot = 1;
    max_slots = 2;
}

function backpack_controller.perform_consumable_effect(consumable) 
    if consumable == "TONIC" then
        toast_override("You feel refreshed! Poison cured.")
        players[1]:is_poisoned(false)
        players[1]:poison(-1)
    elseif consumable == "TEA" then
        toast_override("You feel refreshed! Poison and curse cured.")
        players[1]:is_poisoned(false)
        players[1]:poison(-1)
        players[1].more_flags = clr_flag(players[1].more_flags, 15)
    elseif consumable == "MEAL" then
        players[1].health = players[1].health + 3
        toast_override("You feel full! HP increased by 3.")
    elseif consumable == "REPELGEL" then
        toast_override("You feel transparent! You are now invincible for this floor.")
        game_controller.repelgel_active = true
        game_controller.repelgel_health_before_use = players[1].health
    end
end
set_callback(function()
    if players[1] ~= nil and honorbound_controller.items == false then
        local player_slot = state.player_inputs.player_slot_1
        if backpack_controller.is_in_backpack == true then
            players[1].more_flags = set_flag(players[1].more_flags, 16)
        elseif backpack_controller.is_in_backpack == false then
            players[1].more_flags = clr_flag(players[1].more_flags, 16)
        end
        --ENTER THE BACKPACK
        if (players[1].state == 5 or players[1].state == 1 or players[1].state == 0 or players[1].state == 4) and (players[1]:is_button_held(16) and players[1]:is_button_pressed(32)) and perk_controller.is_in_perk_inventory == false then

            backpack_controller.selected_slot = 1
            --ITEMS INTO BACKPACK
            local px, py, pl = get_position(players[1].uid)
            if backpack_controller.is_in_backpack == false and #backpack_controller.items < backpack_controller.max_slots and players[1].holding_uid ~= -1 then
                local ent = get_entity(players[1].holding_uid)
                --SHOTGUN
                if ent.type.id == ENT_TYPE.ITEM_SHOTGUN then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "SHOTGUN")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --EXCALIBUR
                if ent.type.id == ENT_TYPE.ITEM_EXCALIBUR then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "EXCALIBUR")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --MACHETE
                if ent.type.id == ENT_TYPE.ITEM_MACHETE then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    ent.y = 1000
                    players[1]:drop(get_entity(players[1].holding_uid))
                    --determine if this is a butchers knife or not
                    if is_butchersknife(ent.uid) then
                        table.insert(backpack_controller.items, "BUTCHERKNIFE")
                    elseif is_butterflyknife(ent.uid) then
                        table.insert(backpack_controller.items, "BUTTERFLYKNIFE")
                    else
                        table.insert(backpack_controller.items, "MACHETE")
                    end
                    return
                end
                --JETPACK
                if ent.type.id == ENT_TYPE.ITEM_JETPACK and ent.overlay == nil then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "JETPACK")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --ROCK
                if ent.type.id == ENT_TYPE.ITEM_ROCK then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "ROCK")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --ARROW
                if ent.type.id == ENT_TYPE.ITEM_WOODEN_ARROW then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "ARROW")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --ARROW BUTT
                if ent.type.id == ENT_TYPE.ITEM_BROKEN_ARROW then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "ARROW_BUTT")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --SKULL
                if ent.type.id == ENT_TYPE.ITEM_SKULL then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "SKULL")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --CAPE
                if ent.type.id == ENT_TYPE.ITEM_CAPE then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    players[1]:drop(get_entity(players[1].holding_uid))
                    table.insert(backpack_controller.items, "CAPE")
                    ent.y = 1000
                    return
                end
                --SCEPTER
                if ent.type.id == ENT_TYPE.ITEM_SCEPTER then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "SCEPTER")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --IDOL
                if ent.type.id == ENT_TYPE.ITEM_IDOL then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "IDOL")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --WEBGUN
                if ent.type.id == ENT_TYPE.ITEM_WEBGUN then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "WEBGUN")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --FREEZERAY
                if ent.type.id == ENT_TYPE.ITEM_FREEZERAY then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    if is_cursegun(ent.uid) then
                        table.insert(backpack_controller.items, "CURSEGUN")
                    elseif is_maggotgun(ent.uid) then
                        table.insert(backpack_controller.items, "MAGGOTGUN")
                    else
                        table.insert(backpack_controller.items, "FREEZERAY")
                    end
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --PLASMACANNON
                if ent.type.id == ENT_TYPE.ITEM_PLASMACANNON then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "PLASMACANNON")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --TELEPORTER
                if ent.type.id == ENT_TYPE.ITEM_TELEPORTER then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "TELEPORTER")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --BOOMERANG
                if ent.type.id == ENT_TYPE.ITEM_BOOMERANG then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "BOOMERANG")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --CROSSBOW
                if ent.type.id == ENT_TYPE.ITEM_CROSSBOW then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "CROSSBOW")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --METALARROW
                if ent.type.id == ENT_TYPE.ITEM_METAL_ARROW then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "METALARROW")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --TELEPACK
                if ent.type.id == ENT_TYPE.ITEM_TELEPORTER_BACKPACK then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "TELEPACK")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --VLADSCAPE
                if ent.type.id == ENT_TYPE.ITEM_VLADS_CAPE then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "VLADSCAPE")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --MATTOCK
                if ent.type.id == ENT_TYPE.ITEM_MATTOCK then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "MATTOCK")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --HOVERPACK
                if ent.type.id == ENT_TYPE.ITEM_HOVERPACK then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "HOVERPACK")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --TORCH
                if ent.type.id == ENT_TYPE.ITEM_TORCH then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "TORCH")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --COBOW
                if ent.type.id == ENT_TYPE.ITEM_HOUYIBOW then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "COBOW")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --LIGHTARROW
                if ent.type.id == ENT_TYPE.ITEM_LIGHT_ARROW then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "LIGHTARROW")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --TUSKIDOL
                if ent.type.id == ENT_TYPE.ITEM_MADAMETUSK_IDOL then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "TUSKIDOL")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --MINE
                if ent.type.id == ENT_TYPE.ITEM_MINE then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "MINE")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --POWERPACK
                if ent.type.id == ENT_TYPE.ITEM_POWERPACK then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "POWERPACK")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --LAVAPOT
                if ent.type.id == ENT_TYPE.ITEM_LAVAPOT then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "LAVAPOT")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --SNAPTRAP
                if ent.type.id == ENT_TYPE.ITEM_SNAP_TRAP then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "SNAPTRAP")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --WOODSHIELD
                if ent.type.id == ENT_TYPE.ITEM_WOODEN_SHIELD then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "WOODSHIELD")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --METALSHIELD
                if ent.type.id == ENT_TYPE.ITEM_METAL_SHIELD then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "METALSHIELD")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
                --CAVEMAN
                if ent.type.id == ENT_TYPE.MONS_CAVEMAN then
                    generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, ent.uid)
                    play_vanilla_sound(VANILLA_SOUND.MOUNTS_MOUNT, 1)
                    table.insert(backpack_controller.items, "CAVEMAN")
                    players[1]:drop(get_entity(players[1].holding_uid))
                    ent.y = 1000
                    return
                end
            end
            --ENABLING BACKPACK 
            if backpack_controller.is_in_backpack == false then
                backpack_controller.is_in_backpack = true
                play_vanilla_sound(VANILLA_SOUND.MENU_NAVI)
            end
        end
        --exit backpack
        if (test_flag(player_slot.buttons, 6) and not test_flag(player_slot.buttons, 5)) and backpack_controller.is_in_backpack then
            backpack_controller.is_in_backpack = false
            play_vanilla_sound(VANILLA_SOUND.MENU_CANCEL)
        end
        --move through backpack
        if backpack_controller.is_in_backpack == true then
            if perk_controller.left_button_pressed == true then
                if backpack_controller.selected_slot - 1 > 0 then
                    backpack_controller.selected_slot = backpack_controller.selected_slot - 1
                    play_vanilla_sound(VANILLA_SOUND.MENU_MM_BAR)
                else
                    backpack_controller.selected_slot = backpack_controller.max_slots
                    play_vanilla_sound(VANILLA_SOUND.MENU_MM_BAR)
                end
            end
            if perk_controller.right_button_pressed == true then
                if backpack_controller.selected_slot + 1 <= backpack_controller.max_slots then
                    backpack_controller.selected_slot = backpack_controller.selected_slot + 1
                    play_vanilla_sound(VANILLA_SOUND.MENU_MM_BAR)
                else
                    backpack_controller.selected_slot = 1
                    play_vanilla_sound(VANILLA_SOUND.MENU_MM_BAR)
                end
            end
        end
        --take items out of backpack
        if backpack_controller.is_in_backpack == true then
            if perk_controller.jump_button_pressed == true then
                if backpack_controller.items[backpack_controller.selected_slot] ~= nil then
                    if backpack_controller.items[backpack_controller.selected_slot] ~= "TONIC" and backpack_controller.items[backpack_controller.selected_slot] ~= "TEA" and backpack_controller.items[backpack_controller.selected_slot] ~= "MEAL" and backpack_controller.items[backpack_controller.selected_slot] ~= "REPELGEL" then
                        local item = custom_shop.spawn_item(backpack_controller.items[backpack_controller.selected_slot])
                        generate_particles(PARTICLEEMITTER.COLLECTPOOF_CLOUDS, item)
                    else
                        --perform the effects of the consumable
                        backpack_controller.perform_consumable_effect(backpack_controller.items[backpack_controller.selected_slot])
                    end
                    table.remove(backpack_controller.items, backpack_controller.selected_slot)
                    backpack_controller.selected_slot = 1
                    play_vanilla_sound(VANILLA_SOUND.MENU_MM_TOGGLE, 1)
                end
            end
        end
    end
end, ON.FRAME)

return backpack_controller

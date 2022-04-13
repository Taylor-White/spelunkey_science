--This holds tons of variables that control the custom gamemode
local perk_controller = {
    inventory_button = 1056; --i know this is kind of a cheap way to do this, but i think it works to my benefit since now opening the menu has to be deliberate

    inventory_button_pressed = false;
    inventory_enable = false;
    left_button_pressed = false;
    left_enable = false;
    right_button_pressed = false;
    right_enable = false;
    jump_button_pressed = false;
    jump_enable = false;
    whip_button_pressed = false;
    whip_enable = false;

    is_equipped = {}; --list of bools used to determine if a perk should be active or not
    is_in_perk_inventory = false; 
    selected_slot = 1; --which slot the player has currently highlighted
}
--determine if player is in the perk manager menu
set_callback(function()
    if players[1] ~= nil and not honorbound_controller.perks then
        local player_slot = state.player_inputs.player_slot_1
        if perk_controller.is_in_perk_inventory == true then
            steal_input(players[1].uid)
        elseif backpack_controller.is_in_backpack == false then
            return_input(players[1].uid)
        end

        --get inputs
        --JUMP
        if test_flag(player_slot.buttons, 1) == true and perk_controller.jump_enable == true then
            perk_controller.jump_enable = false
            perk_controller.jump_button_pressed = true
        else
            perk_controller.jump_button_pressed = false
        end
        if test_flag(player_slot.buttons, 1) == false then
            perk_controller.jump_enable = true
        end
        --WHIP
        if test_flag(player_slot.buttons, 2) == true and perk_controller.whip_enable == true then
            perk_controller.whip_enable = false
            perk_controller.whip_button_pressed = true
        else
            perk_controller.whip_button_pressed = false
        end
        if test_flag(player_slot.buttons, 2) == false then
            perk_controller.whip_enable = true
        end
        --INVENTORY
        if player_slot.buttons == perk_controller.inventory_button and perk_controller.inventory_enable == true then
            perk_controller.inventory_enable = false
            perk_controller.inventory_button_pressed = true
        else
            perk_controller.inventory_button_pressed = false
        end
        if player_slot.buttons ~= perk_controller.inventory_button then
            perk_controller.inventory_enable = true
        end
        --LEFT
        if test_flag(player_slot.buttons, 9) == true and perk_controller.left_enable == true then
            perk_controller.left_enable = false
            perk_controller.left_button_pressed = true
        else
            perk_controller.left_button_pressed = false
        end
        if test_flag(player_slot.buttons, 9) == false then
            perk_controller.left_enable = true
        end
        --RIGHT
        if test_flag(player_slot.buttons, 10) == true and perk_controller.right_enable == true then
            perk_controller.right_enable = false
            perk_controller.right_button_pressed = true
        else
            perk_controller.right_button_pressed = false
        end
        if test_flag(player_slot.buttons, 10) == false then
            perk_controller.right_enable = true
        end
        --enter perk inventory
        if players[1].state == 1 and perk_controller.inventory_button_pressed == true and backpack_controller.is_in_backpack == false and not honorbound_controller.perks then
            if perk_controller.is_in_perk_inventory == false then
                perk_controller.is_in_perk_inventory = true
                play_vanilla_sound(VANILLA_SOUND.MENU_NAVI)
            else
                perk_controller.is_in_perk_inventory = false
                perk_controller.selected_slot = 1
                play_vanilla_sound(VANILLA_SOUND.MENU_CANCEL)
            end
        end
        --select through perks
        if perk_controller.is_in_perk_inventory == true then
            if #game_controller.equipped_perks == 0 then
                perk_controller.selected_slot = 1
            else
                if perk_controller.left_button_pressed == true then
                    if perk_controller.selected_slot - 1 > 0 then
                        perk_controller.selected_slot = perk_controller.selected_slot - 1
                        play_vanilla_sound(VANILLA_SOUND.MENU_MM_BAR)
                    else
                        --wrap around
                        perk_controller.selected_slot = #game_controller.equipped_perks
                        play_vanilla_sound(VANILLA_SOUND.MENU_MM_BAR)
                    end
                end
                if perk_controller.right_button_pressed == true then
                    if perk_controller.selected_slot + 1 <= #game_controller.equipped_perks then
                        perk_controller.selected_slot = perk_controller.selected_slot + 1
                        play_vanilla_sound(VANILLA_SOUND.MENU_MM_BAR)
                    else
                        perk_controller.selected_slot = 1
                        play_vanilla_sound(VANILLA_SOUND.MENU_MM_BAR)
                    end
                end
                --equip / unequip perks
                if perk_controller.jump_button_pressed == true then
                    if perk_controller.is_equipped[perk_controller.selected_slot] == false then
                        perk_controller.is_equipped[perk_controller.selected_slot] = true
                        play_vanilla_sound(VANILLA_SOUND.MENU_MM_TOGGLE)
                    else
                        perk_controller.is_equipped[perk_controller.selected_slot] = false
                        play_vanilla_sound(VANILLA_SOUND.MENU_MM_TOGGLE)
                    end
                end
                --remove perks
                if perk_controller.whip_button_pressed == true and game_controller.equipped_perks[perk_controller.selected_slot] ~= nil then
                    local lor = math.random(2)
                    if lor == 2 then
                        lor = -1
                    end
                    spawn_playerbag_as_custom_pickup(players[1].x, players[1].y+0.65, 0, lor/15, math.random(2, 5)/50, game_controller.equipped_perks[perk_controller.selected_slot])
                    if #game_controller.equipped_perks == 0 then
                        perk_controller.is_in_perk_inventory = false
                        perk_controller.selected_slot = 1
                        play_vanilla_sound(VANILLA_SOUND.MENU_MM_TOGGLE)
                    end
                    table.remove(game_controller.equipped_perks, perk_controller.selected_slot)
                    table.remove(perk_controller.is_equipped, perk_controller.selected_slot)
                    play_vanilla_sound(VANILLA_SOUND.SHARED_BUBBLE_BURST)
                end
            end
        end
    end
end, ON.FRAME)


return perk_controller
has_ropereclaimer = 0

function do_ropereclaimer_effect()
    if has_ropereclaimer > 0 and players[1] ~= nil then
        for _, v in ipairs(get_entities_by_type(ENT_TYPE.ITEM_CLIMBABLE_ROPE)) do
            local ent = get_entity(v)
            rx, ry, rl = get_position(v)
            if ent:overlaps_with(players[1]) then
                if ent.animation_frame == 157 and players[1]:is_button_pressed(32) and players[1].state == 6 then
                    steal_input(players[1].uid)
                    send_input(players[1].uid, 1)
                    spawn(ENT_TYPE.ITEM_PICKUP_ROPE, rx, ry+0.5, rl, 0, 0)
                    play_vanilla_sound(VANILLA_SOUND.ITEMS_ROPE_ATTACH)
                    set_timeout(function()
                        return_input(players[1].uid)
                        ent:remove()
                    end, 1)
                end
            end
        end
    end
end
set_callback(do_ropereclaimer_effect, ON.FRAME)

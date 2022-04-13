caveman_as_lizard_ents = {}

function spawn_caveman_as_lizard(x, y, l, xvel, yvel)
    local caveman_as_lizard_ent = get_entity(spawn(ENT_TYPE.MONS_HORNEDLIZARD, x, y, l, xvel, yvel))
    table.insert(caveman_as_lizard_ents, caveman_as_lizard_ent.uid)
    caveman_as_lizard_ent:set_texture(texturevars.quillback_minion_texture)
    return caveman_as_lizard_ent.uid
end
function clear_caveman_as_lizard_ents()
    caveman_as_lizard_ents = {}
end
function manage_caveman_as_lizard_ents()
    for _, v in ipairs(caveman_as_lizard_ents) do
        local ent = get_entity(v)
        local x, y, l = get_position(v)
        if ent ~= nil then
            if ent.state == 1 and ent.move_state == 2 then
                play_vanilla_sound(VANILLA_SOUND.ENEMIES_CAVEMAN_TRIGGER)
                play_vanilla_sound(VANILLA_SOUND.ENEMIES_BOSS_CAVEMAN_JUMP)
            end
        end
    end
end

set_callback(clear_caveman_as_lizard_ents, ON.PRE_LEVEL_GENERATION)
set_callback(manage_caveman_as_lizard_ents, ON.FRAME)

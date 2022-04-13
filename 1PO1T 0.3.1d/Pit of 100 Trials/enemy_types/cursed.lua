cursed_ents = {}

function spawn_as_cursed(type, x, y, l, xvel, yvel)
    local ent = get_entity(spawn(type, x, y, l, xvel, yvel))
    ent.more_flags = set_flag(ent.more_flags, 15) --this doesnt actually curse the entity,, just visual .
    ent.health = 1
    generate_particles(PARTICLEEMITTER.CURSEDEFFECT_PIECES, ent.uid)
    table.insert(cursed_ents, ent.uid)
    return ent.uid
end
function clear_cursed_ents()
    cursed_ents = {}
end
function manage_cursed_ents()
    for i, v  in ipairs(cursed_ents) do
        local cursed_ent = get_entity(v)
        if cursed_ent ~= nil then
            if cursed_ent.health == 0 then
                local x, y, l = get_position(v)
                spawn(ENT_TYPE.ITEM_DIAMOND, x, y, l, 0, 0.05)
                --curse cloud
                local curse1 = get_entity(spawn(ENT_TYPE.ITEM_CURSING_CLOUD, x, y, l, -0.1, 0))
                local curse2 = get_entity(spawn(ENT_TYPE.ITEM_CURSING_CLOUD, x, y, l, 0.1, 0))
                play_vanilla_sound(VANILLA_SOUND.PLAYER_DEATH_GHOST)
                --spawn a ghost pot
                spawn(ENT_TYPE.ITEM_CURSEDPOT, -900, 0, 0, 0, 0)
                flip_entity(curse1.uid)
                move_entity(v, -900, 0, 0, 0)
                table.remove(cursed_ents, i)
            end
        end
    end
end

set_callback(clear_cursed_ents, ON.PRE_LEVEL_GENERATION)
set_callback(manage_cursed_ents, ON.FRAME)
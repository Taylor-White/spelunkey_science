caveman_as_snake_ents = {}
caveman_as_snake_cutouts = {}
function spawn_caveman_as_snake_cutout(x, y, l, xvel, yvel)
    local cutout = get_entity(spawn(ENT_TYPE.ITEM_TUTORIAL_MONSTER_SIGN, x, y, l, xvel, yvel))
    table.insert(caveman_as_snake_cutouts, cutout.uid)
    cutout.animation_frame = 195
    cutout.flags = set_flag(cutout.flags, 4)
    return cutout.uid
end
function spawn_caveman_as_snake(x, y, l, xvel, yvel)
    local caveman_as_snake_ent = get_entity(spawn(ENT_TYPE.MONS_CAVEMAN, x, y, l, xvel, yvel))
    table.insert(caveman_as_snake_ents, caveman_as_snake_ent.uid)
    caveman_as_snake_ent.health = 1
    pick_up(caveman_as_snake_ent.uid, spawn_caveman_as_snake_cutout(x, y, l, xvel, yvel))
    return caveman_as_snake_ent.uid
end
function clear_caveman_as_snake_ents()
    caveman_as_snake_ents = {}
    caveman_as_snake_cutouts = {}
end
function manage_caveman_as_snake_ents()
    for i, v in ipairs(caveman_as_snake_cutouts) do
        local ent = get_entity(v)
        if get_entity(caveman_as_snake_ents[i]) == nil then
            kill_entity(v)
        end
        if ent ~= nil then
            if ent.overlay == nil then
                pick_up(caveman_as_snake_ents[i], caveman_as_snake_cutouts[i])
            end
        end
    end
end

set_callback(clear_caveman_as_snake_ents, ON.PRE_LEVEL_GENERATION)
set_callback(manage_caveman_as_snake_ents, ON.FRAME)

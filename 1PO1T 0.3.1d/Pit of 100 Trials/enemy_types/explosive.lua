explosive_ents = {}

function spawn_as_explosive(id, x, y, l, xvel, yvel)
    local explosive_ent = get_entity(spawn(id, x, y, l, xvel, yvel))
    table.insert(explosive_ents, explosive_ent.uid)
    explosive_ent.color.g = 0.1
    explosive_ent.color.b = 0.1
    explosive_ent.color.r = 1
    return explosive_ent.uid
end
function clear_explosive_ents()
    explosive_ents = {}
end
function manage_explosive_ents()
    for _, v in ipairs(explosive_ents) do
        local ent = get_entity(v)
        local x, y, l = get_position(v)
        if ent ~= nil then
            if ent.health == 0 then
                spawn(ENT_TYPE.FX_EXPLOSION, x, y, l, 0, 0)
                spawn(ENT_TYPE.ITEM_PICKUP_BOMBBAG, x, y, l, 0, 0)
                kill_entity(v)
            end
        end
    end
end

set_callback(clear_explosive_ents, ON.PRE_LEVEL_GENERATION)
set_callback(manage_explosive_ents, ON.FRAME)

armored_ents = {}

function spawn_as_armored(id, x, y, l, xvel, yvel)
    local armored_ent = get_entity(spawn(id, x, y, l, xvel, yvel))
    table.insert(armored_ents, armored_ent.uid)
    armored_ent.color.g = 0.2
    armored_ent.color.b = 0.7
    armored_ent.color.r = 0.4
    spawn_armored_ent_shield(armored_ent.uid)
    return armored_ent.uid
end
function spawn_armored_ent_shield(uid)
    local shield = spawn(ENT_TYPE.ITEM_METAL_SHIELD, 0, 0, 0, 0, 0)
    local shield_ent = get_entity(shield)  
    shield_ent.color.a = 0.8
    pick_up(uid, shield)  
end
function clear_armored_ents()
    armored_ents = {}
end
function manage_armored_ents()
    for _, v in ipairs(get_entities_by_type(ENT_TYPE.ITEM_METAL_SHIELD)) do
        local shield_ent = get_entity(v)
        if shield_ent.color.a <= 0.9 and shield_ent.overlay == nil then
            shield_ent.x = -900
        end
    end
    --make armored enemies pick their shield up once stunned
    for i, v in ipairs(armored_ents) do
        local armored_ent = get_entity(v)
        local ex, ey, el = get_position(v)
        if armored_ent ~= nil then
            if armored_ent.holding_uid == -1 then
                if armored_ent.stun_timer ~= 0 and not test_flag(armored_ent.flags, 29) then
                    spawn_armored_ent_shield(armored_ent.uid)
                end 
            end
            if armored_ent.health == 0 then
                if math.random(PO1T_DROPCHANCE.ARMORED) == 1 then
                    spawn(ENT_TYPE.ITEM_METAL_SHIELD, ex, ey, el, 0, 0)
                end
                table.remove(armored_ents, i)
            end
        end
    end
end

set_callback(clear_armored_ents, ON.PRE_LEVEL_GENERATION)
set_callback(manage_armored_ents, ON.FRAME)
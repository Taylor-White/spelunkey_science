shadow_ents = {}
dead_shadow_ents_aabb = {}

function spawn_as_shadow(id, x, y, l, xvel, yvel)
    --get the entity
    local shadow_ent = get_entity(spawn(id, x, y, l, xvel, yvel))
    table.insert(shadow_ents, shadow_ent.uid)
    shadow_ent.color.r = 0
    shadow_ent.color.g = 0
    shadow_ent.color.b = 0
    shadow_ent.color.a = 0.98
    shadow_ent.health = shadow_ent.type.life*2
    shadow_ent.flags = clr_flag(shadow_ent.flags, 12)
    return shadow_ent.uid 
end
function clear_shadow_ents()
    shadow_ents = {}
    dead_shadow_ents_aabb = {}
end
function manage_shadow_ents()
    for _, v in ipairs(shadow_ents) do
        local shadow_ent = get_entity(v)
        local x, y, l = get_position(v)
        if shadow_ent ~= nil then
            --curse pieces effect
            if math.random(15) == 1 then
                local fx = get_entity(spawn(ENT_TYPE.FX_VAT_BUBBLE, x, y, l, 0, 0))
                fx:set_texture(texturevars.blackcursepieces)
            end
            --remove blood
            for n, m in ipairs(get_entities_by_type(ENT_TYPE.ITEM_BLOOD)) do
                local blood = get_entity(m)
                if blood:overlaps_with(shadow_ent) then
                    blood.x = -900
                end
            end
            if shadow_ent.health == 0 then
                local curse1 = get_entity(spawn(ENT_TYPE.ITEM_CURSING_CLOUD, x, y, l, -0.1, 0))
                curse1.color.r = 0
                curse1.color.g = 0
                curse1.color.b = 0
                curse1.color.a = 0.98
                curse1.flags = set_flag(curse1.flags, 25)
                curse1.flags = set_flag(curse1.flags, 5)
                local curse2 = get_entity(spawn(ENT_TYPE.ITEM_CURSING_CLOUD, x, y, l, 0.1, 0))
                curse2.color.r = 0
                curse2.color.g = 0
                curse2.color.b = 0
                curse2.color.a = 0.98
                curse2.flags = set_flag(curse1.flags, 25)
                curse1.flags = set_flag(curse1.flags, 5)
                for i=1, 4, 1 do
                    local blood = get_entity(spawn(ENT_TYPE.ITEM_BLOOD, x, y, l, math.random(-2, 2)/25, math.random(1, 5)/20))
                    blood.color.r = 0
                    blood.color.g = 0
                    blood.color.b = 0
                    blood.color.a = 0.98
                end
                table.insert(dead_shadow_ents_aabb, get_hitbox(v))
                set_global_timeout(function()
                    table.remove(dead_shadow_ents_aabb, #dead_shadow_ents_aabb)
                end, 2)
                --chance to drop diamond
                if math.random(PO1T_DROPCHANCE.SHADOW) == 1 then
                    spawn(ENT_TYPE.ITEM_DIAMOND, x, y, l, 0, 0)
                end
                move_entity(v, -900, 0, 0, 0)
            end
        end
        --get rid of blood that is dropped from shadow ents dying
        for i, v in ipairs(dead_shadow_ents_aabb) do
            for l, k in ipairs(get_entities_by_type(ENT_TYPE.ITEM_BLOOD)) do
                local blood = get_entity(k)
                if blood:overlaps_with(v) then
                    blood.x = -900
                end
            end
        end
    end
end

set_callback(clear_shadow_ents, ON.PRE_LEVEL_GENERATION)
set_callback(manage_shadow_ents, ON.FRAME)
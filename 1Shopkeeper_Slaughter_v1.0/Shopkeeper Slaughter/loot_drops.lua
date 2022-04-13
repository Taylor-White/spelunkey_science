function generate_loot_drop()
    local chance = math.random(100)
    if chance <= 70 then
        if chance > 45 then
            return ENT_TYPE.ITEM_PICKUP_COOKEDTURKEY
        elseif chance > 40 and chance < 45 then
            return ENT_TYPE.ITEM_PICKUP_BOMBBAG
        elseif chance > 35 and chance < 40 then
            return ENT_TYPE.ITEM_PICKUP_ROPEPILE
        elseif chance > 32 and chance < 35 then
            return ENT_TYPE.ITEM_PICKUP_PASTE
        elseif chance > 29 and chance < 32 then
            return ENT_TYPE.ITEM_PICKUP_SPRINGSHOES
        elseif chance > 26 and chance < 29 then
            return ENT_TYPE.ITEM_PICKUP_CLIMBINGGLOVES
        elseif chance > 23 and chance < 26 then
            return ENT_TYPE.ITEM_PICKUP_SPIKESHOES
        elseif chance > 20 and chance < 23 then
            return ENT_TYPE.ITEM_PICKUP_SPECTACLES
        elseif chance > 17 and chance < 20 then
            return ENT_TYPE.ITEM_PICKUP_PITCHERSMITT
        elseif chance > 14 and chance < 17 then
            return ENT_TYPE.ITEM_PICKUP_ROYALJELLY
        elseif chance == 13 then
            return ENT_TYPE.ITEM_JETPACK
        elseif chance == 12 then
            return ENT_TYPE.ITEM_POWERPACK
        elseif chance == 11 then
            return ENT_TYPE.ITEM_TELEPORTER_BACKPACK
        elseif chance == 10 then
            return ENT_TYPE.ITEM_HOVERPACK
        elseif chance == 9 then
            return ENT_TYPE.ITEM_TELEPORTER
        elseif chance == 8 then
            return ENT_TYPE.ITEM_PICKUP_KAPALA
        elseif chance == 7 then
            return ENT_TYPE.ITEM_CAPE
        elseif chance == 6 then
            return ENT_TYPE.ITEM_VLADS_CAPE
        end
        return ENT_TYPE.FX_SPARK
    end
    return ENT_TYPE.FX_SPARK --dummy entity to spawn if no item is spawned
end

--make items that explode when getting shot not do that
local bombbag_db = get_type(ENT_TYPE.ITEM_PICKUP_BOMBBAG)
bombbag_db.default_flags = set_flag(bombbag_db.default_flags, ENT_FLAG.TAKE_NO_DAMAGE)
local bombbox_db = get_type(ENT_TYPE.ITEM_PICKUP_BOMBBOX)
bombbag_db.default_flags = set_flag(bombbag_db.default_flags, ENT_FLAG.TAKE_NO_DAMAGE)
local jetpack_db = get_type(ENT_TYPE.ITEM_JETPACK)
jetpack_db.default_flags = set_flag(jetpack_db.default_flags, ENT_FLAG.TAKE_NO_DAMAGE)
local hoverpack_db = get_type(ENT_TYPE.ITEM_HOVERPACK)
hoverpack_db.default_flags = set_flag(hoverpack_db.default_flags, ENT_FLAG.TAKE_NO_DAMAGE)
local powerpack_db = get_type(ENT_TYPE.ITEM_POWERPACK)
powerpack_db.default_flags = set_flag(powerpack_db.default_flags, ENT_FLAG.TAKE_NO_DAMAGE)
local teleporter_backpack_db = get_type(ENT_TYPE.ITEM_TELEPORTER_BACKPACK)
teleporter_backpack_db.default_flags = set_flag(teleporter_backpack_db.default_flags, ENT_FLAG.TAKE_NO_DAMAGE)
set_callback(function()
    --system for making items despawn after a certain amount of time
    for _, v in ipairs(get_entities_by(0, MASK.ITEM, LAYER.FRONT)) do
        local ent = get_entity(v)
        local x, y, l = get_position(v)
        --using idle counter to track how long an item has been marked for deletion
        if test_flag(ent.more_flags, 28) then --unused flag, items with this flag will be deleted when their idle counter is high enough. most non-enemy entities dont use idle_counter so its just a free variable to use
            if ent.idle_counter > 240 then
                if math.fmod(ent.idle_counter, 2) == 0 then
                    ent.flags = set_flag(ent.flags, ENT_FLAG.INVISIBLE)
                else
                    ent.flags = clr_flag(ent.flags, ENT_FLAG.INVISIBLE)
                end
            end
            if ent.idle_counter > 300 then
                ent:remove()
            end
            --if the item has an overlay, unmark it
            if ent.overlay ~= nil then
                ent.flags = clr_flag(ent.flags, ENT_FLAG.INVISIBLE)
                ent.more_flags = clr_flag(ent.more_flags, 28)
            end
        end
    end
end, ON.GAMEFRAME)
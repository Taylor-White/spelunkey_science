is_caveman = false
is_shadow = false
is_special_level = false

function clear_level_types()
    is_caveman = false
    is_shadow = false
    is_special_level = false
end
function determine_level_type()
    clear_level_types()
    if state.theme == THEME.DWELLING and determine_given_floor_type(game_controller.floor) == "DEFAULT" and math.random(PO1T_LEVELCHANCE.CAVEMAN) == 1 then
        is_caveman = true
        table.insert(music_change_levels, game_controller.floor)
    end
    if state.theme ~= THEME.BASE_CAMP and determine_given_floor_type(game_controller.floor) == "DEFAULT" and math.random(PO1T_LEVELCHANCE.SHADOW) == 1 and is_caveman == false then
        is_shadow = true
        table.insert(music_change_levels, game_controller.floor)
    end
end
function set_level_toasts()
    if is_caveman then
        toast_override("You hear nonsensical babbling...")
    end
    if is_shadow then
        toast_override("This floor feels otherwordly...")
    end
end

set_callback(determine_level_type, ON.PRE_LOAD_LEVEL_FILES)
set_callback(function(c_lvl)
    if is_caveman then
        c_lvl:override_level_files {'cavemanarea.lvl', 'generic.lvl'}
        is_special_level = true
    end
end, ON.PRE_LOAD_LEVEL_FILES)
non_shadow_entities = {ENT_TYPE.ITEM_WHIP, ENT_TYPE.ITEM_BOMB, ENT_TYPE.ITEM_ROPE, ENT_TYPE.ITEM_CLIMBABLE_ROPE, ENT_TYPE.ITEM_FREEZRAY, ENT_TYPE.ITEM_SHOTGUN, ENT_TYPE.ITEM_MACHETE, ENT_TYPE.ITEM_BOOMERANG, ENT_TYPE.ITEM_MATTOCK, ENT_TYPE.ITEM_JETPACK, ENT_TYPE.ITEM_HOVERPACK, ENT_TYPE.ITEM_POWERPACK, ENT_TYPE.ITEM_TELEPORTER_BACKPACK, ENT_TYPE.ITEM_CROSSBOW, ENT_TYPE.ITEM_HOUYIBOW, ENT_TYPE.FX_TELEPORTSHADOW, ENT_TYPE.ITEM_SPARK, ENT_TYPE.MONS_HUNDUNS_SERVANT, ENT_TYPE.MONS_YANG}
function shadow_manage_dynamic_entities()
    if is_shadow and is_special_level then
        for _, v in ipairs(get_entities_by(0, MASK.MONSTER | MASK.ITEM, LAYER.BOTH)) do
            local ent = get_entity(v)
            local is_shadow_entity = true
            for _, v in ipairs(non_shadow_entities) do
                if ent.type.id == v then
                    is_shadow_entity = false
                end
            end
            if is_shadow_entity then
                ent.color.r = 0
                ent.color.g = 0
                ent.color.b = 0
                ent.color.a = 0.9
            end
        end
    end
end
set_callback(function()
    if is_shadow then
        is_special_level = true
        for _, v in ipairs(get_entities_by(0, MASK.FLOOR | MASK.DECORATION | MASK.ACTIVEFLOOR | MASK.BG | MASK.FX, LAYER.BOTH)) do
            local ent = get_entity(v)
            ent.color.r = 0
            ent.color.g = 0
            ent.color.b = 0
            ent.color.a = 0.9
            if ent.type.id == ENT_TYPE.FLOOR_ARROW_TRAP or ent.type.id == ENT_TYPE.FLOOR_TOTEM_TRAP or ent.type.id == ENT_TYPE.ACTIVEFLOOR_CRUSH_TRAP or ent.type.id == ENT_TYPE.ACTIVEFLOOR_CRUSH_TRAP_LARGE then
                ent.color.r = 0.5
                ent.color.g = 0.5
                ent.color.b = 0.5
                ent.color.a = 0.96
                ent:set_texture(texturevars.floormisc_grayscaled)
            end
        end
        for _, v in ipairs(get_entities_by_type(ENT_TYPE.BG_LEVEL_BACKWALL)) do
            local ent = get_entity(v)
            ent:set_texture(texturevars.bg_white_cave)
        end
    end
end, ON.POST_LEVEL_GENERATION)
set_callback(shadow_manage_dynamic_entities, ON.FRAME)
set_callback(set_level_toasts, ON.LEVEL)
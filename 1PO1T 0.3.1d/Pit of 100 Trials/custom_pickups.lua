function spawn_playerbag_as_custom_pickup(x, y, l, xvel, yvel, effect)
    local bag = spawn(ENT_TYPE.ITEM_PICKUP_PLAYERBAG, x, y, l, xvel, yvel)
    local ent = get_entity(bag)
    ent.bombs = 0
    ent.ropes = 0
    table.insert(game_controller.special_playerbags, bag)
    table.insert(game_controller.special_playerbag_effects, effect)
    --set the texture of the custom pickup
    if effect == "MIDASTOUCH" then 
        ent:set_texture(texturevars.midastouch_texture)
    elseif effect == "AMMO" then
        ent:set_texture(texturevars.ammo_texture)
    elseif effect == "CRATEPERK" then
        ent:set_texture(texturevars.crateperk_texture)
    elseif effect == "PAYOFFPAIN" then
        ent:set_texture(texturevars.payoffpain_texture)
    elseif effect == "FIREWHIP" then
        ent:set_texture(texturevars.firewhip_texture)
    elseif effect == "RETURNPOSTAGE" then
        ent:set_texture(texturevars.returnpostage_texture)
    elseif effect == "YANGCHALLENGE" then
        ent:set_texture(texturevars.yangchallenge_texture)
    elseif effect == "GROUNDPOUND" then
        ent:set_texture(texturevars.groundpound_texture)
    elseif effect == "HPUP" then
        ent:set_texture(texturevars.hpup_texture)
    elseif effect == "BPEXPANDER" then
        ent:set_texture(texturevars.bpexpander_texture)
    elseif effect == "TONIC" then
        ent:set_texture(texturevars.tonic_texture)
    elseif effect == "TEA" then
        ent:set_texture(texturevars.tea_texture)
    elseif effect == "MEAL" then
        ent:set_texture(texturevars.meal_texture)
    elseif effect == "REPELGEL" then
        ent:set_texture(texturevars.repelgel_texture)
    end
end

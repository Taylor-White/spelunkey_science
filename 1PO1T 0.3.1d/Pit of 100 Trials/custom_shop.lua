--This has the table for all the custom shop stuff. This includes items, descriptions, and prices.
local custom_shop = {
    items = {}; --UIDs of "items" in the current shop
    items_by_type = {}; --A 1:1 of items[], that gives types to the entity being used as a shopping tool
    items_by_price = {};
    items_by_name = {};
    items_by_description = {};
    item_types = {"SPIKESHOES", "MIDASTOUCH", "AMMO", "TURKEY", "BOMBBAG", "MACHETE", "KAPALA", "JETPACK", "EXCALIBUR", "ROPEPILE", "CRATEPERK", "RETURNPOSTAGE", "SHOTGUN", "BROKENKAPALA", "PAYOFFPAIN", "YANGCHALLENGE", "BUTCHERKNIFE", "STUNSHIELD", "SPARKSHIELD", "FIREWHIP", "BUTTERFLYKNIFE", "GROUNDPOUND", "HPUP", "BPEXPANDER", "TONIC", "TEA", "MEAL", "REPELGEL", "CURSEGUN", "ROPERECLAIMER"}; --all possible items
    item_prices = {15000, 10000, 1500, 3000, 1000, 8000, 50000, 20000, 50000, 1000, 20000, 5000, 8000, 20000, 25000, 0, 12000, 6000, 8000, 15000, 20000, 20000, 15000, 7500, 5000, 10000, 6000, 45000, 0, 5000};
    item_names = {"Spike Shoes", "Perk: Midas Touch", "Ammo", "Turkey", "Bomb Bag", "Machete", "Kapala", "Jetpack", "Excalibur", "Rope Pile", "Perk: Be Crateful", "Perk: Return Postage", "Shotgun", "Broken Kapala", "Perk: Pay-Off Pain", "Yang's Challenge", "Butcher's Knife", "Perk: Stun Shield", "Perk: Spark Shield", "Perk: Firewhip", "Butterfly Knife", "Perk: Quillback Stomp", "HP Plus", "Backpack Expander", "Tasty Tonic", "Herbal Tea", "Hearty Meal", "Repel Gel", "Cursegun", "Perk: Rope Reclaimer"};
    item_descriptions = {"This lastest fashion statement will let you stomp on your foes with ease!", "Enemies will have a 25% chance to drop gold coins on death.", "A box of 12 shotgun shells. You need these to use a shotgun!", "Juicy cave turkey!", "Big bowling balls of gunpowder!", "It looks a little beat up, but it's definitely better than a whip!", "Turns out you don't have to be a vampire to drink blood!", "The future is now! Although the future doesn't seem fireproof..", "This belongs in a museum! But while it's on the moon, why not use it?", "Good for when level generation doesn't give you a path back up.", "A crate will spawn next to you at the start of every other level", "Kills most direct attackers when they hurt you.", "A very powerful weapon, but you need ammo for it!", "The blood keeps leaking out, but if you're quick you can fill the cup!", "You will take double damage, but in return all valuables will transform into rubies.", "Yang will hunt you down on every level after 10 seconds, but drop extra loot upon death!", "This expertly crafted knife grants a 10% chance to drop turkey when you kill most enemies.", "Greatly reduces the time you spend stunned. You get up faster.", "Whenever you take damage, a defensive spark-trap will activate around you for 10 seconds.", "The power of fire at your fingertips!", "Attacking enemies from behind with this deadly sharp knife will instantly kill them.", "Hold down and press jump to do a ground pound! Crushes blocks and items!", "Increases your max HP by 3.", "Gives you 1 extra backpack slot.", "This tasty tonic will cure your poison!", "An herbal tea that smells amazing. Cures poison and curse.", "This meal just might be tasty enough to fix your broken soul. Heals +3 HP.", "A sticky paste that will make you invincible for the rest of the level.", "A crude tool put together by Beg using the ecotplasm from a Curse Pot.", "Press the door button at the top of a rope to reclaim it! Makes sense if you think about it."};
    --Yangs challenge is excluded from here, since it needs to spawn separately as item no. 21
    item_common = {"AMMO", "TURKEY", "ROPEPILE", "BOMBBAG", "HPUP", "ROPERECLAIMER"};
    item_rare = {"SPIKESHOES", "RETURNPOSTAGE", "CRATEPERK", "PAYOFFPAIN", "SHOTGUN", "MEAL", "TONIC", "BPEXPANDER", "TEA", "STUNSHIELD", "AMMO", "TURKEY", "ROPEPILE", "BOMBBAG", "BUTCHERKNIFE", "SPARKSHIELD", "STUNSHIELD", "BROKENKAPALA", "STUNSHIELD", "MIDASTOUCH", "MACHETE", "FIREWHIP", "BUTTERFLYKNIFE", "ROPERECLAIMER"};
    item_veryrare = {"KAPALA", "JETPACK", "EXCALIBUR", "REPELGEL"};

    --[[
        ITEM TYPE LEGEND:
        1: SPIKESHOES: 15000$
        2: MIDASTOUCH: 10000$:
        3: AMMO: 1500$:
        4: TURKEY: 2500$
        5: BOMBBAG: 1000$
        6: MACHETE: 8000$
        7: KAPALA: 50000$
        8: JETPACK: 20000$
        9: EXCALIBUR: 50000$
        10: ROPEPILE: 1000$
        11: CRATEPERK: 20000$
        12: RETURNPOSTAGE: 5000$
        13: SHOTGUN: 8000$
        14: BROKENKAPALA: 20000$
        15: PAYOFFPAIN: 25000$
        16: YANGCHALLENGE: 0$
        17: BUTCHERKNIFE: 12000$
        18: STUNSHIELD: 6000$
        19: SPARKSHIELD: 8000$
        20: FIREWHIP: 15000$
        21: BUTTERFLYKNIFE: 20000$
        22: GROUNDPOUND: 20000$ -- shouldnt be available in the shops
        23: HPUP: 15000$
        24: BPEXPANDER: 7500$
        25: TONIC: 5000$
        26: TEA: 10000$
        27: MEAL: 6000$
        28: REPELGEL: 45000$
        29: CURSEGUN: 8000$
        30: ROPERECLAIMER: 5000$
    ]]
}
function custom_shop.spawn_item(item_name)
    local px, py, pl = get_position(players[1].uid)
    --give the effects of the item spawned
    if item_name == "SPIKESHOES" then
        return spawn(526, px, py, 0, 0 ,0)
    end
    if item_name == "MIDASTOUCH" then
        perk_controller.is_equipped[#game_controller.equipped_perks+1] = false
        game_controller.equipped_perks[#game_controller.equipped_perks+1] = "MIDASTOUCH"
    end
    if item_name == "AMMO" then
        game_controller.ammo = game_controller.ammo + 12
    end
    if item_name == "TURKEY" then
        return spawn(516, px, py, 0, 0 ,0)
    end
    if item_name == "BOMBBAG" then
        return spawn(513, px, py, 0, 0 ,0)
    end
    if item_name == "MACHETE" then
        return spawn(582, px, py, 0, 0 ,0)
    end
    if item_name == "KAPALA" then
        --if the player buys a regular kapala then we should disable the broken kapala
        game_controller.has_brokenkapala = false
        return spawn(532, px, py, 0, 0 ,0)
    end
    if item_name == "JETPACK" then
        return spawn(565, px, py, 0, 0 ,0)
    end
    if item_name == "EXCALIBUR" then
        return spawn(583, px, py, 0, 0 ,0)
    end
    if item_name == "ROPEPILE" then
        return spawn(ENT_TYPE.ITEM_PICKUP_ROPEPILE, px, py, 0, 0 ,0)
    end
    if item_name == "CRATEPERK" then
        perk_controller.is_equipped[#game_controller.equipped_perks+1] = false
        game_controller.equipped_perks[#game_controller.equipped_perks+1] = "CRATEPERK"
    end
    if item_name == "RETURNPOSTAGE" then
        perk_controller.is_equipped[#game_controller.equipped_perks+1] = false
        game_controller.equipped_perks[#game_controller.equipped_perks+1] = "RETURNPOSTAGE"
    end
    if item_name == "SHOTGUN" then
        return spawn(ENT_TYPE.ITEM_SHOTGUN, px, py, 0, 0 ,0)
    end
    if item_name == "BROKENKAPALA" then
        --check if we have the kapala powerup before giving this item + effect out
        if entity_has_item_type(players[1].uid, ENT_TYPE.ITEM_POWERUP_KAPALA) == false then
            spawn(532, px, py, 0, 0 ,0)
        end
    end
    if item_name == "PAYOFFPAIN" then
        perk_controller.is_equipped[#game_controller.equipped_perks+1] = false
        game_controller.equipped_perks[#game_controller.equipped_perks+1] = "PAYOFFPAIN"
    end
    if item_name == "YANGCHALLENGE" then
        if game_controller.yangchallenge_active == false then
            game_controller.yangchallenge_active = true
        end
    end
    if item_name == "BUTCHERKNIFE" then
        local machete = spawn(ENT_TYPE.ITEM_MACHETE, px, py, 0, 0, 0)
        replace_machete_butcherknife(machete)
        return machete
    end
    if item_name == "BUTTERFLYKNIFE" then
        local machete = spawn(ENT_TYPE.ITEM_MACHETE, px, py, 0, 0, 0)
        replace_machete_butterflyknife(machete)
        return machete
    end
    if item_name == "CURSEGUN" then
        local freezeray = spawn(ENT_TYPE.ITEM_FREEZERAY, px, py, 0, 0, 0)
        replace_freezeray_cursegun(freezeray)
        return freezeray
    end
    if item_name == "MAGGOTGUN" then
        local freezeray = spawn(ENT_TYPE.ITEM_FREEZERAY, px, py, 0, 0, 0)
        replace_freezeray_maggotgun(freezeray)
        return freezeray
    end
    if item_name == "STUNSHIELD" then
        perk_controller.is_equipped[#game_controller.equipped_perks+1] = false
        game_controller.equipped_perks[#game_controller.equipped_perks+1] = "STUNSHIELD"
    end
    if item_name == "SPARKSHIELD" then
        perk_controller.is_equipped[#game_controller.equipped_perks+1] = false
        game_controller.equipped_perks[#game_controller.equipped_perks+1] = "SPARKSHIELD"
    end
    if item_name == "FIREWHIP" then
        perk_controller.is_equipped[#game_controller.equipped_perks+1] = false
        game_controller.equipped_perks[#game_controller.equipped_perks+1] = "FIREWHIP"
    end
    if item_name == "GROUNDPOUND" then
        perk_controller.is_equipped[#game_controller.equipped_perks+1] = false
        game_controller.equipped_perks[#game_controller.equipped_perks+1] = "GROUNDPOUND"
    end
    if item_name == "HPUP" then
        game_controller.max_health = game_controller.max_health + 3
        toast_override("Max HP increased by 3!")
    end
    if item_name == "BPEXPANDER" then
        backpack_controller.max_slots = backpack_controller.max_slots + 1
        toast_override("Maximum backpack slots increased by 1!")
    end
    if item_name == "TONIC" then
        if backpack_controller.items[backpack_controller.max_slots] == nil then
            table.insert(backpack_controller.items, item_name)
        else
            backpack_controller.perform_consumable_effect(item_name)
        end
    end
    if item_name == "TEA" then
        if backpack_controller.items[backpack_controller.max_slots] == nil then
            table.insert(backpack_controller.items, item_name)
        else
            backpack_controller.perform_consumable_effect(item_name)
        end
    end
    if item_name == "MEAL" then
        if backpack_controller.items[backpack_controller.max_slots] == nil then
            table.insert(backpack_controller.items, item_name)
        else
            backpack_controller.perform_consumable_effect(item_name)
        end
    end
    if item_name == "REPELGEL" then
        if backpack_controller.items[backpack_controller.max_slots] == nil then
            table.insert(backpack_controller.items, item_name)
        else
            backpack_controller.perform_consumable_effect(item_name)
        end
    end
    if item_name == "ROPERECLAIMER" then
        perk_controller.is_equipped[#game_controller.equipped_perks+1] = false
        game_controller.equipped_perks[#game_controller.equipped_perks+1] = "ROPERECLAIMER"
    end
    --THESE ARE ITEMS THAT CAN BE PLACED IN THE BACKPACK (so they dont spawn in the shop)
    if item_name == "ROCK" then
        return spawn(ENT_TYPE.ITEM_ROCK, px, py, 0, 0, 0)
    end    
    if item_name == "ARROW" then
        return spawn(ENT_TYPE.ITEM_WOODEN_ARROW, px, py, 0, 0, 0)
    end
    if item_name == "ARROW_BUTT" then
        return spawn(ENT_TYPE.ITEM_BROKEN_ARROW, px, py, 0, 0, 0)
    end
    if item_name == "SKULL" then
        return spawn(ENT_TYPE.ITEM_SKULL, px, py, 0, 0, 0)
    end
    if item_name == "SKULL" then
        return spawn(ENT_TYPE.ITEM_SKULL, px, py, 0, 0, 0)
    end    
    if item_name == "SCEPTER" then
        return spawn(ENT_TYPE.ITEM_SCEPTER, px, py, 0, 0, 0)
    end  
    if item_name == "IDOL" then
        return spawn(ENT_TYPE.ITEM_IDOL, px, py, 0, 0, 0)
    end 
    if item_name == "WEBGUN" then
        return spawn(ENT_TYPE.ITEM_WEBGUN, px, py, 0, 0, 0)
    end
    if item_name == "FREEZERAY" then
        return spawn(ENT_TYPE.ITEM_FREEZERAY, px, py, 0, 0, 0)
    end
    if item_name == "PLASMACANNON" then
        return spawn(ENT_TYPE.ITEM_PLASMACANNON, px, py, 0, 0, 0)
    end
    if item_name == "TELEPORTER" then
        return spawn(ENT_TYPE.ITEM_TELEPORTER, px, py, 0, 0, 0)
    end
    if item_name == "BOOMERANG" then
        return spawn(ENT_TYPE.ITEM_BOOMERANG, px, py, 0, 0, 0)
    end
    if item_name == "CROSSBOW" then
        return spawn(ENT_TYPE.ITEM_CROSSBOW, px, py, 0, 0, 0)
    end
    if item_name == "METALARROW" then
        return spawn(ENT_TYPE.ITEM_METAL_ARROW, px, py, 0, 0, 0)
    end
    if item_name == "TELEPACK" then
        return spawn(ENT_TYPE.ITEM_TELEPORTER_BACKPACK, px, py, 0, 0, 0)
    end
    if item_name == "CAPE" then
        return spawn(ENT_TYPE.ITEM_CAPE, px, py, 0, 0, 0)
    end
    if item_name == "VLADSCAPE" then
        return spawn(ENT_TYPE.ITEM_CAPE, px, py, 0, 0, 0)
    end
    if item_name == "MATTOCK" then
        return spawn(ENT_TYPE.ITEM_MATTOCK, px, py, 0, 0, 0)
    end
    if item_name == "HOVERPACK" then
        return spawn(ENT_TYPE.ITEM_HOVERPACK, px, py, 0, 0, 0)
    end
    if item_name == "TORCH" then
        return spawn(ENT_TYPE.ITEM_TORCH, px, py, 0, 0, 0)
    end
    if item_name == "COBOW" then
        return spawn(ENT_TYPE.ITEM_HOUYIBOW, px, py, 0, 0, 0)
    end
    if item_name == "LIGHTARROW" then
        return spawn(ENT_TYPE.ITEM_LIGHT_ARROW, px, py, 0, 0, 0)
    end
    if item_name == "TUSKIDOL" then
        return spawn(ENT_TYPE.ITEM_MADAMETUSK_IDOL, px, py, 0, 0, 0)
    end
    if item_name == "MINE" then
        return spawn(ENT_TYPE.ITEM_LANDMINE, px, py, 0, 0, 0)
    end
    if item_name == "POWERPACK" then
        return spawn(ENT_TYPE.ITEM_POWERPACK, px, py, 0, 0, 0)
    end
    if item_name == "LAVAPOT" then
        return spawn(ENT_TYPE.ITEM_LAVAPOT, px, py, 0, 0, 0)
    end
    if item_name == "SNAPTRAP" then
        return spawn(ENT_TYPE.ITEM_SNAP_TRAP, px, py, 0, 0, 0)
    end
    if item_name == "KEY" then
        return spawn(ENT_TYPE.ITEM_KEY, px, py, 0, 0, 0)
    end
    if item_name == "WOODSHIELD" then
        return spawn(ENT_TYPE.ITEM_WOODEN_SHIELD, px, py, 0, 0, 0)
    end
    if item_name == "METALSHIELD" then
        return spawn(ENT_TYPE.ITEM_METAL_SHIELD, px, py, 0, 0, 0)
    end
    if item_name == "CAVEMAN" then
        return spawn(ENT_TYPE.MONS_CAVEMAN, px, py, 0, 0, 0)
    end
end

return custom_shop
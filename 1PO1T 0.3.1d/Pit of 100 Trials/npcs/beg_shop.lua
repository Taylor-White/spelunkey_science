beg_shopkeeper_uid = -1
beg_shopkeeper_last_known_x = 0
beg_shopkeeper_last_known_y = 0
beg_shopkeeper_spoke = false
beg_item_uids = {}
beg_shop_floors = {}
beg_shop_spawned = false
player_is_in_beg_shop = false
beg_items = {}
beg_items_by_type = {}
beg_items_by_price = {}
beg_items_by_name = {}
beg_items_by_description = {}
beg_item_types = {"GROUNDPOUND", "REPELGEL", "CURSEGUN", "BUTTERFLYKNIFE"}
beg_item_names = {"Perk: Quillback Stomp", "Repel Gel", "Curse Gun", "Butterfly Knife"}
beg_item_descriptions = {"Hold down and press jump to do a ground pound! Crushes blocks and items!", "A sticky paste that will make you invincible for the rest of the level.", "A crude tool put together by Beg using the ecotplasm from a Curse Pot.", "Attacking enemies from behind with this deadly sharp knife will instantly kill them."}

function create_beg_shop()
    local existing_items = {}
    if beg_shopkeeper_uid ~= nil then
        for i=1, 3, 1 do
            local bx, by, bl = get_position(beg_shopkeeper_uid)
            local roll = math.random(#beg_item_types)
            local already_existing_item = false
            for _, v in ipairs(existing_items) do
                if v == roll then already_existing_item = true end
            end
            while already_existing_item == true do
                already_existing_item = false
                roll = math.random(#beg_item_types)
                for _, v in ipairs(existing_items) do
                    if v == roll then already_existing_item = true end
                end
            end
            beg_items[i] = beg_item_types[roll]
            beg_items_by_type[i] = roll
            beg_items_by_price[i] = math.random(2, 5)
            beg_item_uids[i] = spawn(ENT_TYPE.ITEM_PICKUP_PLAYERBAG, bx-2-((i-1)*2), by-1.05, bl, 0, 0)
            beg_shop_floors[i] = spawn_grid_entity(ENT_TYPE.FLOORSTYLED_MINEWOOD, bx-2-((i-1)*2), by-2, bl)
            table.insert(existing_items, roll)
            local bag = get_entity(beg_item_uids[i])
            bag.flags = set_flag(bag.flags, 28)
            get_beg_shop_details()
        end
    end
end
function get_beg_shop_details()
    for i=1, 3, 1 do
        local bag = get_entity(beg_item_uids[i])
        if beg_items[i] == "GROUNDPOUND" then
            beg_items_by_name[i] = beg_item_names[1]
            beg_items_by_description[i] = beg_item_descriptions[1]
            bag:set_texture(texturevars.groundpound_texture)
        end
        if beg_items[i] == "REPELGEL" then
            beg_items_by_name[i] = beg_item_names[2]
            beg_items_by_description[i] = beg_item_descriptions[2]
            bag:set_texture(texturevars.repelgel_texture)
        end
        if beg_items[i] == "CURSEGUN" then
            beg_items_by_name[i] = beg_item_names[3]
            beg_items_by_description[i] = beg_item_descriptions[3]
            bag:set_texture(texturevars.cursegun_texture)
        end
        if beg_items[i] == "BUTTERFLYKNIFE" then
            beg_items_by_name[i] = beg_item_names[4]
            beg_items_by_description[i] = beg_item_descriptions[4]
            bag:set_texture(texturevars.butterflyknife_texture)
        end
    end
end
function reset_beg_shop()
    beg_shopkeeper_uid = -1
    beg_shopkeeper_last_known_x = 0
    beg_shopkeeper_last_known_y = 0
    beg_shopkeeper_spoke = false
    beg_item_uids = {}
    beg_shop_floors = {}
    player_is_in_beg_shop = false
    beg_items = {}
    beg_items_by_type = {}
    beg_items_by_price = {}
    beg_items_by_name = {}
    beg_items_by_description = {}
end
function manage_beg_shop_owner()
    if get_entity(beg_shopkeeper_uid) ~= nil and players[1] ~= nil then
        local beg = get_entity(beg_shopkeeper_uid)
        beg_shopkeeper_last_known_x = beg.x
        beg_shopkeeper_last_known_y = beg.y
        local dist = distance(beg_shopkeeper_uid, players[1].uid)
        local px, py, pl = get_position(players[1].uid)
        if dist > 8.5 then
            player_is_in_beg_shop = false
            beg_shopkeeper_spoke = false
        else
            player_is_in_beg_shop = true
        end
        if player_is_in_beg_shop and not beg_shopkeeper_spoke and py < beg.y and py > beg.y-2 then
            beg_shopkeeper_spoke = true
            play_vanilla_sound(VANILLA_SOUND.SHOP_SHOP_ENTER)
            say(beg_shopkeeper_uid, "Welcome to Beg's Bargains, where you won't spend a penny! Of money, that is! Hehe.", 0, true)
        end
    end
    for i, v in ipairs(beg_shop_floors) do
        local ent = get_entity(v)
        local beg = get_entity(beg_shopkeeper_uid)
        if ent == nil and beg ~= nil then
            --to trigger begs teleport seamlessely,, we spawn a rock moving right at him.
            local rock = get_entity(spawn(ENT_TYPE.ITEM_ROCK, beg.x-0.1, beg.y, beg.layer, 2, 0))
            rock.flags = set_flag(rock.flags, 1)
            set_timeout(function()
                kill_entity(rock.uid)
            end, 2)
        end
        for _, k in ipairs(get_entities_by_type(ENT_TYPE.ITEM_PASTEBOMB, ENT_TYPE.ITEM_BOMB)) do
            local bomb = get_entity(k)
            if bomb.standing_on_uid == v and beg ~= nil then
                --to trigger begs teleport seamlessely,, we spawn a rock moving right at him.
                local rock = get_entity(spawn(ENT_TYPE.ITEM_ROCK, beg.x-0.1, beg.y, beg.layer, 2, 0))
                rock.flags = set_flag(rock.flags, 1)
                set_timeout(function()
                    kill_entity(rock.uid)
                end, 2)            
            end
        end
    end
    if get_entity(beg_shopkeeper_uid) == nil then
        --if the beg shopkeeper isnt there make his wares dissapear
        for i, v in ipairs(beg_item_uids) do
            local bx, by, bl = get_position(v)
            spawn(ENT_TYPE.FX_TELEPORTSHADOW, bx, by, bl, 0, 0)
            move_entity(v, -900, -900, 0, 0)
            table.remove(beg_item_uids, i)
        end
        if beg_item_uids[1] ~= nil then --this makes sure that theres actually a beg shop on the level
            local px, py, pl = get_position(players[1].uid)
            local beg_messenger = get_entity(spawn(ENT_TYPE.MONS_HUNDUNS_SERVANT, beg_shopkeeper_last_known_x, beg_shopkeeper_last_known_y, pl, 0, 0))
            beg_messenger.flags = set_flag(beg_messenger.flags, 1)
            beg_messenger.flags = set_flag(beg_messenger.flags, 4)
            beg_messenger.flags = set_flag(beg_messenger.flags, 5)
            beg_messenger.flags = set_flag(beg_messenger.flags, 6)
            beg_messenger.flags = set_flag(beg_messenger.flags, 28)
            beg_angry = true
            say_override(beg_messenger.uid, "You've just made a VERY regrettable decision!", 1, false)
            --determine floor that beg should attack on
            local beg_floor_wait = 2 --current_floor + wait is the floor he'll attack on.. skips boss / shop levels
            beg_attack_floor = state.level + beg_floor_wait
            while determine_given_floor_type(beg_attack_floor) ~= "DEFAULT" do
                beg_attack_floor = beg_attack_floor + 1
            end
        end
    end
end
function beg_shop_buy_items()
    if state.pause == 0 and state.ingame == 1 and state.screen == 12 and players[1] ~= nil then
        if get_entity(beg_shopkeeper_uid) ~= nil then
            for i=1, 3, 1 do
                local bag = get_entity(beg_item_uids[i])
                local scaling = game_controller.text_scaling
                local size = 50*scaling
                local text = tostring(beg_items_by_name[i]) .. ":\n" .. tostring(beg_items_by_description[i]) .. "\nPress your door button to buy for " .. tostring(beg_items_by_price[i]) .. " max HP"
                if bag:overlaps_with(players[1]) then
                    draw_image(assets.ui_textbox, -0.9, -0.9, 0.9, -0.5, 0, 0, 1, 1, white, 0, 0, 0)
                    draw_text(-0.85, -0.54, size, text, black)
                    if players[1]:is_button_pressed(BUTTON.DOOR) and players[1].standing_on_uid ~= -1 then
                        if game_controller.max_health > beg_items_by_price[i] then
                            play_vanilla_sound(VANILLA_SOUND.SHOP_SHOP_BUY)
                            custom_shop.spawn_item(beg_items[i])
                            move_entity(beg_item_uids[i], -900, 0, 0, 0)
                            say_override(beg_shopkeeper_uid, "Ahh, an excellent choice!", 1, true)
                            game_controller.max_health = game_controller.max_health - beg_items_by_price[i]
                        else
                            play_vanilla_sound(VANILLA_SOUND.SHOP_SHOP_BUY)
                            custom_shop.spawn_item(beg_items[i])
                            move_entity(beg_item_uids[i], -900, 0, 0, 0)
                            say_override(beg_shopkeeper_uid, "Hmm.. I suppose you're in quite the debt now!", 1, true)
                            game_controller.max_health = 0
                            players[1].flags = set_flag(players[1].flags, 29)
                        end
                    end
                end
            end
        end
    end
end
set_callback(function() beg_shop_spawned = false end, ON.RESET)
set_callback(function() beg_shop_spawned = false end, ON.DEATH)
set_callback(beg_shop_buy_items, ON.GUIFRAME)
set_callback(reset_beg_shop, ON.PRE_LEVEL_GENERATION)
set_callback(manage_beg_shop_owner, ON.FRAME)
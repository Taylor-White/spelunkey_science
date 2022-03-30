module = {}

module.monsters = { ENT_TYPE.MONS_SNAKE, ENT_TYPE.MONS_SPIDER, ENT_TYPE.MONS_LEPRECHAUN, ENT_TYPE.MONS_HANGSPIDER, ENT_TYPE.MONS_SCORPION, ENT_TYPE.MONS_REDSKELETON, ENT_TYPE.MONS_SKELETON, ENT_TYPE.MONS_BAT, ENT_TYPE.MONS_TIKIMAN, ENT_TYPE.MONS_WITCHDOCTOR, ENT_TYPE.MONS_MANTRAP, ENT_TYPE.MONS_MOSQUITO, ENT_TYPE.MONS_FROG, ENT_TYPE.MONS_FIREFROG, ENT_TYPE.MONS_GRUB, ENT_TYPE.MONS_HORNEDLIZARD, ENT_TYPE.MONS_MOLE, ENT_TYPE.MONS_MONKEY, ENT_TYPE.MONS_MAGMAMAN, ENT_TYPE.MONS_ROBOT, ENT_TYPE.MONS_FIREBUG_UNCHAINED, ENT_TYPE.MONS_VAMPIRE, ENT_TYPE.MONS_IMP, ENT_TYPE.MONS_CROCMAN, ENT_TYPE.MONS_COBRA, ENT_TYPE.MONS_NECROMANCER, ENT_TYPE.MONS_SORCERESS, ENT_TYPE.MONS_JIANGSHI, ENT_TYPE.MONS_FEMALE_JIANGSHI, ENT_TYPE.MONS_FISH, ENT_TYPE.MONS_OCTOPUS, ENT_TYPE.MONS_HERMITCRAN, ENT_TYPE.MONS_UFO, ENT_TYPE.MONS_ALIEN, ENT_TYPE.MONS_YETI, ENT_TYPE.MONS_OLMITE_NAKED, ENT_TYPE.MONS_OLMITE_BODYARMORED, ENT_TYPE.MONS_OLMITE_HELMET, ENT_TYPE.MONS_BEE }
module.items = { ENT_TYPE.ITEM_PICKUP_COMPASS, ENT_TYPE.ITEM_PICKUP_SPECTACLES, ENT_TYPE.ITEM_PICKUP_CLIMBINGGLOVES, ENT_TYPE.ITEM_PICKUP_BOMBBAG, ENT_TYPE.ITEM_PICKUP_BOMBBOX, ENT_TYPE.ITEM_CAPE, ENT_TYPE.ITEM_PICKUP_SPIKESHOES, ENT_TYPE.ITEM_PICKUP_SPRINGSHOES, ENT_TYPE.ITEM_PICKUP_KAPALA, ENT_TYPE.ITEM_JETPACK, ENT_TYPE.ITEM_PICKUP_ALIENCOMPASS, ENT_TYPE.ITEM_PICKUP_ROPE, ENT_TYPE.ITEM_PICKUP_ROPEPILE, ENT_TYPE.ITEM_PICKUP_ROYALJELLY, ENT_TYPE.ITEM_PICKUP_COOKEDTURKEY, ENT_TYPE.ITEM_PICKUP_CLOVER, ENT_TYPE.ITEM_PICKUP_PITCHERSMITT, ENT_TYPE.ITEM_PICKUP_PASTE, ENT_TYPE.ITEM_PICKUP_UDJATEYE, ENT_TYPE.ITEM_PICKUP_PARACHUTE, ENT_TYPE.ITEM_PICKUP_SKELETONKEY, ENT_TYPE.ITEM_PICKUP_PLAYERBAG, ENT_TYPE.ITEM_JETPACK, ENT_TYPE.ITEM_TELEPORTER_BACKPACK, ENT_TYPE.ITEM_POWERPACK, ENT_TYPE.ITEM_HOVERPACK, ENT_TYPE.ITEM_PLASMACANNON }
module.event_funcs = {}

local function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

local function get_keys(tab)
    local keys = {}
    for k, v in pairs(tab) do
        table.insert(keys, k)
    end
    return keys
end

local function choose_different_event()
    local names = get_keys(module.event_funcs)
    local name = names[math.random(#names)]
    return module.event_funcs[name](players[1].uid)
end

--v 0.1

--- increases shoppie aggro by 5
module.event_funcs["Angry Shopkeepers"] = function(_)
    state.shoppie_aggro = 5
    return "The Hatred of Shopkeepers"
end

--- increases tun aggro by 3
module.event_funcs["Tun's Upset"] = function(_)
    state.merchant_aggro = 3
    return "Tun's Hatred"
end





--- stuns the player for 5 seconds
module.event_funcs["I'm a little sleepy.."] = function(uid)
    local p = get_entity(uid)
    p.velocityx = math.random() / 10
    p.velocityy = 0.05
    p:stun(300)
    return "I'm a little sleepy.."
end

--- spawns a boulder above the player
module.event_funcs["Indiana Jones"] = function(uid)
    local x, y, l = get_position(uid)
    spawn(ENT_TYPE.LOGICAL_BOULDERSPAWNER, x, y, l, 0, 0)
    return "Indiana Jones"
end

--- all shops in the current level are 50% off
module.event_funcs["Discount"] = function(_)
    local shopkeepers = get_entities_by(ENT_TYPE.MONS_SHOPKEEPER, 0, LAYER.BOTH)
    local shoppie_in_level = false
    for _, v in ipairs(shopkeepers) do
        local mov = get_entity(v)
        if mov.is_patrolling == false then
            shoppie_in_level = true
        end
    end
    if not shoppie_in_level then
        return choose_different_event()
    end
    for i, v in ipairs(get_entities_by_mask(MASK.ITEM)) do
        local mov = get_entity(v)
        if testflag(mov.flags, 23) then mov.price = math.floor(mov.price / 2) end
    end
    return "Discount"
end

--- spawns apep on the far left side of the screen
module.event_funcs["Here He Comes!"] = function(uid)
    local x, y, l = get_position(uid)
    spawn(ENT_TYPE.MONS_APEP_HEAD, -10, y, l, 0, 0)
    return "Here He Comes!"
end

--- spawns a fireball on the player
module.event_funcs["Burn, Baby, Burn!"] = function(uid)
    local x, y, l = get_position(uid)
    spawn(ENT_TYPE.ITEM_HUNDUN_FIREBALL, x - 1, y, l, 0, 0)
    return "Burn, Baby, Burn!"
end

--- freezes the player
module.event_funcs["Brainfreeze"] = function(uid)
    spawn_entity_over(ENT_TYPE.ITEM_FREEZERAYSHOT, uid, 0, 0)
    return "Brainfreeze"
end

--- sets player's bombs and ropes to 0
module.event_funcs["No Resources"] = function(uid)
    local p = get_entity(uid)
    p.inventory.bombs = 0
    p.inventory.ropes = 0
    return "No Resources"
end

--- shops are 2x as expensive on this level
module.event_funcs["Expensive Shops"] = function(_)
    local shopkeepers = get_entities_by(ENT_TYPE.MONS_SHOPKEEPER, 0, LAYER.BOTH)
    local shoppie_in_level = false
    for _, v in ipairs(shopkeepers) do
        local mov = get_entity(v)
        if mov.is_patrolling == false then
            shoppie_in_level = true
        end
    end
    if not shoppie_in_level then
        return choose_different_event()
    end
    for i, v in ipairs(get_entities_by_mask(MASK.ITEM)) do
        local mov = get_entity(v)
        if testflag(mov.flags, 23) then mov.price = mov.price * 2 end
    end
    return "Expensive Shops"
end

--- spawns a clone shopkeeper
module.event_funcs["Shopkeeper Mayhem"] = function(_)
    local num = math.random(1, 3)
    for i = 1, num do
        local x, y = math.random(3, 10), math.random(1, 5)
        spawn(ENT_TYPE.MONS_SHOPKEEPERCLONE, x, y, LAYER.PLAYER1, 0, 0)
    end
    return "Shopkeeper Mayhem"
end

--- decreases bombs by 1-4
module.event_funcs["Bombs Down"] = function(uid)
    local p = get_entity(uid)
    local bombs = p.inventory.bombs - math.random(1, 4)
    if bombs < 0 then bombs = 0 end
    p.inventory.bombs = bombs
    return "Bombs Down"
end

--- decreases ropes by 1-4
module.event_funcs["Ropes Down"] = function(uid)
    local p = get_entity(uid)
    local ropes = p.inventory.ropes - math.random(1, 4)
    if ropes < 0 then ropes = 0 end
    p.inventory.ropes = ropes
    return "Ropes Down"
end

--- decreases health by 1-4 (but it won't kill you)
module.event_funcs["Health Down"] = function(uid)
    local p = get_entity(uid)
    local health = p.health - math.random(1, 4)
    if health < 1 then health = 1 end
    p.health = health
    return "Health Down"
end

--- increases bombs by 1-8
module.event_funcs["Bombs Up"] = function(uid)
    local p = get_entity(uid)
    local bombs = p.inventory.bombs + math.random(1, 8)
    if bombs > 99 then p.inventory.bombs = 99 return end
    p.inventory.bombs = bombs
    return "Bombs Up"
end

--- increases ropes by 1-8
module.event_funcs["Ropes Up"] = function(uid)
    local p = get_entity(uid)
    local ropes = p.inventory.ropes + math.random(1, 8)
    if ropes > 99 then ropes = 99 end
    p.inventory.ropes = ropes
    return "Ropes Up"
end

--- increases health by 1-8
module.event_funcs["Health Up"] = function(uid)
    local p = get_entity(uid)
    local health = p.health + math.random(1, 8)
    if health > 99 then health = 99 end
    p.health = health
    return "Health Up"
end

--- sets player's money to 0
module.event_funcs["Broke"] = function(uid)
    get_entity(uid).inventory.money = 0
    return "Broke"
end

--- all monsters are invisible for 15 seconds
module.event_funcs["Invisible Monsters"] = function(_)
    for i, v in ipairs(get_entities_by_mask(MASK.MONSTER)) do
        local mov = get_entity(v)
        mov.flags = setflag(mov.flags, 1)
    end
    set_timeout(function()
        for i, v in ipairs(get_entities_by_mask(MASK.MONSTER)) do
            local mov = get_entity(v)
            mov.flags = clrflag(mov.flags, 1)
        end
        clear_callback()
    end, 900)
    return "Invisible Monsters"
end

--- spawns the ghost
module.event_funcs["A Terrible Chill"] = function(uid)
    spawn(ENT_TYPE.ITEM_CURSEDPOT, 0, 1, 0, 0, 0)
    return "A Terrible Chill"
end

--- zooms in for 15 seconds
module.event_funcs["Low Render Distance"] = function(uid)
    zoom(8.5)
    local p = get_entity(uid)
    set_timeout(function()
        zoom(13.5)
        clear_callback()
    end, 900)
    return "Low Render Distance"
end

--v 0.2

--- poisons the player
module.event_funcs["Poison Player"] = function(uid)
    local x, y, l = get_position(uid)
    spawn_entity_over(ENT_TYPE.ITEM_ACIDSPIT, uid, 0, 0)
    return "Poison Player"
end

--- curses the player
module.event_funcs["Curse Player"] = function(uid)
    get_entity(uid):curse(true)
    return "Curse Player"
end

--- spawns 2-4 turkeys
module.event_funcs["Turkey Gang"] = function(uid)
    local x, y, l = get_position(uid)
    local amount = math.random(2, 4)
    local i = 0
    while i < amount do
        local offsetx, offsety = math.random(-4, 4), math.random(-4, 4)
        spawn(ENT_TYPE.MOUNT_TURKEY, x + offsetx, y + offsety, l, 0, 0)
        i = i + 1
    end
    return "Turkey Gang"
end

--- spawns 2-4 rockdogs
module.event_funcs["Rockdog Gang"] = function(uid)
    local x, y, l = get_position(uid)
    local amount = math.random(2, 4)
    local i = 0
    while i < amount do
        local offsetx, offsety = math.random(-4, 4), math.random(-4, 4)
        spawn(ENT_TYPE.MOUNT_ROCKDOG, x + offsetx, y + offsety, l, 0, 0)
        i = i + 1
    end
    return "Rockdog Gang"
end

--- spawns 2-4 axolotls
module.event_funcs["Axolotl Gang"] = function(uid)
    local x, y, l = get_position(uid)
    local amount = math.random(2, 4)
    local i = 0
    while i < amount do
        local offsetx, offsety = math.random(-4, 4), math.random(-4, 4)
        spawn(ENT_TYPE.MOUNT_AXOLOTL, x + offsetx, y + offsety, l, 0, 0)
        i = i + 1
    end
    return "Axolotl Gang"
end

--- untames all mounts in the current level
module.event_funcs["All Mounts Go Wild"] = function(_)
    local ents = get_entities_by_mask(MASK.MOUNT)
    for i, v in ipairs(ents) do
        get_entity(v):tame(true)
    end
    return "All Mounts Go Wild"
end

--- tames all mounts in the current level
module.event_funcs["Tame All Mounts"] = function(_)
    local ents = get_entities_by_mask(MASK.MOUNT)
    for i, v in ipairs(ents) do
        get_entity(v):tame(false)
    end
    return "Tame All Mounts"
end

--- spawns a (almost worthless) elixir
module.event_funcs["Freelixir"] = function(uid)
    local x, y, l = get_position(uid)
    spawn(ENT_TYPE.ITEM_PICKUP_ELIXIR, x, y, l, 0, 0)
    return "Freelixir"
end

--- spawns some leprechauns
module.event_funcs["Thieves"] = function(uid)
    local x, y, l = get_position(uid)
    local amount = math.random(2, 3)
    local i = 0
    while i < amount do
        local offsetx, offsety = math.random(-4, 4), math.random(-4, 4)
        spawn(ENT_TYPE.MONS_LEPRECHAUN, x + offsetx, y + offsety, l, 0, 0)
        i = i + 1
    end
    return "Thieves"
end

--- decreases shoppie aggro by 1-4
module.event_funcs["Shopkeepers Love You"] = function(_)
    if state.shoppie_aggro <= 0 then return end
    local amount = state.shoppie_aggro - math.random(1, 4)
    if amount < 0 then amount = 0 end
    state.shoppie_aggro = amount
    return "Shopkeepers Love You"
end

--- decreases tun aggro by 1-4
module.event_funcs["Tun Loves You"] = function(_)
    if state.merchant_aggro <= 0 then return end
    local amount = state.merchant_aggro - math.random(1, 4)
    if amount < 0 then amount = 0 end
    state.merchant_aggro = amount
    return "Tun Loves You"
end

--- resets all arrow traps
module.event_funcs["Rearm All Arrow Traps"] = function(_)
    for i, v in ipairs(get_entities_by_type(ENT_TYPE.FLOOR_POISONED_ARROW_TRAP, ENT_TYPE.FLOOR_ARROW_TRAP)) do
        get_entity(v):rearm()
    end
    return "Rearm All Arrow Traps"
end

--- teleports the player to the first exit
module.event_funcs["Teleport to Exit"] = function(uid)
    local exits = get_entities_by_type(ENT_TYPE.FLOOR_DOOR_EXIT)
    if #exits == 0 then error("no exits in the current level, what??") end
    local ex, ey, _ = get_position(exits[1])
    local x, y, _ = get_position(uid)
    x = math.floor(x)
    y = math.floor(y)
    ex = math.floor(ex)
    ey = math.floor(ey)
    local dx, dy = ex - x, ey - y

    get_entity(uid):perform_teleport(dx, dy)
    return "Teleport to Exit"
end

--- teleports the player to the first entrance of the level
module.event_funcs["Teleport to Entrance"] = function(uid)
    local entrances = get_entities_by_type(ENT_TYPE.FLOOR_DOOR_ENTRANCE)
    if #entrances == 0 then error("no entrances in the current level, what??") end
    local ex, ey, _ = get_position(entrances[1])
    local x, y, _ = get_position(uid)
    x = math.floor(x)
    y = math.floor(y)
    ex = math.floor(ex)
    ey = math.floor(ey)
    local dx, dy = ex - x, ey - y

    get_entity(uid):perform_teleport(dx, dy)
    return "Teleport to Entrance"
end

--- spawns a jetpack and a plasma cannon
module.event_funcs["Derek Loves You"] = function(uid)
    local p = get_entity(uid)
    local x, y, l = get_position(uid)
    spawn(ENT_TYPE.ITEM_PLASMACANNON, x + 1, y, l, 0, 0)
    spawn(ENT_TYPE.ITEM_JETPACK, x - 1, y, l, 0, 0)
    return "Derek Loves You"
end

module.event_funcs["Random Explosion"] = function(uid)
    local xmin, ymin, xmax, ymax = get_bounds()
    local x, y, l = math.random(math.floor(xmin), math.floor(xmax)), math.random(math.floor(ymax), math.floor(ymin)), -1
    spawn(ENT_TYPE.FX_EXPLOSION, x, y, l, 0, 0)
    return "Random Explosion"
end

--- makes the player drop the item he is holding
module.event_funcs["Drop Currently Held Item"] = function(uid)
    local p = get_entity(uid)
    if p.holding_uid ~= -1 then
        p:drop(get_entity(p.holding_uid))
    end
    return "Drop Currently Held Item"
end


--v 0.3

--- spawns a random monster
module.event_funcs["Random Monster Spawn"] = function(uid)
    local px, py, pl = get_position(uid)
    spawn(module.monsters[math.random(1, #module.monsters)], px + math.random(-4, 4), py + math.random(-2, 2), pl, 0, 0)
    return "Random Monster Spawn"
end

--- spawns a random item
module.event_funcs["Random Item Spawn"] = function(uid)
    local px, py, pl = get_position(uid)
    spawn(module.items[math.random(1, #module.items)], px + math.random(-4, 4), py + math.random(-2, 2), pl, 0, 0)
    return "Random Item Spawn"
end

--- teleports the player to a random spot in the current level
module.event_funcs["Random Teleport"] = function(uid)
    local xmin, ymin, xmax, ymax = get_bounds()
    ::getair::
    local x = math.random(math.floor(xmin), math.floor(xmax))
    local y = math.random(math.floor(ymax), math.floor(ymin))
    local px, py, l = get_position(uid)
    local wallcheck = get_entities_at(0, 0x180, x, y, l, 0.5)
    if #wallcheck ~= 0 then goto getair end
    move_entity(uid, x, y, 0, 0)
    px, py, l = get_position(uid)
    return "Random Teleport"
end

--- spawn a plasma cannon that you can't shoot
module.event_funcs["Broken Plasma Cannon"] = function(uid)
    local px, py, pl = get_position(uid)
    local PC = get_entity(spawn(ENT_TYPE.ITEM_PLASMACANNON, px, py, pl, 0, 0))
    PC.flags = clrflag(PC.flags, 19)
    return "Broken Plasma Cannon"
end

--- kills all monsters in the current level
module.event_funcs["Obliteration"] = function(_)
    for i, v in ipairs(get_entities_by_mask(MASK.MONSTER)) do
        kill_entity(v)
    end
    return "Obliteration"
end

--- bullets have random velocity for 15 seconds
module.event_funcs["Wild Bullets"] = function(_)
    local frames_past = 0
    set_timeout(function()
        if frames_past >= 900 then clear_callback() end
        for _, v in ipairs(get_entities_by_type(ENT_TYPE.ITEM_BULLET)) do
            get_entity(v).velocityx = math.random()
            get_entity(v).velocityx = math.random()
        end
        frames_past = frames_past + 1
        clear_callback()
    end, 1)
    return "Wild Bullets"
end

--- blows up all of kali's altars in the current level
module.event_funcs["Kali Wants You Dead"] = function(_)
    local altars = get_entities_by(ENT_TYPE.FLOOR_ALTAR, 0, 0)
    if #altars == 0 then return choose_different_event() end
    for i, v in ipairs(get_entities_by(ENT_TYPE.FLOOR_ALTAR, 0, 0)) do
        local x, y, l = get_position(v)
        spawn_entity(ENT_TYPE.FX_EXPLOSION, x, y, l, 0, 0)
    end
    return "Kali Wants You Dead"
end

--- bombs replace bullets for 15 seconds
module.event_funcs["Bomb Bullets"] = function(_)
    local frames_past = 0
    set_timeout(function()
        if frames_past >= 900 then clear_callback() end
        for _, v in ipairs(get_entities_by_type(ENT_TYPE.ITEM_BULLET)) do
            local x, y, l = get_position(v)
            local mov = get_entity(v)
            local bomb = get_entity(spawn(ENT_TYPE.ITEM_BOMB, x, y, l, mov.velocityx, mov.velocityy))
            bomb.owner_uid = mov.owner_uid
            bomb.last_owner_uid = mov.last_owner_uid
            kill_entity(v)
        end
        frames_past = frames_past + 1
    end, 1)
    return "Bomb Bullets"
end

--- spawn a present
module.event_funcs["Happy Birthday!"] = function(uid)
    local x, y, l = get_position(uid)
    spawn(ENT_TYPE.ITEM_PRESENT, x, y, l, 0, 0)
    return "Happy Birthday!"
end

--- increase player's sprint factor by 0.25
module.event_funcs["Sprint Up"] = function(uid)
    local mov = get_entity(uid)
    mov.type.sprint_factor = mov.type.sprint_factor + 0.25
    return "Sprint Up"
end

--- increase player's jump power by 0.045
module.event_funcs["Jump Power Up"] = function(uid)
    local mov = get_entity(uid)
    mov.type.jump = mov.type.jump + 0.045
    return "Jump Power Up"
end

--- increase player's max speed by 0.005
module.event_funcs["Max Speed Up"] = function(uid)
    local mov = get_entity(uid)
    mov.type.max_speed = mov.type.max_speed + 0.005
    return "Max Speed Up"
end

--- increase player's acceleration by 0.008
module.event_funcs["Acceleration Up"] = function(uid)
    local mov = get_entity(uid)
    mov.type.acceleration = mov.type.acceleration + 0.008
    return "Acceleration Up"
end

--- decrease player's sprint factor by 0.25
module.event_funcs["Sprint Down"] = function(uid)
    local mov = get_entity(uid)
    mov.type.sprint_factor = mov.type.sprint_factor - 0.25
    return "Sprint Down"
end

--- decrease player's jump power by 0.045
module.event_funcs["Jump Power Down"] = function(uid)
    local mov = get_entity(uid)
    mov.type.jump = mov.type.jump - 0.045
    return "Jump Power Down"
end

--- decrease player's max speed by 0.005
module.event_funcs["Max Speed Down"] = function(uid)
    local mov = get_entity(uid)
    mov.type.max_speed = mov.type.max_speed - 0.005
    return "Max Speed Down"
end

--- decrease player's acceleration by 0.008
module.event_funcs["Acceleration Down"] = function(uid)
    local mov = get_entity(uid)
    mov.type.acceleration = mov.type.acceleration - 0.008
    return "Acceleration Down"
end

--- kill all monsters in the level
module.event_funcs["Kill All Monsters"] = function(_)
    for i, v in ipairs(get_entities_by_mask(MASK.MONSTER)) do
        kill_entity(v)
    end
    return "Kill All Monsters"
end

--- use a lot of money for bombs ($800 = 1 bomb)
module.event_funcs["Exchange Money for Bombs"] = function(uid)
    local p = get_entity(uid)
    local money_to_exchange = math.floor(p.inventory.money / 800)
    p.inventory.bombs = p.inventory.bombs + money_to_exchange
    p.inventory.money = p.inventory.money - money_to_exchange * 800
    return "Exchange Money for Bombs"
end

--- use a lot of money for bombs ($800 = 1 bomb)
module.event_funcs["Exchange Money for Ropes"] = function(uid)
    local p = get_entity(uid)
    local money_to_exchange = math.floor(p.inventory.money / 800)
    p.inventory.ropes = p.inventory.ropes + money_to_exchange
    p.inventory.money = p.inventory.money - money_to_exchange * 800
    return "Exchange Money for Ropes"
end

--- use a lot of money for health ($1000 = 1 heart)
module.event_funcs["Exchange Money for Health"] = function(uid)
    local p = get_entity(uid)
    local money_to_exchange = math.floor(p.inventory.money / 1000)
    p.health = p.health + money_to_exchange
    p.inventory.money = p.inventory.money - money_to_exchange * 1000
    return "Exchange Money for Health"
end

--v 0.4

--- clone the player
module.event_funcs["Clone Player"] = function(uid)
    local player_type = get_entity_type(uid)
    local x, y, l = get_position(uid)
    spawn_companion(player_type, x, y, l)
    return "Clone Player"
end

-- local area_ends = {}
-- area_ends[THEME.DWELLING] = 4
-- area_ends[THEME.JUNGLE] = 4
-- area_ends[THEME.VOLCANA] = 4
-- area_ends[THEME.OLMEC] = 1
-- area_ends[THEME.TEMPLE] = 4
-- area_ends[THEME.TIDE_POOL] = 4
-- area_ends[THEME.TIAMAT] = 4
-- area_ends[THEME.HUNDUN] = 4
-- area_ends[THEME.NEO_BABYLON] = 3

--- warp the player to end of the current area
-- module.event_funcs["Warp to Next Level"] = function(uid)
--     local w, l, theme = state.world, state.level, state.theme
--     warp(w, area_ends[theme], theme)
-- end



return module

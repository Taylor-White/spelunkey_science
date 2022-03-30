meta.name = "Eternal Flame of Gehenna"
meta.version = "1.0"
meta.author = "Dregu"
meta.description = "Testing custom themes with some light puzzle action turned violent."

-- if you're copying my code, just know this is not a very good example how a level sequence mod should be created
-- it's a prototype, and really messy, but it does show you the right callbacks to use for CustomTheme and other levelgen things

-- we're demoing this feature, it would be nice if you had a version that supports it
if not CustomTheme then
    set_callback(function(ctx)
        local _, size = get_window_size()
        size = size / 3
        local text = 'GET'
        local w, h = draw_text_size(size, text)
        ctx:draw_text(0-w/2, 0.5-h/2, size, text, 0xffffffff)
        text = 'PLAYLUNKY'
        w, h = draw_text_size(size, text)
        ctx:draw_text(0-w/2, 0-h/2, size, text, 0xffffffff)
        text = 'NIGHTLY'
        w, h = draw_text_size(size, text)
        ctx:draw_text(0-w/2, -0.5-h/2, size, text, 0xffffffff)
    end, ON.GUIFRAME)
end

local crust_items = {
    ENT_TYPE.EMBED_GOLD,
    ENT_TYPE.EMBED_GOLD_BIG,
    ENT_TYPE.ITEM_RUBY,
    ENT_TYPE.ITEM_SAPPHIRE,
    ENT_TYPE.ITEM_EMERALD,
    ENT_TYPE.ITEM_ALIVE_EMBEDDED_ON_ICE,
    ENT_TYPE.ITEM_PICKUP_ROPEPILE,
    ENT_TYPE.ITEM_PICKUP_BOMBBAG,
    ENT_TYPE.ITEM_PICKUP_BOMBBOX,
    ENT_TYPE.ITEM_PICKUP_SPECTACLES,
    ENT_TYPE.ITEM_PICKUP_CLIMBINGGLOVES,
    ENT_TYPE.ITEM_PICKUP_PITCHERSMITT,
    ENT_TYPE.ITEM_PICKUP_SPRINGSHOES,
    ENT_TYPE.ITEM_PICKUP_SPIKESHOES,
    ENT_TYPE.ITEM_PICKUP_PASTE,
    ENT_TYPE.ITEM_PICKUP_COMPASS,
    ENT_TYPE.ITEM_PICKUP_PARACHUTE,
    ENT_TYPE.ITEM_CAPE,
    ENT_TYPE.ITEM_JETPACK,
    ENT_TYPE.ITEM_TELEPORTER_BACKPACK,
    ENT_TYPE.ITEM_HOVERPACK,
    ENT_TYPE.ITEM_POWERPACK,
    ENT_TYPE.ITEM_WEBGUN,
    ENT_TYPE.ITEM_SHOTGUN,
    ENT_TYPE.ITEM_FREEZERAY,
    ENT_TYPE.ITEM_CROSSBOW,
    ENT_TYPE.ITEM_CAMERA,
    ENT_TYPE.ITEM_TELEPORTER,
    ENT_TYPE.ITEM_MATTOCK,
    ENT_TYPE.ITEM_BOOMERANG,
    ENT_TYPE.ITEM_MACHETE
}

names = {}
for i,v in pairs(ENT_TYPE) do
  names[v] = i
end

theme_names = {}
for i,v in pairs(THEME) do
  theme_names[v] = i
end

local function pick(from)
    return from[prng:random(#from)]
end

local function has(arr, item)
    for i, v in pairs(arr) do
        if v == item then
            return true
        end
    end
    return false
end

local current
local next
local num = 1
local won = false
local all_checkpoint = true
local checkpoint = 0
local deepest_level = 0
local total_time = 0
local deaths = 0
local load_time = false
local stats = {1, 0, 0}

local theme_index = 100

local room_templates = {}
for x = 0, 7 do
    local room_templates_x = {}
    for y = 0, 14 do
        local room_template = define_room_template("custom" .. y .. "_" .. x, ROOM_TEMPLATE_TYPE.NONE)
        room_templates_x[y] = room_template
    end
    room_templates[x] = room_templates_x
end

-- some hacks to hide decorations on connected edge tiles in co, cause the game doesn't
-- we're not really using it in this mod though
local function hide_decoration(uid, x, y)
    local ent = get_entity(uid)
    if not ent then return end
    for i,v in ipairs(entity_get_items_by(uid, 0, MASK.DECORATION)) do
        local deco = get_entity(v)
        if deco.x == x and deco.y == y then
            deco.color.a = 0
        end
    end
end
local function hide_border_decorations()
    local x1, y1, x2, y2 = get_bounds()
    for y=y1,y2,-1 do
        local left = get_grid_entity_at(x1+0.5, y, 0)
        local right = get_grid_entity_at(x2-0.5, y, 0)
        if left ~= -1 and right ~= -1 then
            hide_decoration(left, -0.5, 0)
            hide_decoration(right, 0.5, 0)
        end
    end
    for x=x1,x2,1 do
        local top = get_grid_entity_at(x, y1-0.5, 0)
        local bottom = get_grid_entity_at(x, y2+0.5, 0)
        if top ~= -1 and bottom ~= -1 then
            hide_decoration(top, 0, 0.5)
            hide_decoration(bottom, 0, -0.5)
        end
    end
end

-- change the text in construction signs
local function construction_sign(text)
    change_string(hash_to_stringid(0xbab72d60), text)
    change_string(hash_to_stringid(0x12645577), text)
end

-- list of levels with their special needs and textures
-- this is not very organized, I was just adding random things to this table as I went
local levels = {
    {file="level1.lvl", name="A gnome in the dark", theme=THEME.DWELLING, effects=THEME.EGGPLANT_WORLD, border_floor=ENT_TYPE.FLOOR_BORDERTILE_METAL, back=TEXTURE.DATA_TEXTURES_BG_MOTHERSHIP_0, dark=true, deco={1,2,4,5,7,8}, post_level_gen=function()
        construction_sign("If you don't like dark, don't worry!\nYou'll get to play the light version later.")
    end, post_theme=function()
        current.custom:post(THEME_OVERRIDE.SPAWN_EFFECTS, function()
            state.camera.bounds_bottom = state.camera.bounds_bottom + 8
        end)
    end
    },
    {file="level2.lvl", name="If you're reading this it's already too late", theme=THEME.JUNGLE, deco={1,2,4,5,7,8}, post_level_gen=function()
        construction_sign("Seriously, stop reading and hurry up.")
    end},
    {file="level3.lvl", name="Cloudy with a Chance of Meatballs", theme=THEME.VOLCANA, base=THEME.VOLCANA, effects=THEME.VOLCANA, deco={1,2,4,5,7}, floor=TEXTURE.DATA_TEXTURES_FLOOR_DWELLING_0, lut=TEXTURE.DATA_TEXTURES_LUT_VLAD_0, post_level_gen=function()
        for i,v in ipairs(get_entities_by_type(ENT_TYPE.FLOOR_BORDERTILE, ENT_TYPE.DECORATION_BORDER)) do
            local ent = get_entity(v)
            ent.color.r = 0.4
            ent.color.g = 0.15
            ent.color.b = 0.25
        end
        construction_sign("I added cheese to most of the levels. See if you can cheese this one!")
    end},
    {file="level4.lvl", name="Moisture is the essence of wetness", theme=THEME.TIDE_POOL, back=TEXTURE.DATA_TEXTURES_BG_SUNKEN_0, border_floor=ENT_TYPE.FLOOR_BORDERTILE_OCTOPUS, deco={1,2,4,5,7,8}, effects=THEME.SUNKEN_CITY ,lut=TEXTURE.DATA_TEXTURES_LUT_BACKLAYER_0, post_level_gen=function()
        construction_sign("Water physics are janky. Have fun!")
    end},
    {file="level5.lvl", name="Herring is a fish best served cold", theme=THEME.TEMPLE, back=TEXTURE.DATA_TEXTURES_BG_ICE_0, effects=THEME.TEMPLE, border_theme=THEME.ICE_CAVES, post_level_gen=function()
        construction_sign("Most of these are impossible to get.\nYou don't reaaally need any to win.")
    end},
    {file="level6.lvl", name="Fjord Escort", theme=THEME.ICE_CAVES, base=THEME.ICE_CAVES, effects=THEME.ICE_CAVES, border_theme=THEME.ICE_CAVES, back=TEXTURE.DATA_TEXTURES_BG_CAVE_0, deco={1,2,4,5,7,8}, lut=TEXTURE.DATA_TEXTURES_LUT_ICECAVES_0, post_level_gen=function()
        -- why don't these have the right texture
        for i,v in ipairs(get_entities_by_type(ENT_TYPE.ACTIVEFLOOR_FALLING_PLATFORM)) do
            local ent = get_entity(v)
            ent:set_texture(TEXTURE.DATA_TEXTURES_FLOOR_ICE_0)
        end
        construction_sign("I wish we could drop hud items, it would make this a lot easier.")
    end},
    {file="level7.lvl", name="Ocean's Two", theme=THEME.NEO_BABYLON, base=THEME.NEO_BABYLON, floor=TEXTURE.DATA_TEXTURES_FLOOR_VOLCANO_0, border_floor=ENT_TYPE.FLOOR_BORDERTILE, back=TEXTURE.DATA_TEXTURES_BG_VLAD_0, deco={1,2,4,5,7}, post_level_gen=function()
        construction_sign("We're doing some demolition work, please don't blow the place up. (Level is beatable either way.)")
    end},
    {file="level8.lvl", name="Burn after reading", theme=THEME.SUNKEN_CITY, border_floor=ENT_TYPE.FLOOR_BORDERTILE_METAL, back=TEXTURE.DATA_TEXTURES_BG_TIDEPOOL_0, dark=true, deco={1,2,4,5,7}, gravity=THEME.DWELLING, post_level_gen=function()
        construction_sign("Temporarily out of service.\nSorry for the inconvenience.")
        change_string(hash_to_stringid(0xbeaa608b), "Thanks! I can't believe I got stuck in here.")
        change_string(hash_to_stringid(0x96976465), "I guess we'll both die in here then!")
    end},
    {file="level1.lvl", name="Remastered", theme=THEME.EGGPLANT_WORLD, effects=THEME.EGGPLANT_WORLD, deco={1,2,4,5,7}, post_level_gen=function()
        construction_sign("This is a light version of 1-1! Same file,\nbut strangely some things are different...")
    end, post_theme=function()
        current.custom:post(THEME_OVERRIDE.SPAWN_EFFECTS, function()
            state.camera.bounds_bottom = state.camera.bounds_bottom + 8
        end)
    end},
    {file="level10.lvl", name="Space, the final frontier", theme=THEME.DWELLING, trans=THEME.DUAT, subtheme=THEME.DWELLING, music=THEME.COSMIC_OCEAN, post_theme=function()
        current.custom:override(THEME_OVERRIDE.SPAWN_BACKGROUND, THEME.COSMIC_OCEAN)
        current.custom:post(THEME_OVERRIDE.SPAWN_EFFECTS, function()
            -- remove the camera bounds set by the theme in EFFECTS and fix camera position so it won't yank to place on level start
            state.camera.adjusted_focus_x = state.level_gen.spawn_x
            state.camera.adjusted_focus_y = state.level_gen.spawn_y + 0.05
            state.camera.bounds_left = -math.huge
            state.camera.bounds_top = math.huge
            state.camera.bounds_right = math.huge
            state.camera.bounds_bottom = -math.huge
        end)
        -- make level loop like co
        current.custom:override(THEME_OVERRIDE.SPAWN_BORDER, THEME.COSMIC_OCEAN)
        current.custom:override(THEME_OVERRIDE.LOOP, THEME.COSMIC_OCEAN)
    end,
    post_level_gen=function()
        construction_sign("The loop kinda messes with your head\nwhen there's no void in between.")
        hide_border_decorations()
    end},
    {file="level9.lvl", name="404", theme=THEME.DUAT, effects=THEME.DUAT, border_theme=THEME.ICE_CAVES, bg=THEME.DUAT, init=true, post_level_gen=function()
        construction_sign("Most people would've beaten the boss by now.\nHere's a blue torch because that's the theme of the mod.")
    end},
}

local function in_level()
    return state.screen == SCREEN.LEVEL and #levels > state.level_count
end

-- used in end recap to format state.time_total
local function format_time(frames)
    if frames >= 21600000 then
        return "99:59:59.999"
    end
	local hours = 0
	local minutes = 0
	local seconds = 0
	local milliseconds = 0
	hours = frames // 216000
	frames = frames - (hours * 216000)
	minutes = frames // 3600
	frames = frames - (minutes * 3600)
	seconds = frames // 60
	frames = frames - (seconds * 60)
	milliseconds = math.floor(frames * 16.667)
    return hours .. ":" .. string.format("%02d", minutes) .. ":" .. string.format("%02d", seconds) .. "." .. string.format("%03d", milliseconds)
end

-- show recap on win, with custom text
local function win()
    won = true
	local frames = state.time_total
    state.items.player_inventory[1].collected_money_total = deaths
	change_string(hash_to_stringid(0x0ced29e8), "Congratulations") -- dear journal
    change_string(hash_to_stringid(0x3ae982b0), "Esteemed passenger, we have arrived at the ending screen. Local time is " .. format_time(state.time_total) .. " and your final death count is " .. deaths .. ".\n\nOn behalf of the airline and our crew, I'd like to thank you for joining us on this flight to damnation.\n\nHave a nice night.") -- law abiding
	state.journal_flags = 0 -- only show law abiding, which we just edited
    state.screen_next = SCREEN.RECAP
end

set_callback(function()
    -- edit recap before death
    if state.loading == 1 and state.screen_next == SCREEN.DEATH then
        deaths = deaths + 1
        state.journal_flags = set_flag(0, 21) -- i died
        change_string(hash_to_stringid(0x0ced29e8), "Oops") -- dear journal
        if deaths > 1 then
            change_string(hash_to_stringid(0x0ced29e8), "Oops I died again") -- dear journal
        end
        change_string(hash_to_stringid(0x3ae982b0), "Total time wasted: " .. format_time(state.time_total) .. "\nDeath count: " .. deaths) -- law abiding
    end

    -- load win screen if there are no levels left
    if #levels < state.level_count+1 and state.loading == 1 and not test_flag(state.quest_flags, 1) and state.screen == SCREEN.LEVEL then
        win()
    end
end, ON.LOADING)

-- spawn warp doors in camp up to the level you've reached
-- the guiframe later draws the level on the fx_button
local sx, sy = 0, 0
local sbutton = -1
local stext = ""
local function spawn_warp_door(x, y, layer, w, l, t)
    local uid = spawn_door(x, y, layer, w, l, t)
    set_pre_collision2(uid, function(door)
        local button = door.fx_button:as_button()
        if not button then return end
        if button.color.a < 0.5 then return end
        sx, sy, _ = get_position(button.uid)
        local levelname = levels[door.level].name
        stext = F"{door.world}-{door.level}: {levelname}"
        sbutton = button.uid
    end)
    local bg = spawn(ENT_TYPE.BG_DOOR_BACK_LAYER, x, y, layer, 0, 0)
    local ent = get_entity(bg)
    ent:set_draw_depth(44)
end

set_callback(function()

    -- reset the run and current checkpoint
    won = false
    checkpoint = 0
    total_time = 0
    deaths = 0
    sbutton = -1
    stext = ""

    -- block shortcut area with a stupid puzzle
    local wx = 36
    for wy=84,88 do
        spawn(ENT_TYPE.ACTIVEFLOOR_BUSHBLOCK, wx, wy, LAYER.FRONT, 0, 0)
    end
    spawn(ENT_TYPE.ITEM_TORCH, 64, 109, LAYER.FRONT, 0, 0)
    spawn(ENT_TYPE.ITEM_PICKUP_TRUECROWN, 34, 87, LAYER.FRONT, 0, 0)
    for x=7,48 do
        spawn_liquid(ENT_TYPE.LIQUID_WATER, x, 100)
    end
    construction_sign("Enjoy your new hat!")

    -- not using mod save I guess, no warp doors for you
    if savegame.deepest_area > 1 then return end

    deepest_level = math.max(deepest_level, savegame.deepest_level)

    -- make warp doors to all reached levels
    if deepest_level > 1 then
        local wy = 88
        local wx = 36
        for i=1,deepest_level do
            spawn_warp_door(wx+i, wy, LAYER.FRONT, 1, i, 1)
        end
        for i=1,12 do
            spawn(ENT_TYPE.FLOOR_DOOR_PLATFORM, wx+i, wy-1, LAYER.FRONT, 0, 0)
        end
        spawn_grid_entity(ENT_TYPE.FLOOR_SPRING_TRAP, 37, 84, LAYER.FRONT)
        local ceil = get_grid_entity_at(39, 93, LAYER.FRONT)
        if ceil ~= -1 then spawn_over(ENT_TYPE.ITEM_REDLANTERN, ceil, 0, -1) end
        ceil = get_grid_entity_at(45, 93, LAYER.FRONT)
        if ceil ~= -1 then spawn_over(ENT_TYPE.ITEM_REDLANTERN, ceil, 0, -1) end
    end

    set_lut(TEXTURE.DATA_TEXTURES_LUT_VLAD_0, LAYER.FRONT)

end, ON.CAMP)

set_callback(function(ctx)
    if state.screen ~= SCREEN.CAMP then return end
    if stext == "" then return end
    if sbutton == -1 then return end
    local button = get_entity(sbutton)
    if not button then
        sbutton = -1
        stext = ""
        return
    end
    local color = Color:new(1, 1, 1, button.color.a)
    local rx, ry = screen_position(sx-0.45, sy-0.3)
    ctx:draw_text(rx, ry, 20, stext, color:get_ucolor())
end, ON.GUIFRAME)

set_callback(function(ctx)
    if state.screen ~= SCREEN.LEVEL then return end

    -- load checkpoint on reset
    if #levels >= checkpoint+1 and test_flag(state.quest_flags, 1) and state.screen_last ~= SCREEN.CAMP and not won then
        state.level_count = checkpoint
        if state.screen_last ~= SCREEN.DEATH then
            deaths = deaths + 1
        end
        load_time = true
    end

    -- set checkpoint from warp door
    if state.screen_last == SCREEN.CAMP and state.level > 1 then
        total_time = 21600000
        load_time = true
        state.level_count = state.level - 1
        state.world = 1
        state.level = 1
    end

    -- set theme overrides from level
    if #levels >= state.level_count+1 and not won then
        num = state.level_count+1
        current = levels[num]
        next = levels[num+1]
        ctx:override_level_files({current.file})

        if not current.custom then
            current.custom = CustomTheme:new(theme_index, current.theme)
            current.custom.level_file = current.file
            if current.init then
                current.custom:override(THEME_OVERRIDE.INIT_LEVEL, current.theme)
            end
            if current.base then
                current.custom:override(THEME_OVERRIDE.BASE, current.base)
            end
            if current.effects then
                current.custom:override(THEME_OVERRIDE.SPAWN_EFFECTS, current.effects)
            end
            if current.post then
                current.custom:override(THEME_OVERRIDE.POST_PROCESS_LEVEL, current.theme)
                current.custom:override(THEME_OVERRIDE.POST_PROCESS_EXIT, current.theme)
                current.custom:override(THEME_OVERRIDE.POST_PROCESS_ENTITIES, current.theme)
                current.custom:override(THEME_OVERRIDE.SPAWN_DECORATION, current.theme)
                current.custom:override(THEME_OVERRIDE.SPAWN_DECORATION2, current.theme)
            end
            if current.border_theme then
                current.custom:override(THEME_OVERRIDE.SPAWN_BORDER, current.border_theme)
            end
            if current.border_floor then
                current.custom:override(THEME_OVERRIDE.ENT_BORDER, function()
                    return current.border_floor
                end)
            end
            if current.floor then
                current.custom.textures[DYNAMIC_TEXTURE.FLOOR] = current.floor
            end
            if current.back then
                current.custom.textures[DYNAMIC_TEXTURE.BACKGROUND] = current.back
            end
            if current.back_deco then
                current.custom.textures[DYNAMIC_TEXTURE.BACKGROUND_DECORATION] = current.back_deco
            end
            if current.bg then
                current.custom:override(THEME_OVERRIDE.SPAWN_BACKGROUND, current.bg)
            end
            if current.procedural then
                current.custom:override(THEME_OVERRIDE.SPAWN_BACKGROUND, current.procedural)
            end
            if current.gravity then
                current.custom:override(THEME_OVERRIDE.GRAVITY, current.gravity)
            end
            if current.trans then
                current.custom:override(THEME_OVERRIDE.PRE_TRANSITION, current.trans)
                current.custom:override(THEME_OVERRIDE.SPAWN_TRANSITION, current.trans)
            end

            if next then
                current.custom:post(THEME_OVERRIDE.PRE_TRANSITION, function()
                    state.world_next = 1
                    state.level_next = 1
                    state.theme_next = next.theme
                end)
                state.theme_next = next.theme
            end

            if current.post_theme then current.post_theme() end

            set_time_ghost_enabled(false)

            theme_index = theme_index + 1
        end

        state.theme = current.theme

        if all_checkpoint or current.checkpoint then
            checkpoint = state.level_count
            deepest_level = checkpoint + 1
        end

        if current.subtheme then force_custom_subtheme(current.subtheme) end
        force_custom_theme(current.custom)
    end
end, ON.PRE_LOAD_LEVEL_FILES)

set_callback(function()
    if not in_level() then return end
    if state.time_total > total_time then
        total_time = state.time_total
    end

    -- death counter
    for i,p in ipairs(players) do
        if i == 1 then
            p.inventory.money = 0
            p.inventory.collected_money_total = deaths
        else
            p.inventory.money = 0
            p.inventory.collected_money_total = 0
        end
    end
    state.money_shop_total = 0

end, ON.GAMEFRAME)

-- destroy random monsters
set_post_entity_spawn(function(ent, flags)
    ent.flags = set_flag(ent.flags, ENT_FLAG.DEAD)
    ent:destroy()
end, SPAWN_TYPE.LEVEL_GEN_GENERAL, 0, ENT_TYPE.MONS_SKELETON, ENT_TYPE.MONS_BAT, ENT_TYPE.MONS_SCARAB)

-- destroy treasure, random pots
set_post_entity_spawn(function(ent, flags)
    ent.flags = set_flag(ent.flags, ENT_FLAG.DEAD)
    ent:destroy()
end, SPAWN_TYPE.LEVEL_GEN_GENERAL, MASK.ITEM)

-- destroy bone block skulls
set_post_entity_spawn(function(ent, flags)
    ent.flags = set_flag(ent.flags, ENT_FLAG.DEAD)
    ent:destroy()
end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)

-- destroy embed treasure and items
set_post_entity_spawn(function(ent, flags)
    if ent.overlay and (ent.overlay.type.search_flags & MASK.FLOOR) > 0 then
        ent.flags = set_flag(ent.flags, ENT_FLAG.DEAD)
        ent:destroy()
    end
end, SPAWN_TYPE.LEVEL_GEN_TILE_CODE, 0, crust_items)

-- set LevelSequence room templates and force dark levels
set_callback(function(ctx)
    if state.screen <= SCREEN.CAMP then
        state.level_flags = set_flag(state.level_flags, 18)
    end
    if not in_level() then return end
    for x = 0, state.width - 1 do
        for y = 0, state.height - 1 do
            ctx:set_room_template(x, y, LAYER.FRONT, room_templates[x][y])
        end
    end
    if current.dark then
        state.level_flags = set_flag(state.level_flags, 18)
    else
        state.level_flags = clr_flag(state.level_flags, 18)
    end
end, ON.POST_ROOM_GENERATION)

-- spawn random midbg decorations around the level
local function spawn_deco(x, y, l, deco)
    local uid = spawn_critical(ENT_TYPE.MIDBG_STYLEDDECORATION, x, y, LAYER.FRONT, 0, 0)
    local ent = get_entity(uid)
    ent.animation_frame = pick(deco)
end
local function uniform_styleddecoration(deco)
    local num = 1
    local ax, ay, bx, by = get_bounds()
    for x=ax+math.random()*4+num,bx,math.random()*5+num*2 do
        for y=by+math.random()*4+num,ay,math.random()*5+num*2 do
            spawn_deco(x+math.random(-num*2, num*2), y+math.random(-num, num), LAYER.FRONT, deco)
        end
    end
end

-- set music, hud level and resources
set_callback(function()
    if not in_level() then return end
    if current.music then
        state.theme = current.music
    end

    if current.deco then
        uniform_styleddecoration(current.deco)
    end

    -- for hud
    state.world = 1
    state.level = state.level_count+1

    for i,p in ipairs(players) do
        p.health = stats[1]
        p.inventory.bombs = stats[2]
        p.inventory.ropes = stats[3]
    end

    if current.post_level_gen then current.post_level_gen() end

end, ON.POST_LEVEL_GENERATION)

-- add accumulated total time and run level hooks
set_callback(function()
    if not in_level() then return end
    if current and current.on_level then
        current.on_level()
    end
    if load_time and state.time_total < total_time then
        state.time_total = total_time
        load_time = false
    end
    if current.name then
        cancel_toast()
        set_timeout(function()
            toast(current.name)
        end, 1)
    end
    if current.lut then
        set_lut(current.lut, LAYER.FRONT)
    else
        set_lut(TEXTURE.DATA_TEXTURES_LUT_ORIGINAL_0, LAYER.FRONT)
    end
end, ON.LEVEL)

-- clear 'carry through exit' flag from all spawned items
set_post_entity_spawn(function(ent)
    if state.screen == SCREEN.LEVEL then
        ent.flags = clr_flag(ent.flags, 22)
    end
end, SPAWN_TYPE.ANY, MASK.ITEM, nil)

-- drop all items when entering a portal
set_post_entity_spawn(function(ent)
    set_pre_collision2(ent.uid, function(portal, collider)
        if getmetatable(collider).__type.name == "Player" then
            unequip_backitem(collider.uid)
            for i,v in ipairs(entity_get_items_by(collider.uid, 0, MASK.ITEM)) do
                drop(collider.uid, v)
            end
        end
    end)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.LOGICAL_PORTAL)

-- remove all powerups when exiting
set_callback(function()
    if state.loading == 1 and state.screen_next == SCREEN.TRANSITION then
        for _,p in ipairs(players) do
            for _,v in ipairs(p:get_powerups()) do
                p:remove_powerup(v)
                unequip_backitem(p.uid)
            end
        end
    end
end, ON.LOADING)

-- fix portal constellation ending in duat
set_post_entity_spawn(function(ent)
    set_timeout(function()
        ent.world = 8
        ent.level = 99
        ent.theme = THEME.DUAT
    end, 1)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.LOGICAL_PORTAL)

-- entrance with no textures or pots, just the player
define_tile_code("entrance_nocrap")
set_pre_tile_code_callback(function(x, y, layer)
    spawn_grid_entity(ENT_TYPE.FLOOR_DOOR_ENTRANCE, x, y, layer)
    state.level_gen.spawn_x = x
    state.level_gen.spawn_y = y
    local rx, ry = get_room_index(x, y)
    state.level_gen.spawn_room_x = rx
    state.level_gen.spawn_room_y = ry
    return true
end, "entrance_nocrap")

-- unlocked layer  door that doesn't spawn a platform when floor is kil
define_tile_code("door2_noplatform")
set_pre_tile_code_callback(function(x, y, layer)
    spawn_grid_entity(ENT_TYPE.FLOOR_DOOR_LAYER, x, y, layer)
    spawn_critical(ENT_TYPE.BG_DOOR_FRONT_LAYER, x, y, layer, 0, 0)
    return true
end, "door2_noplatform")

-- locked layer door that doesn't spawn a platform when floor is kil
define_tile_code("locked_door_noplatform")
set_pre_tile_code_callback(function(x, y, layer)
    spawn_critical(ENT_TYPE.BG_SHOP_BACKDOOR, x, y, layer, 0, 0)
    spawn_grid_entity(ENT_TYPE.FLOOR_DOOR_LOCKED, x, y, layer)
    return true
end, "locked_door_noplatform")

-- the blue platform, they work a bit differently from platforms
define_tile_code("logical_platform")
set_pre_tile_code_callback(function(x, y, layer)
    spawn_critical(ENT_TYPE.LOGICAL_PLATFORM_SPAWNER, x, y, layer, 0, 0)
    return true
end, "logical_platform")

-- floor_generic from theme_next
define_tile_code("next")
set_pre_tile_code_callback(function(x, y, layer)
    spawn_grid_entity(ENT_TYPE.FLOOR_TUNNEL_NEXT, x, y, layer)
end, "next")

-- didn't work, had to make my own
define_tile_code("leprechaun")
set_pre_tile_code_callback(function(x, y, layer)
    spawn_critical(ENT_TYPE.MONS_LEPRECHAUN, x, y, layer, 0, 0)
    return true
end, "leprechaun")

-- docile headless hundun just sitting in a dungeon somewhere...
define_tile_code("dead_hundun")
set_pre_tile_code_callback(function(x, y, layer)
    spawn_critical(ENT_TYPE.MONS_HUNDUN, x, y, layer, 0, 0)
    set_post_entity_spawn(function(ent)
        kill_entity(ent.uid)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_HUNDUN_BIRDHEAD, ENT_TYPE.MONS_HUNDUN_SNAKEHEAD)
    return true
end, "dead_hundun")

-- horizontal forcefields with fixed textures, left timer is offset 60 frames like in tiamat
define_tile_code("forcefield_right")
set_pre_tile_code_callback(function(x, y, layer)
    local uid = spawn_grid_entity(ENT_TYPE.FLOOR_HORIZONTAL_FORCEFIELD, x, y, layer)
    local ent = get_entity(uid)
    ent.angle = 3*math.pi/2
    ent.flags = clr_flag(ent.flags, ENT_FLAG.TAKE_NO_DAMAGE)
    return true
end, "forcefield_right")
define_tile_code("forcefield_right_top")
set_pre_tile_code_callback(function(x, y, layer)
    local uid = spawn_grid_entity(ENT_TYPE.FLOOR_HORIZONTAL_FORCEFIELD_TOP, x, y, layer)
    local ent = get_entity(uid)
    ent.angle = 3*math.pi/2
    return true
end, "forcefield_right_top")
define_tile_code("forcefield_left")
set_pre_tile_code_callback(function(x, y, layer)
    local uid = spawn_grid_entity(ENT_TYPE.FLOOR_HORIZONTAL_FORCEFIELD, x, y, layer)
    local ent = get_entity(uid)
    ent.angle = math.pi/2
    ent.flags = set_flag(ent.flags, ENT_FLAG.FACING_LEFT)
    ent.flags = clr_flag(ent.flags, ENT_FLAG.TAKE_NO_DAMAGE)
    ent.timer = 60
    return true
end, "forcefield_left")
define_tile_code("forcefield_left_top")
set_pre_tile_code_callback(function(x, y, layer)
    local uid = spawn_grid_entity(ENT_TYPE.FLOOR_HORIZONTAL_FORCEFIELD_TOP, x, y, layer)
    local ent = get_entity(uid)
    ent.angle = math.pi/2
    ent.flags = set_flag(ent.flags, ENT_FLAG.FACING_LEFT)
    return true
end, "forcefield_left_top")

-- arrow trap with direction
define_tile_code("arrow_trap_right")
set_pre_tile_code_callback(function(x, y, layer)
    local uid = spawn_grid_entity(ENT_TYPE.FLOOR_ARROW_TRAP, x, y, layer)
    local ent = get_entity(uid)
    ent.flags = clr_flag(ent.flags, ENT_FLAG.FACING_LEFT)
    return true
end, "arrow_trap_right")
define_tile_code("arrow_trap_left")
set_pre_tile_code_callback(function(x, y, layer)
    local uid = spawn_grid_entity(ENT_TYPE.FLOOR_ARROW_TRAP, x, y, layer)
    local ent = get_entity(uid)
    ent.flags = set_flag(ent.flags, ENT_FLAG.FACING_LEFT)
    return true
end, "arrow_trap_left")
define_tile_code("arrow_trap_left_if_dark")
set_pre_tile_code_callback(function(x, y, layer)
    local uid = spawn_grid_entity(ENT_TYPE.FLOOR_ARROW_TRAP, x, y, layer)
    local ent = get_entity(uid)
    if test_flag(state.level_flags, 18) then
        ent.flags = set_flag(ent.flags, ENT_FLAG.FACING_LEFT)
    end
    return true
end, "arrow_trap_left_if_dark")
define_tile_code("arrow_trap_left_if_light")
set_pre_tile_code_callback(function(x, y, layer)
    local uid = spawn_grid_entity(ENT_TYPE.FLOOR_ARROW_TRAP, x, y, layer)
    local ent = get_entity(uid)
    if not test_flag(state.level_flags, 18) then
        ent.flags = set_flag(ent.flags, ENT_FLAG.FACING_LEFT)
    end
    return true
end, "arrow_trap_left_if_light")

-- torch if it's dark, otherwise rock
define_tile_code("torch_or_rock")
set_pre_tile_code_callback(function(x, y, layer)
    if test_flag(state.level_flags, 18) then
        local uid = spawn_on_floor(ENT_TYPE.ITEM_TORCH, x, y, layer)
        spawn_entity_over(ENT_TYPE.ITEM_TORCHFLAME, uid, 0, 0)
    else
        spawn_on_floor(ENT_TYPE.ITEM_ROCK, x, y, layer, 0, 0)
    end
    return true
end, "torch_or_rock")

-- torch if it's dark, otherwise pot
define_tile_code("torch_or_pot")
set_pre_tile_code_callback(function(x, y, layer)
    if test_flag(state.level_flags, 18) then
        local uid = spawn_on_floor(ENT_TYPE.ITEM_TORCH, x, y, layer)
        spawn_entity_over(ENT_TYPE.ITEM_TORCHFLAME, uid, 0, 0)
    else
        spawn_on_floor(ENT_TYPE.ITEM_POT, x, y, layer, 0, 0)
    end
    return true
end, "torch_or_pot")

-- pushblock if it's dark, otherwise powder keg
define_tile_code("push_or_keg")
set_pre_tile_code_callback(function(x, y, layer)
    if test_flag(state.level_flags, 18) then
        spawn_critical(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
    else
        spawn_critical(ENT_TYPE.ACTIVEFLOOR_POWDERKEG, x, y, layer, 0, 0)
    end
    return true
end, "push_or_keg")

-- stupid dog sign ruining my zen
define_tile_code("dog_sign")
set_pre_tile_code_callback(function(x, y, layer)
    return true
end, "dog_sign")

--[[
set_post_entity_spawn(function(ent)
    if state.screen == SCREEN.CAMP and #players > 0 then
        ent:destroy()
    end
end, SPAWN_TYPE.ANY, MASK.PLAYER)
]]

set_pre_entity_spawn(function(type, x, y, l, overlay, flags)
    if state.screen == SCREEN.CAMP and #players > 0 then
        local uid = spawn_critical(type, 23, 64, l, 0, 0)
        set_timeout(function()
            local ent = get_entity(uid)
            if ent then ent:destroy() end
        end, 1)
        return uid
    end
end, SPAWN_TYPE.ANY, MASK.PLAYER)

-- randomize dice
set_post_entity_spawn(function(ent)
    set_timeout(function()
        ent.animation_frame = prng:random(245, 250)
    end, 1)
end, SPAWN_TYPE.LEVEL_GEN_TILE_CODE, 0, ENT_TYPE.ITEM_DIE)

-- randomize ushabti
set_post_entity_spawn(function(ent)
    set_timeout(function()
        ent.animation_frame = prng:random(0, 9) + prng:random(0, 9) * 12
    end, 1)
end, SPAWN_TYPE.LEVEL_GEN_TILE_CODE, 0, ENT_TYPE.ITEM_USHABTI)

-- swap scepter to torch
set_pre_entity_spawn(function(type, x, y, l, overlay)
    return spawn_critical(ENT_TYPE.ITEM_TORCH, x, y, l, 0, 0)
end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SCEPTER)

-- swap diamond to nothing
set_pre_entity_spawn(function(type, x, y, l, overlay)
    return spawn_critical(ENT_TYPE.FX_SHADOW, x, y, l, 0, 0)
end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_DIAMOND)

-- remove some red from torches
get_particle_type(PARTICLEEMITTER.TORCHFLAME_FLAMES).red = 0

-- change money to deaths
change_string(hash_to_stringid(0x7162b3ad), "Deaths")

meta = {
    name = "Shopkeeper Slaughter",
    version = "1.0",
    description = "This mod uses custom music! Make sure to disable the music in-game.\nAn endless mini-game involving the murder of shopkeepers! How many rounds can you survive for?",
    author = "erictran"
}
register_option_bool("enable_custom_music", "Enable custom music?", "Highly reccomended. Just make sure to turn off the vanilla music! If you want to play without music or without custom music, then disable this option.", true)
register_option_float("custom_music_volume", "Custom Music Volume", "Volume of the custom music. This is relative to your regular in game sound settings.", 0.35, 0, 1)
register_option_bool("short_stun", "Short stuns?", "Highly reccomended. You will recover from stuns very quickly, this minigame is much harder otherwise. If you want a more true to vanilla experience, turn this off.", true)
register_option_bool("big_zoom", "Large zoom?", "Highly reccomended. The camera will be more zoomed out, making it easier to see things. If you want a more true to vanilla experience, turn this off.", true)

custom_levels = require("CustomLevels/custom_levels")
require("shoppie_generator")
custom_music = require("custom_music")
require("loot_drops")
--make factory generators indestructible, otherwise the player could just destroy the shoppie spawners
local generator_db = get_type(ENT_TYPE.FLOOR_FACTORY_GENERATOR)
generator_db.default_flags = set_flag(generator_db.default_flags, ENT_FLAG.TAKE_NO_DAMAGE)
shopkeeper_slaughter = {
    active = false, --in a round
    countdown = -1,
    pre_game_countdown = -1,
    base_spawn_time = 560, --frames to pass before spawning a shopkeeper from a generator
    base_shoppies_left = 1,
    shoppies_left = 1, --number of shoppies left to spawn
    shoppie_count = 1, --shoppies left + alive shoppies
    shoppie_warnings_left = 1, --used to keep track of how many warnings can be spawned for shoppies, since these spawn at a delay
    counted_level = 1,

    --settings
    default_music_volume = 0.2,
}
function start_game()
    shopkeeper_slaughter.pre_game_countdown = 300
end
function get_music_for_area()
    if state.theme == THEME.DWELLING then
        return 'Music/dwelling.ogg'
    elseif state.theme == THEME.JUNGLE then
        return 'Music/jungle.ogg'
    elseif state.theme == THEME.VOLCANA then
        return 'Music/volcana.ogg'
    elseif state.theme == THEME.TIDE_POOL then
        return 'Music/tidepool.ogg'
    elseif state.theme == THEME.TEMPLE then
        return 'Music/temple.ogg'
    elseif state.theme == THEME.ICE_CAVES then
        return 'Music/icecaves.ogg'
    elseif state.theme == THEME.NEO_BABYLON then
        return 'Music/babylon.ogg'
    elseif state.theme == THEME.SUNKEN_CITY then
        return 'Music/sunken.ogg'
    end
end
function manage_game()
    if state.screen ~= SCREEN.LEVEL then reset_game() return end
    if shopkeeper_slaughter.countdown > 0 then
        shopkeeper_slaughter.countdown = shopkeeper_slaughter.countdown - 1
    end
    if shopkeeper_slaughter.pre_game_countdown > 0 then
        shopkeeper_slaughter.pre_game_countdown = shopkeeper_slaughter.pre_game_countdown - 1
    end
    --start the game if the pregame countdown is at 0
    if shopkeeper_slaughter.pre_game_countdown == 0 then
        shopkeeper_slaughter.active = true
        shopkeeper_slaughter.pre_game_countdown = -1 --this way it wont get set active
    end
    --once all shoppies are dead start the round over sequence
    if shopkeeper_slaughter.shoppie_count == 0 and shopkeeper_slaughter.active == true and shopkeeper_slaughter.shoppies_left == 0 and state.pause == 0 then
        shopkeeper_slaughter.active = false
        shopkeeper_slaughter.countdown = 300
        play_vanilla_sound(VANILLA_SOUND.UI_GET_GEM)
        custom_music.stop_music()
    end
    if shopkeeper_slaughter.countdown == 0 then
        shopkeeper_slaughter.countdown = -1
        shopkeeper_slaughter.shoppies_left = 3+(math.floor(state.level*1.8)) --number of shoppies left to spawn
        shopkeeper_slaughter.shoppie_count = 3+(math.floor(state.level*1.8)) --shoppies left + alive shoppies
        shopkeeper_slaughter.shoppie_warnings_left = 3+(math.floor(state.level*1.8))
        shopkeeper_slaughter.counted_level = state.level+1
        warp(state.world_start, state.level+1, state.theme_start)
        --cap shoppies left
        if shopkeeper_slaughter.shoppies_left > 20 then
            shopkeeper_slaughter.shoppies_left = 20
            shopkeeper_slaughter.shoppie_count = 20
            shopkeeper_slaughter.shoppie_warnings_left = 20
        end
    end
end
function reset_game()
    shopkeeper_slaughter.active = false --in a round
    shopkeeper_slaughter.countdown = -1
    shopkeeper_slaughter.pre_game_countdown = -1
    shopkeeper_slaughter.base_spawn_time = 560 --frames to pass before spawning a shopkeeper from a generator
    shopkeeper_slaughter.base_shoppies_left = 3
    shopkeeper_slaughter.shoppies_left = 3 --number of shoppies left to spawn
    shopkeeper_slaughter.shoppie_count = 3 --shoppies left + alive shoppies
    shopkeeper_slaughter.shoppie_warnings_left = 3
    shopkeeper_slaughter.counted_level = 1
end
function draw_game_text(render_ctx)
    if state.screen ~= SCREEN.LEVEL then return end
    local white = Color:white()
    local text = ""
    --determine text
    if shopkeeper_slaughter.pre_game_countdown > 240 then
        text = "Ready?"
    elseif shopkeeper_slaughter.pre_game_countdown < 240 and shopkeeper_slaughter.pre_game_countdown > 180 then
        text = "3"
    elseif shopkeeper_slaughter.pre_game_countdown < 180 and shopkeeper_slaughter.pre_game_countdown > 120 then
        text = "2"
    elseif shopkeeper_slaughter.pre_game_countdown < 120 and shopkeeper_slaughter.pre_game_countdown > 60 then
        text = "1"
    elseif shopkeeper_slaughter.pre_game_countdown < 60 and shopkeeper_slaughter.pre_game_countdown > 0 then
        text = "GO!"
    end
    --play in-round music
    if shopkeeper_slaughter.pre_game_countdown == 61 then
        custom_music.current_music = custom_music.set_music(get_music_for_area())
        custom_music.set_volume_instant(shopkeeper_slaughter.default_music_volume)
        custom_music.stop_music() --stop any potentially playing music
        custom_music.play_music()
        play_vanilla_sound(VANILLA_SOUND.DEATHMATCH_DM_TIMER, 0.5)  
    end
    if shopkeeper_slaughter.pre_game_countdown == 240 then
        play_vanilla_sound(VANILLA_SOUND.DEATHMATCH_DM_SCORE, 0.5) 
    elseif shopkeeper_slaughter.pre_game_countdown == 180 then
        play_vanilla_sound(VANILLA_SOUND.DEATHMATCH_DM_SCORE, 0.5) 
    elseif shopkeeper_slaughter.pre_game_countdown == 120 then
        play_vanilla_sound(VANILLA_SOUND.DEATHMATCH_DM_SCORE, 0.5) 
    end
    if shopkeeper_slaughter.shoppie_count == 0 then
        if players[1] ~= nil then
            if get_entity(players[1].uid) ~= nil then
                if not test_flag(players[1].flags, ENT_FLAG.DEAD) then
                    text = "ROUND CLEARED!"
                end
            end
        end
    end
    if state.screen == SCREEN.LEVEL then
        render_ctx:draw_text(text, 0, 0.25,  0.003, 0.003, white, VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.BOLD)
    end
end
set_callback(reset_game, ON.RESET)
set_callback(reset_game, ON.DEATH)
set_callback(start_game, ON.LEVEL)
set_callback(manage_game, ON.GAMEFRAME)
set_callback(draw_game_text, ON.RENDER_PRE_HUD)

--music stuff
set_callback(function()
    custom_music.current_music = custom_music.set_music('Music/default.ogg')
    custom_music.set_volume_instant(shopkeeper_slaughter.default_music_volume)
    custom_music.stop_music() --stop any potentially playing music
    custom_music.play_music()
end, ON.LEVEL)
set_callback(function()
    custom_music.stop_music()
end, ON.DEATH)
set_callback(function()
    --stop music when on main menu (temporary)
    if state.screen == SCREEN.MENU then
        custom_music.stop_music()
    end
    --update volume amount
    shopkeeper_slaughter.default_music_volume = options.custom_music_volume
end, ON.GUIFRAME)

function spawn_shopkeeper(x, y, l)
    local shopkeeper_uid = spawn(ENT_TYPE.MONS_SHOPKEEPERCLONE, x, y, l, 0, 0)
    local shopkeeper = get_entity(shopkeeper_uid)
    return shopkeeper_uid
end
function determine_shopkeeper_weapon()
    local roll = math.random(100)
    if state.level < 2 then
        if roll <= 40 then
            return ENT_TYPE.ITEM_SHOTGUN
        else
            return ENT_TYPE.ITEM_POWERUP_PASTE
        end
    elseif state.level < 4 and state.level >= 2 then
        if roll <= 70 then
            return ENT_TYPE.ITEM_SHOTGUN
        else
            return ENT_TYPE.ITEM_POWERUP_PASTE
        end
    elseif state.level < 8 and state.level > 4 then
        if roll <= 80 then
            return ENT_TYPE.ITEM_SHOTGUN
        elseif roll < 5 and roll > 2 then
            return ENT_TYPE.ITEM_FREEZERAY
        elseif roll < 3 then
            return ENT_TYPE.ITEM_WEBGUN
        else
            return ENT_TYPE.ITEM_POWERUP_PASTE
        end
    else
        if roll <= 95 and roll > 14 then
            return ENT_TYPE.ITEM_SHOTGUN
        elseif roll < 15 and roll > 9 then
            return ENT_TYPE.ITEM_FREEZERAY
        elseif roll < 10 and roll < 4 then
            return ENT_TYPE.ITEM_WEBGUN
        elseif roll < 5 and roll > 1 then
            return ENT_TYPE.ITEM_EXCALIBUR
        elseif roll < 2 then
            return ENT_TYPE.ITEM_PLASMACANNON
        else
            return ENT_TYPE.ITEM_POWERUP_PASTE
        end
    end 
    return ENT_TYPE.ITEM_POWERUP_PASTE
end

function play_vanilla_sound(snd, volume)
    local sound = get_sound(snd)
    if sound ~= nil then playing_sound = sound:play(false, SOUND_TYPE.SFX) end
    if volume ~= nil then
        playing_sound:set_volume(volume)
    end
end

function draw_shoppie_count(render_ctx)
    if state.screen ~= SCREEN.LEVEL then return end
    if shopkeeper_slaughter.active then
        local white = Color:white()
        render_ctx:draw_screen_texture(65, 8, 4, -0.1, 0.85, 0, 0.7, white)
        render_ctx:draw_screen_texture(65, 8, 4, 0.1, 0.85, 0, 0.7, white)
        render_ctx:draw_screen_texture(65, 7, 15, -0.045, 0.93, 0.05, 0.76, white)
        render_ctx:draw_text(tostring(shopkeeper_slaughter.shoppie_count), 0, 0.776,  0.00075, 0.00075, white, VANILLA_TEXT_ALIGNMENT.CENTER, VANILLA_FONT_STYLE.BOLD)
    end
end
--set the custom level layout
set_callback(function(ctx)
    state.level = 5 --apparently SC levels will crash otherwise...
    local w, h = 3, 2
    local level = 'dwelling1.lvl'
    local current_theme = THEME.DWELLING
    local roll = math.random(8)
    if shopkeeper_slaughter.counted_level > 1 then
        if roll == 1 then
            level = 'dwelling1.lvl'
            current_theme = THEME.DWELLING
            w, h = 3, 2
        elseif roll == 2 then
            level = 'tidepool1.lvl'
            current_theme = THEME.TIDE_POOL
            w, h = 3, 2
        elseif roll == 3 then
            level = 'jungle1.lvl'
            current_theme = THEME.JUNGLE
            w, h = 3, 2
        elseif roll == 4 then
            level = 'volcana1.lvl'
            current_theme = THEME.VOLCANA
            w, h = 2, 2
        elseif roll == 5 then
            level = 'temple1.lvl'
            current_theme = THEME.TEMPLE
            w, h = 3, 2
        elseif roll == 6 then
            level = 'icecaves1.lvl'
            current_theme = THEME.ICE_CAVES
            w, h = 3, 3
        elseif roll == 7 then
            level = 'babylon1.lvl'
            current_theme = THEME.NEO_BABYLON
            w, h = 3, 2
        elseif roll == 8 then
            level = 'sunken1.lvl'
            current_theme = THEME.SUNKEN_CITY
            w, h = 3, 2
        end
    end
    if state.screen ~= SCREEN.LEVEL then
        custom_levels.unload_level()
    else --pick a regular level
        local width, height = w, h
        local theme_properties = {
            theme = current_theme,
        }
        state.theme = current_theme
        custom_levels.load_level_custom_theme(ctx, level, theme_properties)
    end --load a shop level
end, ON.PRE_LOAD_LEVEL_FILES)
set_callback(function()
    if state.screen == SCREEN.LEVEL then
        state.world = 1
    end
end, ON.POST_LEVEL_GENERATION)
--gameframe stuffs
set_callback(function()
    --make shopkeeper clones drop coins
    for _, v in ipairs(get_entities_by_type(ENT_TYPE.MONS_SHOPKEEPERCLONE)) do
        local ent = get_entity(v)
        local x, y, l = get_position(v)
        --create a "marked for destruction" flag that will destroy items if they arent picked up / collected in time..
        --this way, if the player picks up an item like a mattock, its "Saved" and wont despawn out of their hands.
        if test_flag(ent.flags, ENT_FLAG.DEAD) and ent.health <= 0 and not test_flag(ent.flags, ENT_FLAG.SHOP_FLOOR) then
            ent.flags = set_flag(ent.flags, ENT_FLAG.SHOP_FLOOR)
            local loot = get_entity(spawn(generate_loot_drop(), x, y, l, math.random(-10, 10)/50, 0))
            loot.more_flags = set_flag(loot.more_flags, 28)
            for i = 0, 4 do
                local coin = get_entity(spawn(ENT_TYPE.ITEM_GOLDCOIN, x, y, l, math.random(-10, 10)/50, math.random(2, 8)/50))
                coin.more_flags = set_flag(coin.more_flags, 28)
            end
        end
    end
    --calculate shoppies left
    --done in shoppie_generator.lua so that the number doesnt change for one frame
    --make the player recover from stuns as fast as possible
    if options.short_stun then
        if players[1] ~= nil then
            if players[1].stun_timer > 15 then
                players[1].stun_timer = 15
            end
        end
    end
end, ON.GAMEFRAME)
set_callback(draw_shoppie_count, ON.RENDER_PRE_HUD)
--disable dark levels
set_callback(function()
    state.level_flags = clr_flag(state.level_flags, 18)
    if options.big_zoom then
        if state.screen == SCREEN.LEVEL then
            zoom(15)
        end
        if state.screen == SCREEN.CAMP then
            zoom(13.5)
        end
    end
end, ON.POST_ROOM_GENERATION)
--set the level back to the proper one once the level has been generated. this stops SC levels from crashing
set_callback(function()
    state.level = shopkeeper_slaughter.counted_level
end, ON.POST_LEVEL_GENERATION)
level_type = "DEFAULT"
--[[
DEFAULT = regular level with key and lock
BOSS = level with a boss in it
SHOP = level with a shop
ENDOFDEMO = end of the demo, has a cute area with beg disguised as yang
]]
function determine_main_music()
    local roll = math.random(50)
    local chosen_main_music = assets.mu_main
    if roll == 50 then
        chosen_main_music = assets.mu_main_rare
    end
    if is_caveman then
        chosen_main_music = assets.mu_caveman
    end
    if is_shadow then
        chosen_main_music = assets.mu_shadow
    end
    return chosen_main_music
end
function determine_given_floor_type(floor)
    for _, v in ipairs(boss_levels) do
        if v == floor then
            return "BOSS"
        end
    end
    for _, v in ipairs(shop_levels) do
        if v == floor then
            return "SHOP"
        end
    end
    if floor == endofdemo_level then
        return "ENDOFDEMO"
    end
    return "DEFAULT"
end
function determine_floor_type()
    level_type = "DEFAULT"
    for _, v in ipairs(boss_levels) do
        if v == game_controller.floor then
            level_type = "BOSS"
        end
    end
    for _, v in ipairs(shop_levels) do
        if v == game_controller.floor then
            level_type = "SHOP"
        end
    end
    if game_controller.floor == endofdemo_level then
        level_type = "ENDOFDEMO"
    end
end
function determine_floor_theme()
    if game_controller.floor < jungle_start then    --determine non-shop themes, this will continue for all areas in an elseif string
        game_controller.current_theme = THEME.DWELLING
    end
    for _, v in ipairs(shop_levels) do
        if game_controller.floor == v then
            game_controller.current_theme = THEME.CITY_OF_GOLD
        end
    end
    if game_controller.floor == endofdemo_level then
        game_controller.current_theme = THEME.ABZU
    end
end
function manage_room_types()
    if level_type == "BOSS" then
        set_ghost_spawn_times(-1, -1)
        honorbound_controller.set_honorbound_state(true)
        custom_music.current_music = custom_music.set_music(assets.mu_pre_boss)
        custom_music.set_volume_instant(game_controller.default_music_volume)
        custom_music.stop_music() --stop any potentially playing music
        custom_music.play_music()
    end
    if level_type == "SHOP" then
        set_ghost_spawn_times(-1, -1)
        custom_music.current_music = custom_music.set_music(assets.mu_shop)
        custom_music.set_volume_instant(game_controller.default_music_volume)
        custom_music.stop_music() --stop any potentially playing music
        custom_music.play_music()
    end
    if level_type == "DEFAULT" then
        set_ghost_spawn_times(10800, 9000)
        --determine if previous floor was a music change level
        local previous_floor_was_music_change = false
        for _, v in ipairs(music_change_levels) do
            if v == game_controller.floor-1 or v == game_controller.floor then
                previous_floor_was_music_change = true
            end
        end
        if previous_floor_was_music_change then --dont reset it after every normal level
            local chosen_main_music = determine_main_music()
            custom_music.current_music = custom_music.set_music(chosen_main_music)
            custom_music.set_volume_instant(game_controller.default_music_volume)
            custom_music.stop_music() --stop any potentially playing music
            custom_music.play_music()
        end
    end
    if level_type == "ENDOFDEMO" then
        custom_music.stop_music()
    end
end
function determine_music_volume()
    custom_music.set_volume(game_controller.paused_music_volume, 0.005)
    for _,v in ipairs(music_change_levels) do
        if game_controller.floor == v or game_controller.floor-1 == v then
            custom_music.set_volume(0, 0.0025)
        end
    end
end
set_callback(determine_music_volume, ON.TRANSITION)
set_po1t_callback(determine_floor_theme, PO1T_ON.EXIT_UNLOCKED)
set_callback(manage_room_types, ON.LEVEL)
set_callback(determine_floor_type, ON.PRE_LEVEL_GENERATION)
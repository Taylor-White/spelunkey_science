meta.name = "Chaotic Events"
meta.description = "Random events happen every 30 seconds. Highly customizable. You can also change the delay between events."
meta.version = "0.4"
meta.author = "C_ffeeStain"

local function get_keys(tab)
    local keys = {}
    for k, v in pairs(tab) do
        table.insert(keys, k)
    end
    return keys
end

local function string_ends_with(str, ending)
    return ending == "" or str:sub(- #ending) == ending
end

local function round(num, idp)
    local mult = 10 ^ (idp or 0)
    local new = tostring(math.floor(num * mult + 0.5) / mult)
    -- if new ends in .0, remove it
    if string_ends_with(new, ".0") then
        return new:sub(1, -3)
    else
        return new
    end
end

local orig_stats = { max_speed = 0.07250, acceleration = 0.032, jump = 0.18, sprint_factor = 2.0 }

local settingsWindowOpen = false
register_option_button("open", "Open Chaos Mod settings", function()
    settingsWindowOpen = true
end)

local event_timer = 30
local countdown = true
local toast_event = false
local show_last_events = true

set_callback(function(save_ctx)
    local data = {
        options = {
            event_timer = event_timer,
            countdown = countdown,
            toast_event = toast_event,
            show_last_events = show_last_events
        }
    }
    save_ctx:save(json.encode(data))
end, ON.SAVE)

set_callback(function(load_ctx)
    local load_data = load_ctx:load()
    if load_data ~= "" then
        load_data = json.decode(load_data)
        event_timer = load_data.options.event_timer
        countdown = load_data.options.countdown
        toast_event = load_data.options.toast_event
        show_last_events = load_data.options.show_last_events
    end
end, ON.LOAD)

local events = require "events"
local names = get_keys(events.event_funcs)

local game = {}
game.frames_left = event_timer * 60
game.last_events = {}
game.last_event = ""
game.last_event_big = false

local function cause_random_event()
    if players[1].uid == -1 then
        return
    end
    local event_name = names[math.random(1, #names)]
    return events.event_funcs[event_name](players[1].uid)
end

set_callback(function(draw_ctx)
    if settingsWindowOpen then
        settingsWindowOpen = draw_ctx:window("Chaos Mod Settings", 0.0, 0.0, 0.0, 0.0, true, function()
            event_timer = draw_ctx:win_drag_int("Event Timer (seconds)", event_timer, 1, 300)
            show_last_events = draw_ctx:win_check("Show Last Events", show_last_events)
            toast_event = draw_ctx:win_check("Toast the Last Event", toast_event)
            countdown = draw_ctx:win_check("Show Event Timer", countdown)
        end)
    end
end, ON.GUIFRAME)


set_callback(function()
    if game.frames_left == 0 then
        local name = cause_random_event()
        game.last_event = name
        table.insert(game.last_events, 1, name)
        game.last_event_big = true
        set_timeout(function()
            game.last_event_big = false
            clear_callback()
        end, 180)
        if toast_event then
            toast(name)
        end
        game.frames_left = event_timer * 60
    end
end, ON.FRAME)

set_global_interval(function()
    if state.screen ~= SCREEN.LEVEL then return end
    if game_manager.pause_ui.visibility == PAUSEUI_VISIBILITY.VISIBLE then return end
    game.frames_left = game.frames_left - 1
end, 1)

set_callback(function(draw_ctx)
    if state.screen ~= SCREEN.LEVEL then return end
    if countdown then
        local w, _ = draw_text_size(30, tostring(round(game.frames_left / 60)))
        draw_ctx:draw_text(0 - w / 2, 1, 30, tostring(round(game.frames_left / 60)), 0xffffffff)
    end
    draw_ctx:draw_rect_filled(-1, -0.95, 1.0 - 2.0 * (game.frames_left / (event_timer * 60)), -1, 1, rgba(134, 43, 214, 255))
    if show_last_events then
        draw_ctx:draw_rect_filled(0.55, -0.65, 0.95, -0.55, 0, rgba(0, 0, 0, 255))
        draw_ctx:draw_rect_filled(0.55, -0.75, 0.95, -0.65, 0, rgba(0, 0, 0, 200))
        draw_ctx:draw_rect_filled(0.55, -0.85, 0.95, -0.75, 0, rgba(10, 10, 10, 200))
        draw_ctx:draw_rect_filled(0.55, -0.95, 0.95, -0.85, 0, rgba(0, 0, 0, 200))
        local w, _ = draw_text_size(25, "Past Events")
        draw_ctx:draw_text(0.75 - w / 2, -0.565, 25, "Past Events", 0xffffffff)
        for i, v in ipairs(game.last_events) do
            w, _ = draw_text_size(25, v)
            if i > 3 then
                game.last_events[i] = nil
                break
            end
            draw_ctx:draw_text(0.75 - w / 2, -0.56 - i * 0.1, 25, v, 0xffffffff)
        end
    else
        local text_size = 18
        local offset = 0.95
        for _, v in ipairs(players) do if v.state == 22 then return end end
        if game.last_event_big then
            text_size = 40
            offset = 0.87
        end
        local w, _ = draw_text_size(text_size, game.last_event)
        draw_ctx:draw_text(0 - w / 2, -1 * offset, text_size, tostring(game.last_event), 0xffffffff)
    end
end, ON.GUIFRAME)

set_callback(function()
    game.frames_left = event_timer * 60
end, ON.RESET)

set_callback(function()
    for _, v in ipairs(players) do
        v.type.max_speed = orig_stats.max_speed
        v.type.acceleration = orig_stats.acceleration
        v.type.jump = orig_stats.jump
        v.type.sprint_factor = orig_stats.sprint_factor
    end
end, ON.START)

set_callback(function()
    game.last_event_big = false
    zoom(13.5)
end, ON.TRANSITION)

register_console_command("trigger_event", function(name)
    local event_name = events.event_funcs[name](players[1].uid)
    table.insert(game.last_events, 1, event_name)
end)

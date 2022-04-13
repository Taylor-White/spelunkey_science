function say_override(uid, message, sound, top)
    cancel_speechbubble()
    set_timeout(function()    
        say(uid, message, sound, top)
    end, 1)
end
function toast_override(message)
    cancel_toast()
    set_timeout(function()    
        toast(message)
    end, 1)
end
function play_sound(snd)
    if snd ~= nil then snd:play(false, SOUND_TYPE.SFX) end
end
looped_sounds = {}
function play_looped_sound_at_entity(snd, uid) --thank you to malacath for this!!!
    local ent = get_entity(uid)
    local sound_loop = get_sound(snd)
    local audio = sound_loop:play(true)
    table.insert(looped_sounds, audio)
    -- The following for init and some update loop
    local x, y, _ = get_position(ent.uid)
    local sx, sy = screen_position(x, y)
    local d = screen_distance(distance(ent.uid, players[1].uid))
    audio:set_parameter(VANILLA_SOUND_PARAM.POS_SCREEN_X, sx)
    audio:set_parameter(VANILLA_SOUND_PARAM.DIST_CENTER_X, math.abs(sx))
    audio:set_parameter(VANILLA_SOUND_PARAM.DIST_CENTER_Y, math.abs(sy))
    audio:set_parameter(VANILLA_SOUND_PARAM.DIST_Z, 0.0)
    audio:set_parameter(VANILLA_SOUND_PARAM.DIST_PLAYER, d)
    audio:set_parameter(VANILLA_SOUND_PARAM.VALUE, 0.5)

    --stop the loop when the entity dies
    local sfx = set_on_kill(ent.uid, function() 
        audio:stop(true)
    end)
    
    -- unpause after init
    audio:set_pause(false)
end
function clamp(var, min, max)
    if var < min then
        return min
    end
    if var > max then
        return max
    end
    return var
end
function clear_looped_sounds()
    for _, audio in ipairs(looped_sounds) do
        audio:stop(true)
    end
    looped_sounds = {}
end
set_callback(clear_looped_sounds, ON.TRANSITION)
set_callback(clear_looped_sounds, ON.PRE_LEVEL_GENERATION)

function play_vanilla_sound(snd, volume)
    local sound = get_sound(snd)
    if sound ~= nil then playing_sound = sound:play(false, SOUND_TYPE.SFX) end
    if volume ~= nil then
        playing_sound:set_volume(volume)
    end
end
function spawn_floor(uid, x, y, l, xvel, yvel) 
    local floor = get_entity(spawn(uid, x, y+2, l, xvel, yvel))
    floor:fix_decorations(true, true)
    return floor
end
function shake_camera(countdown_start, countdown, amplitude, multiplier_x, multiplier_y, uniform_shake)
    state.camera.shake_countdown_start = countdown_start
    state.camera.shake_countdown = countdown
    state.camera.shake_amplitude = amplitude
    state.camera.shake_multiplier_x = multiplier_x
    state.camera.shake_multiplier_y = multiplier_y
    state.camera.uniform_shake = uniform_shake
end

local custom_music = {}
custom_music.current_music = nil --object that plays the custom music
custom_music.playing_music = nil
custom_music.current_volume = 1 --current volume the music is playing at

custom_music.volume_is_changing = false
custom_music.desired_volume = 1 --volume you want the music to be player at
custom_music.volume_change_rate = 0.01
custom_music.volume_direction = 1 -- -1 would make the volume decrease

function custom_music.set_volume_instant(volume)
    custom_music.desired_volume = volume
    custom_music.current_volume = volume
end
function custom_music.set_music(file_path)
    return create_sound(file_path)
end
function custom_music.play_music()
    if custom_music.current_music ~= nil and options.enable_custom_music == true then
        custom_music.playing_music = custom_music.current_music:play()
        custom_music.playing_music:set_looping(SOUND_LOOP_MODE.LOOP)
    end
end
function custom_music.stop_music()
    if custom_music.playing_music ~= nil and options.enable_custom_music == true  then
        custom_music.playing_music:stop()
        custom_music.playing_music = nil
    end
end
function custom_music.set_volume(volume, rate)
    if volume >= 0 and volume <= 1 then
        custom_music.desired_volume = volume
    else
        message("volume can only be between 0 and 1!")
    end

    custom_music.volume_change_rate = rate
end

--set music variables
set_callback(function()
    --manage volume
    if custom_music.current_volume ~= custom_music.desired_volume then
        if custom_music.desired_volume > custom_music.current_volume then
            if custom_music.current_volume + custom_music.volume_change_rate > custom_music.desired_volume then
                custom_music.current_volume = custom_music.desired_volume
            else
                custom_music.current_volume = custom_music.current_volume + custom_music.volume_change_rate
            end
        end
        if custom_music.desired_volume < custom_music.current_volume then
            if custom_music.current_volume - custom_music.volume_change_rate < custom_music.desired_volume then
                custom_music.current_volume = custom_music.desired_volume
            else
                custom_music.current_volume = custom_music.current_volume - custom_music.volume_change_rate
            end
        end
    end
    --update the volume
    if custom_music.playing_music ~= nil and options.enable_custom_music == true then
        custom_music.playing_music:set_volume(custom_music.current_volume)
    end
    --change music volume when paused
    if state.pause == 1 and state.ingame == 1 and state.screen ~= 13 then
        custom_music.set_volume(shopkeeper_slaughter.default_music_volume/5, 0.01)
    end
    if state.pause == 0 and state.ingame == 1 and state.screen ~= 13 then
        custom_music.set_volume(shopkeeper_slaughter.default_music_volume, 0.01)
    end
end, ON.GUIFRAME)
--set music again on gui frame to account for people with higher refresh rate monitors
set_callback(function()
    --update the volume
    if custom_music.playing_music ~= nil and options.enable_custom_music == true then
        custom_music.playing_music:set_volume(custom_music.current_volume)
    end
end, ON.GUIFRAME)

return custom_music
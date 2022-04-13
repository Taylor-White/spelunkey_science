boss_levels = {8}
shop_levels = {4, 9}
jungle_start = 10
music_change_levels = {4, 8, 9, 10, 11} --floors where after you clear them the music goes silent on the transition

endofdemo_level = 10

require "level_gen/determine_floor"
require "level_gen/exit_key"

set_callback(function(room_gen_ctx)
    if state.theme == THEME.DWELLING and level_type == "DEFAULT" then
        generate_floor.dwelling(room_gen_ctx)
    elseif state.theme == THEME.DWELLING and level_type == "BOSS" then
        generate_floor.quillback(room_gen_ctx)
    end
end, ON.POST_ROOM_GENERATION)
function reset_music_change_levels()
    music_change_levels = {4, 8, 9, 10, 11}
end

set_callback(reset_music_change_levels, ON.RESET)
set_callback(reset_music_change_levels, ON.DEATH)
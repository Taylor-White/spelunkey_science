
local generate_floor = {
    layout_x = {};
    layout_y = {};
    path_length = 8;
    room_width = 8;
    room_height = 8;
    path_x1 = 8;
    path_x2 = 8;
    path_y1 = 8;
    path_y2 = 8;
    layout = {};
    bonus_room_up = {};
    bonus_room_down = {};
    bonus_room_left = {};
    bonus_room_right = {};
}
function generate_floor.reset_layout()
    for i = 1, 8 do
        generate_floor.layout[i] = {}
        for j = 1, 8 do
            generate_floor.layout[i][j] = 0
        end
    end
    for i = 1, 8 do
        generate_floor.bonus_room_up[i] = {}
        generate_floor.bonus_room_down[i] = {}
        generate_floor.bonus_room_left[i] = {}
        generate_floor.bonus_room_right[i] = {}
        for j = 1, 8 do
            generate_floor.bonus_room_up[i][j] = 0
            generate_floor.bonus_room_down[i][j] = 0
            generate_floor.bonus_room_left[i][j] = 0
            generate_floor.bonus_room_right[i][j] = 0
        end
    end
end
function generate_floor.side()
    --this should be run after generating generate_floor.layout
    --take the width to set the layout
    --give each room a chance to become a side room, but only if its connected to the main layout
    for i = 1, 8 do
        for j = 1, 8 do
            local iup = i+1
            local idown = i-1
            local jup = j+1
            local jdown = j-1
            if iup > 8 then iup = 8 end
            if idown < 1 then idown = 1 end
            if jup > 8 then jup = 8 end
            if jdown < 1 then jdown = 1 end
            if math.random(3) == 1 then
                if (generate_floor.layout[i][j] == 0) and (generate_floor.layout[iup][j] == 1 or generate_floor.layout[idown][j] == 1 or generate_floor.layout[i][jup] == 1 or generate_floor.layout[i][jdown] == 1) then
                    if generate_floor.layout[iup][j] == 1 then --room to the left (connects to right)
                        generate_floor.bonus_room_left[i][j] = 1
                    end
                    if generate_floor.layout[idown][j] == 1 then --room to the right (connects to left)
                        generate_floor.bonus_room_right[i][j] = 1
                    end
                    if generate_floor.layout[i][jup] == 1 then --room above (connects to bottom)
                        generate_floor.bonus_room_up[i][j] = 1
                    end
                    if generate_floor.layout[i][jdown] == 1 then --room below (connects to above)
                        generate_floor.bonus_room_down[i][j] = 1
                    end
                end
            end
        end
    end
end
function generate_floor.path(type) --MAKE MORE OF THESE
    generate_floor.reset_layout()
    if type == "WAVY" then
        --define the grid as a 8x8 array
        for i = 1, 8 do
            generate_floor.layout[i] = {}
            for j = 1, 8 do
                generate_floor.layout[i][j] = 0
            end
        end
        local roll = math.random(8)
        if roll == 1 then --straight with a tip
            generate_floor.layout[3][3] = 1
            generate_floor.layout[4][3] = 1
            generate_floor.layout[5][3] = 1
            generate_floor.layout[6][3] = 1
            generate_floor.layout[6][2] = 1
            generate_floor.layout[6][4] = 1
            generate_floor.path_length = 6
            generate_floor.room_width = 8
            generate_floor.room_height = 8
        end
        if roll == 2 then --"bone" shape
            generate_floor.layout[3][3] = 1
            generate_floor.layout[3][2] = 1
            generate_floor.layout[3][4] = 1
            generate_floor.layout[4][3] = 1
            generate_floor.layout[5][3] = 1
            generate_floor.layout[6][3] = 1
            generate_floor.layout[6][2] = 1
            generate_floor.layout[6][4] = 1
            generate_floor.path_length = 8
            generate_floor.room_width = 8
            generate_floor.room_height = 8
        end
        if roll == 3 then --square middle with two ends, left is lower right is upper
            generate_floor.layout[4][3] = 1
            generate_floor.layout[3][3] = 1
            generate_floor.layout[4][2] = 1
            generate_floor.layout[3][2] = 1
            generate_floor.layout[2][3] = 1
            generate_floor.layout[5][2] = 1
            generate_floor.layout[6][2] = 1
            generate_floor.path_length = 7
            generate_floor.room_width = 8
            generate_floor.room_height = 8
        end
        if roll == 4 then --2x6
            generate_floor.layout[3][2] = 1
            generate_floor.layout[3][3] = 1
            generate_floor.layout[3][4] = 1
            generate_floor.layout[3][5] = 1
            generate_floor.layout[3][6] = 1
            generate_floor.layout[3][7] = 1
            generate_floor.layout[4][2] = 1
            generate_floor.layout[4][3] = 1
            generate_floor.layout[4][4] = 1
            generate_floor.layout[4][5] = 1
            generate_floor.layout[4][6] = 1
            generate_floor.layout[4][7] = 1
            generate_floor.path_length = 12
            generate_floor.room_width = 8
            generate_floor.room_height = 8
        end
        if roll == 5 then --2x2
            generate_floor.layout[3][3] = 1
            generate_floor.layout[3][4] = 1
            generate_floor.layout[4][3] = 1
            generate_floor.layout[4][4] = 1
            generate_floor.path_length = 4
            generate_floor.room_width = 8
            generate_floor.room_height = 8
        end
        if roll == 6 then --DONUTDONUTDONUTDONUTDONUTDONUTDONUTDONUTDONUTDONUTDONUTDONUTDONUTDONUTDONUTDONUTDONUTDONUT
            generate_floor.layout[3][5] = 1
            generate_floor.layout[4][5] = 1
            generate_floor.layout[5][5] = 1
            generate_floor.layout[5][4] = 1
            generate_floor.layout[5][3] = 1
            generate_floor.layout[4][3] = 1
            generate_floor.layout[3][3] = 1
            generate_floor.layout[3][4] = 1
            generate_floor.path_length = 8
            generate_floor.room_width = 8
            generate_floor.room_height = 8
        end
        if roll == 7 then --squiggly
            generate_floor.layout[3][5] = 1
            generate_floor.layout[3][4] = 1
            generate_floor.layout[4][4] = 1
            generate_floor.layout[5][4] = 1
            generate_floor.layout[5][5] = 1
            generate_floor.layout[6][5] = 1
            generate_floor.layout[7][5] = 1
            generate_floor.layout[7][4] = 1
            generate_floor.layout[7][3] = 1
            generate_floor.path_length = 9
            generate_floor.room_width = 8
            generate_floor.room_height = 8
        end
        if roll == 8 then --v shape
            generate_floor.layout[3][5] = 1
            generate_floor.layout[4][5] = 1
            generate_floor.layout[4][6] = 1
            generate_floor.layout[5][6] = 1
            generate_floor.layout[6][6] = 1
            generate_floor.layout[6][5] = 1
            generate_floor.layout[5][5] = 1
            generate_floor.layout[6][5] = 1
            generate_floor.path_length = 8
            generate_floor.room_width = 8
            generate_floor.room_height = 8
        end
        if roll == 9 then --donut with a hole,, so really a spiral
            generate_floor.layout[3][3] = 1
            generate_floor.layout[2][3] = 1
            generate_floor.layout[3][2] = 1
            generate_floor.layout[2][2] = 1
            generate_floor.layout[1][3] = 1
            generate_floor.layout[4][2] = 1
            generate_floor.layout[5][2] = 1
            generate_floor.path_length = 7
            generate_floor.room_width = 8
            generate_floor.room_height = 8
        end
        if roll == 10 then --dumbbell
            generate_floor.layout[2][2] = 1
            generate_floor.layout[2][3] = 1
            generate_floor.layout[3][2] = 1
            generate_floor.layout[3][3] = 1
            generate_floor.path_length = 4
            generate_floor.room_width = 8
            generate_floor.room_height = 8
        end
        if roll == 11 then --sticking out
            generate_floor.layout[2][3] = 1
            generate_floor.layout[3][3] = 1
            generate_floor.layout[2][4] = 1
            generate_floor.layout[3][4] = 1
            generate_floor.layout[4][3] = 1
            generate_floor.layout[5][3] = 1
            generate_floor.path_length = 6
            generate_floor.room_width = 8
            generate_floor.room_height = 8
        end
    end
end
function generate_floor.fill_adjacent_rooms_with_floor(room_gen_ctx, x, y)
    for i = -1, 1, 1 do
        for j = -1, 1, 1 do
            local cx = clamp(x+i, 1, 8)
            local cy = clamp(y+j, 1, 8)
            if generate_floor.layout[cx][cy] == 0 and generate_floor.bonus_room_left[cx][cy] == 0 and generate_floor.bonus_room_right[cx][cy] == 0 and generate_floor.bonus_room_up[cx][cy] == 0 and generate_floor.bonus_room_down[cx][cy] == 0 then
                room_gen_ctx:set_room_template(cx, cy, 0, ROOM_TEMPLATE.ALTAR)
            end
        end
    end
end
function generate_floor.dwelling(room_gen_ctx)
    --generate a room layout
    generate_floor.path("WAVY")
    generate_floor.side()
    --set room dimensions
    state.width = generate_floor.room_width
    state.height = generate_floor.room_height
    --generate an entrance and exit room
    local entrance_index = math.random(1, generate_floor.path_length)
    local exit_index = math.random(1, generate_floor.path_length)
    while exit_index == entrance_index do
        exit_index = math.random(1, generate_floor.path_length)
    end
    --fill all rooms
    for i = 0, state.width-1, 1 do
        for j = 0, state.height-1, 1 do
            room_gen_ctx:set_room_template(i, j, 0, ROOM_TEMPLATE.CURIOSHOP)
        end
    end
    --set the rooms
    local set_room_count = 1
    for i = 1, generate_floor.room_width, 1 do
        for j = 1, generate_floor.room_height, 1 do
            if generate_floor.layout[i][j] == 1 then --main rooms
                if set_room_count == entrance_index then
                    room_gen_ctx:set_room_template(i, j, 0, ROOM_TEMPLATE.ENTRANCE)        
                elseif set_room_count == exit_index then
                    room_gen_ctx:set_room_template(i, j, 0, ROOM_TEMPLATE.EXIT)
                else
                    room_gen_ctx:set_room_template(i, j, 0, ROOM_TEMPLATE.SIDE)
                end
                set_room_count = set_room_count + 1
                generate_floor.fill_adjacent_rooms_with_floor(room_gen_ctx, i, j)
            end
            if generate_floor.bonus_room_left[i][j] == 1 then --side rooms
                room_gen_ctx:set_room_template(i, j, 0, ROOM_TEMPLATE.IDOL)
                if math.random(2) == 1 then
                    room_gen_ctx:set_room_template(i, j, 0, ROOM_TEMPLATE.SIDE)
                end
                generate_floor.fill_adjacent_rooms_with_floor(room_gen_ctx, i, j)
            end
            if generate_floor.bonus_room_right[i][j] == 1 then --side rooms
                if math.random(5) == 1 and beg_shop_spawned == false and beg_angry == false then
                    beg_shop_spawned = true
                    room_gen_ctx:set_room_template(i, j, 0, ROOM_TEMPLATE.VAULT)
                else
                    room_gen_ctx:set_room_template(i, j, 0, ROOM_TEMPLATE.IDOL_TOP)   
                end
                generate_floor.fill_adjacent_rooms_with_floor(room_gen_ctx, i, j)
            end
            if generate_floor.bonus_room_up[i][j] == 1 then --side rooms
                room_gen_ctx:set_room_template(i, j, 0, ROOM_TEMPLATE.COFFIN_PLAYER)
                if math.random(2) == 1 then
                    room_gen_ctx:set_room_template(i, j, 0, ROOM_TEMPLATE.SIDE)    
                end
                generate_floor.fill_adjacent_rooms_with_floor(room_gen_ctx, i, j)
            end
            if generate_floor.bonus_room_down[i][j] == 1 then --side rooms
                room_gen_ctx:set_room_template(i, j, 0, ROOM_TEMPLATE.COFFIN_PLAYER_VERTICAL)
                if math.random(2) == 1 then
                    room_gen_ctx:set_room_template(i, j, 0, ROOM_TEMPLATE.SIDE)   
                end
                generate_floor.fill_adjacent_rooms_with_floor(room_gen_ctx, i, j)
            end
        end
    end
    --clear the layout for the next level
    generate_floor.reset_layout()
end
function generate_floor.quillback(room_gen_ctx)
    state.width = 3
    state.height = 5
    --ALTAR ROOMS ARE COMPLETELY SOLID ROOMS
    room_gen_ctx:set_room_template(0, 0, 0, ROOM_TEMPLATE.ALTAR)
    room_gen_ctx:set_room_template(2, 0, 0, ROOM_TEMPLATE.ALTAR)
    room_gen_ctx:set_room_template(0, 1, 0, ROOM_TEMPLATE.ALTAR)
    room_gen_ctx:set_room_template(2, 1, 0, ROOM_TEMPLATE.ALTAR)
    room_gen_ctx:set_room_template(0, 2, 0, ROOM_TEMPLATE.ALTAR)
    room_gen_ctx:set_room_template(2, 2, 0, ROOM_TEMPLATE.ALTAR)
    room_gen_ctx:set_room_template(0, 2, 0, ROOM_TEMPLATE.ALTAR)
    room_gen_ctx:set_room_template(2, 3, 0, ROOM_TEMPLATE.ALTAR)
    room_gen_ctx:set_room_template(0, 3, 0, ROOM_TEMPLATE.ALTAR)

    --ENTRANCE
    room_gen_ctx:set_room_template(1, 0, 0, ROOM_TEMPLATE.ENTRANCE_DROP)

    --DESCEND
    room_gen_ctx:set_room_template(1, 1, 0, ROOM_TEMPLATE.POSSE)
    room_gen_ctx:set_room_template(1, 2, 0, ROOM_TEMPLATE.POSSE)
    room_gen_ctx:set_room_template(1, 3, 0, ROOM_TEMPLATE.POSSE)
    --ARENA
    room_gen_ctx:set_room_template(1, 4, 0, ROOM_TEMPLATE.QUEST_THIEF1)
    --ARENA PLATFORMS
    room_gen_ctx:set_room_template(0, 4, 0, ROOM_TEMPLATE.QUEST_THIEF1)
    room_gen_ctx:set_room_template(2, 4, 0, ROOM_TEMPLATE.QUEST_THIEF1)   
end

return generate_floor

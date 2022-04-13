
local BUTTONS = {
    JUMP = 1;
    ATTACK = 2;
    BOMB = 3;
    ROPE = 4;
    RUN = 5;
    BUY = 6;
    PAUSE = 7;
    JOURNAL = 8;
    LEFT = 9;
    RIGHT = 10;
    UP = 11;
    DOWN = 12;
}
local input_check = {
    --the x_enable variables are used to check if an input has already been pressed (therefore creating the 'pressed' event)
    --[[
    _pressed is true on the frame a button is first pressed
    _enable is used to determine _pressed
    _held is true when an input is currently held
    _released is true when an input is released
    ]]
    player_1 = {
        left_pressed = false;
        left_enable = false;
        left_held = false;
        left_released = false;

        right_pressed = false;
        right_enable = false;
        right_held = false;
        right_released = false;

        up_pressed = false;
        up_enable = false;
        up_held = false;
        up_released = false;

        down_pressed = false;
        down_enable = false;
        down_held = false;
        down_released = false;
        
        jump_pressed = false;
        jump_enable = false; 
        jump_held = false;
        jump_released = false;

        attack_pressed = false;
        attack_enable = false;
        attack_held = false;
        attack_released = false;

        bomb_pressed = false;
        bomb_enable = false; 
        bomb_held = false;
        bomb_released = false;

        rope_pressed = false;
        rope_enable = false; 
        rope_held = false;
        rope_released = false;

        run_pressed = false;
        run_enable = false;
        run_held = false;
        run_released = false;

        buy_pressed = false;
        buy_enable = false;
        buy_held = false;
        buy_released = false;

        pause_pressed = false;
        pause_enable = false;
        pause_held = false;
        pause_released = false;

        journal_pressed = false;
        journal_enable = false;
        journal_held = false;
        journal_released = false;
    };
    player_2 = {
        left_pressed = false;
        left_enable = false;
        left_held = false;
        left_released = false;

        right_pressed = false;
        right_enable = false;
        right_held = false;
        right_released = false;

        up_pressed = false;
        up_enable = false;
        up_held = false;
        up_released = false;

        down_pressed = false;
        down_enable = false;
        down_held = false;
        down_released = false;
        
        jump_pressed = false;
        jump_enable = false; 
        jump_held = false;
        jump_released = false;

        attack_pressed = false;
        attack_enable = false;
        attack_held = false;
        attack_released = false;

        bomb_pressed = false;
        bomb_enable = false; 
        bomb_held = false;
        bomb_released = false;

        rope_pressed = false;
        rope_enable = false; 
        rope_held = false;
        rope_released = false;

        run_pressed = false;
        run_enable = false;
        run_held = false;
        run_released = false;

        buy_pressed = false;
        buy_enable = false;
        buy_held = false;
        buy_released = false;

        pause_pressed = false;
        pause_enable = false;
        pause_held = false;
        pause_released = false;

        journal_pressed = false;
        journal_enable = false;
        journal_held = false;
        journal_released = false;
    };
    player_3 = {
        left_pressed = false;
        left_enable = false;
        left_held = false;
        left_released = false;

        right_pressed = false;
        right_enable = false;
        right_held = false;
        right_released = false;

        up_pressed = false;
        up_enable = false;
        up_held = false;
        up_released = false;

        down_pressed = false;
        down_enable = false;
        down_held = false;
        down_released = false;
        
        jump_pressed = false;
        jump_enable = false; 
        jump_held = false;
        jump_released = false;

        attack_pressed = false;
        attack_enable = false;
        attack_held = false;
        attack_released = false;

        bomb_pressed = false;
        bomb_enable = false; 
        bomb_held = false;
        bomb_released = false;

        rope_pressed = false;
        rope_enable = false; 
        rope_held = false;
        rope_released = false;

        run_pressed = false;
        run_enable = false;
        run_held = false;
        run_released = false;

        buy_pressed = false;
        buy_enable = false;
        buy_held = false;
        buy_released = false;

        pause_pressed = false;
        pause_enable = false;
        pause_held = false;
        pause_released = false;

        journal_pressed = false;
        journal_enable = false;
        journal_held = false;
        journal_released = false;
    };
    player_4 = {
        left_pressed = false;
        left_enable = false;
        left_held = false;
        left_released = false;

        right_pressed = false;
        right_enable = false;
        right_held = false;
        right_released = false;

        up_pressed = false;
        up_enable = false;
        up_held = false;
        up_released = false;

        down_pressed = false;
        down_enable = false;
        down_held = false;
        down_released = false;
        
        jump_pressed = false;
        jump_enable = false; 
        jump_held = false;
        jump_released = false;

        attack_pressed = false;
        attack_enable = false;
        attack_held = false;
        attack_released = false;

        bomb_pressed = false;
        bomb_enable = false; 
        bomb_held = false;
        bomb_released = false;

        rope_pressed = false;
        rope_enable = false; 
        rope_held = false;
        rope_released = false;

        run_pressed = false;
        run_enable = false;
        run_held = false;
        run_released = false;

        buy_pressed = false;
        buy_enable = false;
        buy_held = false;
        buy_released = false;

        pause_pressed = false;
        pause_enable = false;
        pause_held = false;
        pause_released = false;

        journal_pressed = false;
        journal_enable = false;
        journal_held = false;
        journal_released = false;
    };
}
set_global_interval(function()
    --check inputs
    for i, v in ipairs(players) do
        --determine which player slot to check
        local player_slot = state.player_inputs.player_slot_1
        if i == 2 then
            player_slot = state.player_inputs.player_slot_2
        elseif i == 3 then
            player_slot = state.player_inputs.player_slot_3
        elseif i == 4 then
            player_slot = state.player_inputs.player_slot_4
        end
        --left held
        if test_flag(player_slot.buttons, BUTTONS.LEFT) then
            if i == 1 then
                input_check.player_1.left_held = true
            elseif i == 2 then
                input_check.player_2.left_held = true
            elseif i == 3 then
                input_check.player_3.left_held = true
            elseif i == 4 then
                input_check.player_4.left_held = true
            end
        else
            if i == 1 then
                input_check.player_1.left_held = false
            elseif i == 2 then
                input_check.player_2.left_held = false
            elseif i == 3 then
                input_check.player_3.left_held = false
            elseif i == 4 then
                input_check.player_4.left_held = false
            end
        end
    end
end, 1)
return input_check
meta = {
    name = "Elite Trio Idle",
    author = "Malacath & LightningFire",
    description = "Enables the idle animation for the Elite Trio.",
    version = "1.0"
}

local chair_types = {[ENT_TYPE.MOUNT_BASECAMP_CHAIR] = true, [ENT_TYPE.MOUNT_BASECAMP_COUCH] = true}
local idle_state_conditions = {
    standing = function(ply)
        return ply.state == CHAR_STATE.STANDING and ply.standing_on_uid ~= -1 and ply.holding_uid == -1 and ply.movex == 0 and ply.movey == 0
    end,
    holding = function(ply)
        return ply.standing_on_uid ~= -1 and ply.holding_uid ~= -1 and ply.movex == 0 and ply.movey == 0
    end,
    hanging = function(ply)
        return ply.state == CHAR_STATE.HANGING
    end,
    ducking = function(ply)
        return ply.standing_on_uid ~= -1 and ply.movex == 0 and ply.movey < 0
    end,
    looking_up = function(ply)
        return ply.standing_on_uid ~= -1 and ply.movex == 0 and ply.movey > 0
    end,
    sitting = function(ply)
        return ply.state == CHAR_STATE.SITTING and ((ply.movex == 0 and ply.movey == 0) or chair_types[ply.overlay.type.id]) and get_velocity(ply.uid) == 0
    end,
    sitting_ducking = function(ply)
        return ply.state == CHAR_STATE.SITTING and ply.movex == 0 and ply.movey < 0 and ply.overlay and not chair_types[ply.overlay.type.id] and get_velocity(ply.uid) == 0
    end,
    sitting_looking_up = function(ply)
        return ply.state == CHAR_STATE.SITTING and ply.movex == 0 and ply.movey > 0 and ply.overlay and not chair_types[ply.overlay.type.id] and get_velocity(ply.uid) == 0
    end,
    climbing_rope = function(ply)
        return ply.state == CHAR_STATE.CLIMBING and ply.movey == 0 and ply.overlay and (ply.overlay.type.search_flags & MASK.ROPE)
    end,
    climbing_ladder = function(ply)
        return ply.state == CHAR_STATE.CLIMBING and ply.movey == 0 and ply.overlay and not (ply.overlay.type.search_flags & MASK.ROPE)
    end,
}

-- Valid entity types
--[[
  CHAR_AMAZON
  CHAR_ANA_SPELUNKY
  CHAR_AU
  CHAR_BANDA
  CHAR_CLASSIC_GUY
  CHAR_COCO_VON_DIAMONDS
  CHAR_COLIN_NORTHWARD
  CHAR_DEMI_VON_DIAMONDS
  CHAR_DIRK_YAMAOKA
  CHAR_EGGPLANT_CHILD
  CHAR_GREEN_GIRL
  CHAR_GUY_SPELUNKY
  CHAR_HIREDHAND
  CHAR_LISE_SYSTEM
  CHAR_MANFRED_TUNNEL
  CHAR_MARGARET_TUNNEL
  CHAR_OTAKU
  CHAR_PILOT
  CHAR_PRINCESS_AIRYN
  CHAR_ROFFY_D_SLOTH
  CHAR_TINA_FLAN
  CHAR_VALERIE_CRUMP
  CHAR_HIREDHAND
  CHAR_EGGPLANT_CHILD
]]

-- Add one element for each character you add idle animations for 
local idle_animation_definitions = {
    [ENT_TYPE.CHAR_GREEN_GIRL] = {
        standing = {  -- the state name has to match the names in `idle_state_conditions` on line 9
            idle_timer = 4,  -- how many frames of idling in this state before playing the animation, 60 frames is a second
            npc_idle_timer = 60,  -- same thing but for NPCs, i.e. in camp, unlocked chars, hired hands and eggplant child
            start_frame = 3,  -- the first sprite of the animation, start counting at 0 from the top-left
            length = 47,  -- how many sprites there are in this animation
            interval = 4  -- how many frames a sprite lasts
        },
        standing_transition = {  -- add _transition to introduce a transition into the idle animation
            idle_timer = 4,
            npc_idle_timer = 60,
            start_frame = 0,
            length = 4,
            interval = 4
        },
    }
}

-- If the idle animation relies on a new texture add it here
local extra_textures = {
    [ENT_TYPE.CHAR_GREEN_GIRL] = {
        TEXTURE.DATA_TEXTURES_CHAR_GREEN_0,  -- first the original texture to swap back to when done
        (function()
            local def = TextureDefinition.new()
            def.texture_path = 'res/elitetrio_extra_texture.png'  -- then the new texture
            def.width = 2048  -- size of the image
            def.height = 512
            def.tile_width = 128  -- size of each frame
            def.tile_height = 128  -- should be square for best results
            return define_texture(def)
        end)()
    }
}

local char_timers = {}
local char_did_transition = {}
local char_state_counters = {}
set_callback(function()
    char_timers = {}
    char_did_transition = {}
    char_state_counters = {}
end, ON.PRE_LEVEL_GENERATION)

local ropes = {}
local player_drops = {}

local function is_transition(state_name)
    local ending = '_transition'
    return state_name:sub(-#ending) == ending
end
local function name_from_transition(state_name)
    local ending = '_transition'
    return state_name:sub(1, #state_name - #ending)
end

local function is_player(uid)
    for _, player in pairs(players) do
        if player and player.uid == uid then
            return true
        end
    end
    return false
end

set_post_entity_spawn(function(entity)
    local anims_def = idle_animation_definitions[entity.type.id]
    if anims_def ~= nil then
        char_timers[entity.uid] = 0
        char_state_counters[entity.uid] = {}

        local extra_texture = extra_textures[entity.type.id]
        set_post_statemachine(entity.uid, function(movable)
            if extra_texture then
                if movable:is_button_pressed(BUTTON.WHIP) then
                    for _, whip_type in pairs({ ENT_TYPE.ITEM_WHIP, ENT_TYPE.ITEM_WHIP_FLAME }) do
                        local whips = entity_get_items_by(movable.uid, whip_type, 0)
                        for _, uid in pairs(whips) do
                            local whip = get_entity(uid)
                            if whip then
                                whip:set_texture(extra_texture[1])
                            end
                        end
                    end
                end

                if movable:is_button_pressed(BUTTON.ROPE) then
                    for i, uid in pairs(ropes) do
                        local rope = get_entity(uid)
                        if rope.last_owner_uid == movable.uid then
                            rope:set_texture(extra_texture[1])
                            table.remove(ropes, i)
                        end
                    end
                end

                for i, uid in pairs(player_drops) do
                    local player_bag = get_entity(uid)
                    if player_bag then
                        if player_bag:get_texture() == extra_texture[2] then
                            player_bag:set_texture(extra_texture[1])
                            table.remove(player_drops, i)
                        elseif player_bag:get_texture() == extra_texture[1] then
                            table.remove(player_drops, i)
                        end
                    end
                end
            end

            local is_in_any_idle_state = false
            for state_name, anim_data in pairs(anims_def) do
                local transition = is_transition(state_name)
                local state = transition and name_from_transition(state_name) or state_name

                local is_in_state = idle_state_conditions[state](movable)
                local idle_counter
                if is_in_state then
                    idle_counter = char_state_counters[entity.uid][state]
                    idle_counter = idle_counter and idle_counter + 1 or 1
                    char_state_counters[entity.uid][state] = idle_counter
                else
                    idle_counter = 0
                    char_state_counters[entity.uid][state] = 0
                end

                local idle_timer = is_player(movable.uid) and anim_data.idle_timer or anim_data.npc_idle_timer

                local should_play = movable.health > 0 and
                    not is_in_any_idle_state
                    and idle_counter > idle_timer
                    and not movable:is_button_pressed(BUTTON.ROPE)
                    and is_in_state

                local has_transition = anims_def[state .. '_transition']
                if should_play and has_transition then
                    local transition_condition = (not transition and char_did_transition[entity.uid])
                        or (transition and not char_did_transition[entity.uid])
                    should_play = should_play and transition_condition
                end

                if should_play then
                    local timer = char_timers[entity.uid]
                    if timer > 0 then
                        movable.animation_frame = anim_data.start_frame
                        movable.animation_frame = movable.animation_frame + ((timer - 1) // anim_data.interval) % anim_data.length

                        if extra_texture and extra_texture[2] ~= movable:get_texture() then
                            movable:set_texture(extra_texture[2])
                        end

                        if transition then
                            local num_ticks_in_animation = anim_data.interval * anim_data.length
                                if timer == num_ticks_in_animation then
                                timer = 0
                                char_timers[entity.uid] = 0
                                char_did_transition[entity.uid] = true
                            end
                        end
                    end

                    char_timers[entity.uid] = timer + 1
                    is_in_any_idle_state = true
                end
            end

            if char_timers[entity.uid] > 0 and not is_in_any_idle_state then
                char_timers[entity.uid] = 0
                char_did_transition[entity.uid] = false

                if extra_texture then
                    movable:set_texture(extra_texture[1])
                end
            end
        end)
    end
end, SPAWN_TYPE.ANY, MASK.PLAYER)

set_post_entity_spawn(function(rope)
    table.insert(ropes, rope.uid)
end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_ROPE)

set_post_entity_spawn(function(player_bag)
    table.insert(player_drops, player_bag.uid)
end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_PICKUP_PLAYERBAG, ENT_TYPE.ITEM_PLAYERGHOST)
set_callback(function()
    player_drops = {}
end, ON.LEVEL)

set_post_entity_spawn(function(birdies)
    if birdies.overlay then
        local extra_texture = extra_textures[birdies.overlay.type.id]
        if extra_texture then
            birdies:set_texture(extra_texture[1])
        end
    end
end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.FX_BIRDIES)


----------------------------------------------------------------------------------------------------------
-- Debug Stuff
----------------------------------------------------------------------------------------------------------
local debug_draw_callback_id
register_console_command("idle_animation_enable_debug_draw", function()
    if debug_draw_callback_id == nil then
        debug_draw_callback_id = set_callback(function(draw_ctx)
            for _, ply in pairs(players) do
                for name, test in pairs(idle_state_conditions) do
                    if test(ply) then
                        local x, y, l = get_render_position(ply.uid)
                        local sx, sy = screen_position(x, y + ply.hitboxy + ply.offsety)
                        local tx, ty = draw_text_size(35, name)
                        draw_ctx:draw_text(sx - tx / 2, sy - ty * 2, 35, name, rgba(255, 255, 255, 255))
                    end
                end
            end
        end, ON.GUIFRAME)
    end
end)
register_console_command("idle_animation_disable_debug_draw", function()
    if debug_draw_callback_id ~= nil then
        clear_callback(debug_draw_callback_id)
        debug_draw_callback_id = nil
    end
end)
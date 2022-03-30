meta = {
    name = 'Spelunker Puzzles',
    version = '1.0',
    description = 'Puzzle levels to test your Spelunky IQ',
    author = 'JawnGC',
}

register_option_int("level_selected", "Level number for shortcut door (1 to 6)", 1, 1, 6)

local level_sequence = require("LevelSequence/level_sequence")
local telescopes = require("Telescopes/telescopes")
local DIFFICULTY = require('difficulty')
local SIGN_TYPE = level_sequence.SIGN_TYPE
local save_state = require('save_state')

local update_continue_door_enabledness
local force_save
local save_data
local save_context

--Dwelling Levels
local dwelling1 = require("dwelling1")
local dwelling2 = require("dwelling2")
local dwelling3 = require("dwelling3")

--Volcana Levels
local volcana1 = require("volcana1")
local volcana2 = require("volcana2")

--Jungle Levels
local jungle1 = require("jungle1")


--Set level order
levels = {dwelling1, dwelling2, dwelling3, volcana1, volcana2, jungle1}
level_sequence.set_levels(levels)

--Do not spawn Ghost
set_ghost_spawn_times(-1, -1)

set_post_entity_spawn(function(entity) 
	entity.flags = clr_flag(entity.flags, 22) 
end, SPAWN_TYPE.ANY, MASK.ITEM, nil)

set_callback(function()
    if state.loading == 1 and state.screen_next == SCREEN.TRANSITION then
        for _, p in ipairs(players) do
            for _, v in ipairs(p:get_powerups()) do
                p:remove_powerup(v)
            end
        end
    end
end, ON.LOADING)

--ON/OFF Switches
switch_hit = false
off = true

define_tile_code("on_off_switch")
switches = {}
set_pre_tile_code_callback(function(x, y, layer)
	local block_id = spawn(ENT_TYPE.ITEM_SLIDINGWALL_SWITCH, x, y, layer, 0, 0)
	switches[#switches + 1] = get_entity(block_id)
	switches[#switches].color:set_rgba(0, 100, 255, 255) --Light Blue
	return true
end, "on_off_switch")
	
--ON/OFF Blocks
define_tile_code("blue_on_off_block")
blue_blocks = {}
set_pre_tile_code_callback(function(x, y, layer)
	local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
	blue_blocks[#blue_blocks + 1] = get_entity(block_id)
	blue_blocks[#blue_blocks].color:set_rgba(0, 100, 255, 255) --Light Blue
	blue_blocks[#blue_blocks].more_flags = set_flag(blue_blocks[#blue_blocks].more_flags, 17) --Unpushable
	blue_blocks[#blue_blocks].flags = set_flag(blue_blocks[#blue_blocks].flags, 10) --No Gravity
	blue_blocks[#blue_blocks].flags = set_flag(blue_blocks[#blue_blocks].flags, 6) --Indestructible
	return true
end, "blue_on_off_block")

define_tile_code("red_on_off_block")
red_blocks = {}
set_pre_tile_code_callback(function(x, y, layer)
	local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
	red_blocks[#red_blocks + 1] = get_entity(block_id)
	red_blocks[#red_blocks].color:set_rgba(255, 40, 0, 150) --Red, Transparent
	red_blocks[#red_blocks].more_flags = set_flag(red_blocks[#red_blocks].more_flags, 17) --Unpushable
	red_blocks[#red_blocks].flags = set_flag(red_blocks[#red_blocks].flags, 10) --No Gravity
	red_blocks[#red_blocks].flags = set_flag(red_blocks[#red_blocks].flags, 6) --Indestructible
	red_blocks[#red_blocks].flags = clr_flag(red_blocks[#red_blocks].flags, 3) --No Collision
	return true
end, "red_on_off_block")

local create_stats = require('stats')
local function create_saved_run()
	return {
		has_saved_run = false,
		saved_run_attempts = nil,
		saved_run_time = nil,
		saved_run_level = nil,
	}
end

local game_state = {
	difficulty = DIFFICULTY.NORMAL,
	stats = create_stats(),
	normal_saved_run = create_saved_run(),
}

local continue_door

function update_continue_door_enabledness()
	if not continue_door then return end
	local current_saved_run = game_state.normal_saved_run
	continue_door.update_door(current_saved_run.saved_run_level, current_saved_run.saved_run_attempts, current_saved_run.saved_run_time)
end

-- "Continue Run" Door
define_tile_code("continue_run")
local function continue_run_callback()
	return set_pre_tile_code_callback(function(x, y, layer)
		continue_door = level_sequence.spawn_continue_door(
			x,
			y,
			layer,
			game_state.normal_saved_run.saved_run_level,
			game_state.normal_saved_run.saved_run_attempts,
			game_state.normal_saved_run.saved_run_time,
			SIGN_TYPE.RIGHT)
		return true
	end, "continue_run")
end

-- Creates a door for the shortcut, uses "volcana_shortcut" tile code
define_tile_code("volcana_shortcut")
local function shortcut_callback()
	return set_pre_tile_code_callback(function(x, y, layer)
	
		if options.level_selected < 1 then
			options.level_selected = 1
		elseif options.level_selected > 6 then
			options.level_selected = 6
		end
		
		level_sequence.spawn_shortcut(x, y, layer, levels[options.level_selected], SIGN_TYPE.RIGHT)
		return true
	end, "volcana_shortcut")
end

frames_sc4 = 0
level_sequence.set_on_win(function(attempts, total_time)
	local frames = total_time
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

	print("Total Attempts: " .. tostring(attempts))
	print("Total Time: " .. hours .. "h " .. minutes .. "m " .. seconds .. "s " .. milliseconds .. "ms")
	
	warp(1, 1, THEME.BASE_CAMP)
end)

--Dark Level stuff
set_callback(function()
	if state.theme == THEME.BASE_CAMP then
		state.level_flags = clr_flag(state.level_flags, 18)
	else	
		state.level_flags = clr_flag(state.level_flags, 18)
	end	
end, ON.POST_ROOM_GENERATION)

--Remove resources from the player and set health to 1
--Remove held item from the player
level_sequence.set_on_post_level_generation(function(level)
	if #players == 0 then return end
	
	players[1].inventory.bombs = 0
	players[1].inventory.ropes = 0
	players[1].health = 1
	
	if players[1].holding_uid ~= -1 then
		players[1]:get_held_entity():destroy()
	end
end)

level_sequence.set_on_completed_level(function(completed_level, next_level)
	if not next_level then return end

	local current_stats = game_state.stats
	local best_level_index = level_sequence.index_of_level(current_stats.best_level)
	local current_level_index = level_sequence.index_of_level(next_level)

	if (not best_level_index or current_level_index > best_level_index) and
			not level_sequence.took_shortcut() then
				current_stats.best_level = next_level
	end
end)

-- Manage saving data and keeping the time in sync during level transitions and resets.
function save_data()
	if save_context then
		force_save(save_context)
	end
end

function save_current_run_stats()
	local run_state = level_sequence.get_run_state()
	-- Save the current run
	if state.theme ~= THEME.BASE_CAMP and
		level_sequence.run_in_progress() then
		local saved_run = game_state.normal_saved_run
		saved_run.saved_run_attempts = run_state.attempts
		saved_run.saved_run_level = run_state.current_level
		saved_run.saved_run_time = run_state.total_time
		saved_run.has_saved_run = true
	end
end

function save_current_run_stats2()
	local run_state = level_sequence.get_run_state()
	-- Save the current run
	if state.theme ~= THEME.BASE_CAMP and
		level_sequence.run_in_progress() then
		local saved_run = game_state.normal_saved_run
		saved_run.saved_run_level = run_state.current_level
		saved_run.has_saved_run = true
	end
end

-- Saves the current state of the run so that it can be continued later if exited.
local function save_current_run_stats_callback()
	return set_callback(function()
		save_current_run_stats()
	end, ON.FRAME)
end

local function save_current_run_stats_callback2()
	return set_callback(function()
		save_current_run_stats2()
	end, ON.TRANSITION)
end

local function clear_variables_callback()
	return set_callback(function()
		continue_door = nil
	end, ON.PRE_LOAD_LEVEL_FILES)
end

set_callback(function(ctx)
	game_state = save_state.load(game_state, level_sequence, ctx)
end, ON.LOAD)

function force_save(ctx)
	save_state.save(game_state, level_sequence, ctx)
end

local function on_save_callback()
	return set_callback(function(ctx)
		save_context = ctx
		force_save(ctx)
	end, ON.SAVE)
end

local active = false
local callbacks = {}

local function activate()
	if active then return end
	active = true
	level_sequence.activate()

	local function add_callback(callback_id)
		callbacks[#callbacks+1] = callback_id
	end

	add_callback(continue_run_callback())
	add_callback(shortcut_callback())
	add_callback(clear_variables_callback())
	add_callback(on_save_callback())
	add_callback(save_current_run_stats_callback())
	add_callback(save_current_run_stats_callback2())
end

set_callback(function()
    activate()
end, ON.LOAD)

set_callback(function()
    activate()
end, ON.SCRIPT_ENABLE)

set_callback(function()
    if not active then return end
	active = false
	level_sequence.deactivate()

	for _, callback in pairs(callbacks) do
		clear_callback(callback)
	end

	callbacks = {}

end, ON.SCRIPT_DISABLE)

--Instant Restart on death
-- set_callback(function()
	-- if state.screen ~= 12 then
		-- return
	-- end

	-- local health = 0
	-- for i = 1,#players do
		-- health = health + players[i].health
	-- end

	-- if health == 0 then
		-- state.quest_flags = set_flag(state.quest_flags, 1)
		-- warp(state.world_start, state.level_start, state.theme_start)
	-- end
-- end, ON.FRAME)
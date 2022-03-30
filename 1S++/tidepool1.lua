local sound = require('play_sound')

local tidepool1 = {
    identifier = "Tidepool-1",
    title = "[Episode B, Level 3] Headbutt",
    theme = THEME.TIDE_POOL,
    width = 4,
    height = 4,
    file_name = "Tidepool-1.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

tidepool1.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Hermitcrabs
        local x, y, layer = get_position(entity.uid)
        local floor = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #floor > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            entity:destroy()
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_HERMITCRAB)
	
	local frames = 0
	local key_collected = false
	local exit_blocks_deactivated = false
	local enemies_dead = {}
	lifebar = 1501 --Number of frames the player has left to live
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()

		if frames == 0 then
			pacifist = true
			no_gold = true
			all_gems = true
			all_gold = true
			genocide = true
			s_plus_plus = false
			
			for i = 1,#exit_blocks do
				exit_blocks[i]:activate_laserbeam(true)
			end
			
			local enemy_uid = get_entities_by_type(ENT_TYPE.MONS_OCTOPUS, ENT_TYPE.MONS_FISH)
			for i = 1,#enemy_uid do
				enemies[i] = get_entity(enemy_uid[i])
				enemies_dead[i] = false
			end			
		end
		
		if #players ~= 0 and lifebar == 0 then
			kill_entity(players[1].uid, false)
		end
		
		for i = 1,#bars do
			if test_flag(bars[i].flags, 29) == true and cashed_gold[i] == false then
				lifebar = lifebar + 60 -- Add a second to remaining time if gold is collected
				cashed_gold[i] = true
			end
		end

		for i = 1,#emeralds do
			if test_flag(emeralds[i].flags, 29) == true and cashed_emeralds[i] == false then
				lifebar = lifebar + 120 -- Add 2 seconds to remaining time if gold is collected
				cashed_emeralds[i] = true
			end
		end
		
		for i = 1,#sapphires do
			if test_flag(sapphires[i].flags, 29) == true and cashed_sapphires[i] == false then
				lifebar = lifebar + 180 -- Add 3 seconds to remaining time if gold is collected
				cashed_sapphires[i] = true
			end
		end
		
		for i = 1,#rubies do
			if test_flag(rubies[i].flags, 29) == true and cashed_rubies[i] == false then
				lifebar = lifebar + 240 -- Add 4 seconds to remaining time if gold is collected
				cashed_rubies[i] = true
			end
		end

		for i = 1,#diamonds do
			if test_flag(diamonds[i].flags, 29) == true and cashed_diamonds[i] == false then
				lifebar = lifebar + 300 -- Add 5 seconds to remaining time if gold is collected
				cashed_diamonds[i] = true
			end
		end

		for i = 1,#enemies do
			if test_flag(enemies[i].flags, 29) == true and enemies_dead[i] == false then
				enemies_dead[i] = true
			end
		end

		if #key ~=0 and #players ~= 0 and math.sqrt((key[1].x - players[1].x) ^ 2 + (key[1].y - players[1].y) ^ 2 ) < 0.7 and key_collected == false then
			key_collected = true
			key[1].flags = clr_flag(key[1].flags, 28)
			key[1]:destroy()
			sound.play_sound(VANILLA_SOUND.SHARED_DOOR_UNLOCK)
		end
		
		if key_collected == true and exit_blocks_deactivated == false then
			for i = 1,#exit_blocks do
				exit_blocks[i]:activate_laserbeam(false)
			end
			exit_blocks_deactivated = true
		end
		
		if lifebar > 0 and telescope_activated == false and #players ~= 0 and players[1].state ~= CHAR_STATE.ENTERING and players[1].state ~= CHAR_STATE.LOADING then
			lifebar = lifebar - 1
		end
		
		--Check No Gold
		for i = 1,#cashed_gold do
			if cashed_gold[i] == true then
				no_gold = false
			end
		end
		
		--Check All Gold
		if #players ~= 0 and players[1].state == CHAR_STATE.ENTERING then
			for i = 1,#cashed_gold do
				if cashed_gold[i] == false then
					all_gold = false
				end
			end
		end
		
		--Check Pacifist
		for i = 1,#enemies do
			if #players ~= 0 and enemies[i].last_owner_uid == players[1].uid then
				pacifist = false
			end
		end
		
		--Check Genocide
		if #players ~= 0 and players[1].state == CHAR_STATE.ENTERING then
			for i = 1,#enemies_dead do
				if enemies_dead[i] == false then
					genocide = false
				end
			end
		end
		
		--Check Gems
		if #players ~= 0 and players[1].state == CHAR_STATE.ENTERING then
			for i = 1,#cashed_emeralds do
				if cashed_emeralds[i] == false then
					all_gems = false
				end
			end
			for i = 1,#cashed_sapphires do
				if cashed_sapphires[i] == false then
					all_gems = false
				end
			end
			for i = 1,#cashed_rubies do
				if cashed_rubies[i] == false then
					all_gems = false
				end
			end
			for i = 1,#cashed_diamonds do
				if cashed_diamonds[i] == false then
					all_gems = false
				end
			end
		end
		
		if #players ~= 0 and players[1].state == CHAR_STATE.ENTERING then
			if (no_gold or all_gold) and (pacifist or genocide) and all_gems then
				s_plus_plus = true
			end
			
			--Calculate level score
			
			level_score = lifebar * 5
			
			if no_gold then
				level_score = level_score + 5000
			end
			
			if all_gold then
				level_score = level_score + 3000
			end
			
			if pacifist then
				level_score = level_score + 4000
			end
			
			if genocide then
				level_score = level_score + 4000
			end
			
			if all_gems then
				level_score = level_score + 3000
			end
			
			if s_plus_plus then
				level_score = level_score + 10000
			end
			
		end

		frames = frames + 1
		
    end, ON.FRAME)
	
	toast(tidepool1.title)
end

tidepool1.unload_level = function()
    if not level_state.loaded then return end

	bars = {}
	cashed_gold = {}

	emeralds = {}
	cashed_emeralds = {}
	
	sapphires = {}
	cashed_sapphires = {}
	
	rubies = {}
	cashed_rubies = {}
	
	diamonds = {}
	cashed_diamonds = {}
	
	key = {}
	exit_blocks = {}
	
	enemies = {}

    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return tidepool1
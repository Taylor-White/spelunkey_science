local dwelling2 = {
    identifier = "Dwelling-2",
    title = "Dwelling-2: High Roller",
    theme = THEME.DWELLING,
    width = 4,
    height = 4,
    file_name = "Dwelling-2.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

dwelling2.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true

	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	local lizard
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Allow Horned Lizard to stand on thorns
		lizard = entity
		entity:give_powerup(ENT_TYPE.ITEM_POWERUP_SPIKE_SHOES)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_HORNEDLIZARD)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible wood floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_MINEWOOD)
	
	--ON/OFF Elevator
	define_tile_code("blue_lift")
	blue_lift = {}
	set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_ELEVATOR, x, y, layer, 0, 0)
		blue_lift[#blue_lift + 1] = get_entity(block_id)
		blue_lift[#blue_lift].color:set_rgba(0, 100, 255, 255) --Light Blue
		return true
	end, "blue_lift")
	
	--Death Blocks
	define_tile_code("death_block")
	local death_blocks = {}
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ACTIVEFLOOR_PUSHBLOCK, x, y, layer, 0, 0)
		death_blocks[#death_blocks + 1] = get_entity(block_id)
		death_blocks[#death_blocks].color:set_rgba(100, 0, 0, 255) --Dark Red
		death_blocks[#death_blocks].more_flags = set_flag(death_blocks[#death_blocks].more_flags, 17) --Unpushable
		death_blocks[#death_blocks].flags = set_flag(death_blocks[#death_blocks].flags, 10) --No Gravity
		return true
	end, "death_block")
	
	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
	
		if frames == 0 then
			players[1].health = 3
			lizard.flags = set_flag(lizard.flags, 17)
		end
		
		for i = 1,#switches do
			if switches[i].timer == 90 then
				switch_hit = true
				switches[i].timer = 60
			end
		end
		
		if off == true and switch_hit == true then
			switch_hit = false
			off = false
		
			for i = 1,#switches do
				switches[i].color:set_rgba(255, 40, 0, 255) --Red
			end
			
			for i = 1,#blue_blocks do
				blue_blocks[i].color:set_rgba(0, 100, 255, 150) --Light Blue, Transparent
				blue_blocks[i].flags = clr_flag(blue_blocks[i].flags, 3) --No Collision
			end

			for i = 1,#blue_lift do
				blue_lift[i].color:set_rgba(0, 100, 255, 150) --Light Blue, Transparent
				blue_lift[i].flags = clr_flag(blue_lift[i].flags, 3) --No Collision
			end

			for i = 1,#red_blocks do
				red_blocks[i].color:set_rgba(255, 40, 0, 255) --Red
				red_blocks[i].flags = set_flag(red_blocks[i].flags, 3)				
			end		
		elseif off == false and switch_hit == true then
			switch_hit = false
			off = true
		
			for i = 1,#switches do
				switches[i].color:set_rgba(0, 100, 255, 255) --Light Blue
			end
			
			for i = 1,#blue_blocks do
				blue_blocks[i].color:set_rgba(0, 100, 255, 255) --Light Blue
				blue_blocks[i].flags = set_flag(blue_blocks[i].flags, 3) --Collision
			end

			for i = 1,#blue_lift do
				blue_lift[i].color:set_rgba(0, 100, 255, 255) --Light Blue, Transparent
				blue_lift[i].flags = set_flag(blue_lift[i].flags, 3) --No Collision
			end

			for i = 1,#red_blocks do
				red_blocks[i].color:set_rgba(255, 40, 0, 150) --Red, Transparent
				red_blocks[i].flags = clr_flag(red_blocks[i].flags, 3)
			end
		end
		
		--Whipping the blocks seems to undo the unpushable flag, reset flag every frame
		for i = 1,#blue_blocks do
			blue_blocks[i].more_flags = set_flag(blue_blocks[i].more_flags, 17) --Unpushable		
		end
		
		for i = 1,#red_blocks do
			red_blocks[i].more_flags = set_flag(red_blocks[i].more_flags, 17) --Unpushable
		end
		
		if test_flag(lizard.flags, 29) ~= true and lizard.attack_cooldown_timer == 60 then
			lizard.attack_cooldown_timer = 0
		end
		
		for i = 1,#death_blocks do
			death_blocks[i].color:set_rgba(100 + math.ceil(40 * math.sin(0.05 * frames)), 0, 0, 255) --Pulse effect
			if #players ~= 0 and players[1].standing_on_uid == death_blocks[i].uid then
				kill_entity(players[1].uid, false)
			end
		end
		
		frames = frames + 1
		
    end, ON.FRAME)
	
	toast(dwelling2.title)
end

dwelling2.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
	
	switch_hit = false
	off = true
	switches = {}
	blue_blocks = {}
	red_blocks = {}
end

return dwelling2

local volcana2 = {
    identifier = "Volcana-2",
    title = "Volcana-2: Transform",
    theme = THEME.VOLCANA,
    width = 4,
    height = 4,
    file_name = "Volcana-2.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

volcana2.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Magmamen.
        local x, y, layer = get_position(entity.uid)
        local lavas = get_entities_at(0, MASK.LAVA, x, y, layer, 1)
        if #lavas > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            move_entity(entity.uid, 1000, 0, 0, 0)
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_MAGMAMAN)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
        -- Remove Firebugs.
        local x, y, layer = get_position(entity.uid)
        local chains = get_entities_at(0, MASK.ANY, x, y, layer, 1)
        if #chains > 0 then
            entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
            move_entity(entity.uid, 1000, 0, 0, 0)
        end
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_FIREBUG)
	
	--Sliding Wall Switch
	local wall_switch
	define_tile_code("wall_switch")
	set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn(ENT_TYPE.ITEM_SLIDINGWALL_SWITCH, x, y, layer, 0, 0)
		wall_switch = get_entity(block_id)
	end, "wall_switch")
	
	local frames = 0
	local wall_switch_off = true
	local slidingwall = {}
	local arrows = {}
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
		if frames == 0 then
			players[1]:remove_powerup(ENT_TYPE.ITEM_POWERUP_SPRING_SHOES)
			state.kali_favor = 16
			local uids = get_entities_by(ENT_TYPE.FLOOR_SLIDINGWALL_CEILING, MASK.ANY, 0)
			for i = 1,#uids do
				slidingwall[#slidingwall + 1] = get_entity(uids[i])
			end
			uids = get_entities_by(ENT_TYPE.ITEM_METAL_ARROW, MASK.ANY, 0)
			for i = 1,#uids do
				arrows[#arrows + 1] = get_entity(uids[i])
			end
			for i = 1,#arrows do
				arrows[i]:destroy()
			end
		end
		
		if wall_switch.timer == 90 and wall_switch_off == true then
			for i = 1,#slidingwall do
				slidingwall[i].state = 1
			end
			wall_switch_off = false
		elseif wall_switch.timer == 90 and wall_switch_off == false then
			for i = 1,#slidingwall do
				slidingwall[i].state = 0
			end
			wall_switch_off = true
		end
		
		frames = frames + 1		
    end, ON.FRAME)
	
	toast(volcana2.title)
end

volcana2.unload_level = function()
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

return volcana2
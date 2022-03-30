local dwelling3 = {
    identifier = "Dwelling-3",
    title = "Dwelling-3: Thanksgiving",
    theme = THEME.DWELLING,
    width = 4,
    height = 4,
    file_name = "Dwelling-3.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

dwelling3.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_PICKUP_SKELETON_KEY)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_SKELETON)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:tame(true)
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MOUNT_TURKEY)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity.x = entity.x + 0.5
	end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_TORCH)
	
	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()
		if frames == 0 then
			players[1].health = 1
		end
		
		frames = frames + 1
    end, ON.FRAME)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible wood floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOORSTYLED_MINEWOOD)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_GENERIC)
	
	toast(dwelling3.title)
end

dwelling3.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return dwelling3

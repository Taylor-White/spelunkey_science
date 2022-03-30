local volcana1 = {
    identifier = "Volcana-1",
    title = "Volcana-1: Mineshaft",
    theme = THEME.VOLCANA,
    width = 4,
    height = 4,
    file_name = "Volcana-1.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

volcana1.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_SKULL)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(entity, spawn_flags)
		entity:destroy()
	end, SPAWN_TYPE.SYSTEMIC, 0, ENT_TYPE.ITEM_PICKUP_SKELETON_KEY)
	
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
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		--Indestructible floor
		entity.flags = set_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR)
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.flags = clr_flag(entity.flags, 6)
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_CHAIN_CEILING)
	
	--Mattock
	define_tile_code("pickaxe")
	set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_MATTOCK, x, y, layer, 0, 0)
		return true
	end, "pickaxe")
	
	--Mattock
	define_tile_code("pickaxe")
	set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_MATTOCK, x, y, layer, 0, 0)
		return true
	end, "pickaxe")
	
	--Broken Mattock
	define_tile_code("broken_pickaxe")
	set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_BROKEN_MATTOCK, x, y, layer, 0, 0)
		return true
	end, "broken_pickaxe")
	
	--Spring Shoes
	define_tile_code("springs")
	local springs
	level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
		local block_id = spawn_entity_snapped_to_floor(ENT_TYPE.ITEM_PICKUP_SPRINGSHOES, x, y, layer, 0, 0)		
		 springs = get_entity(block_id)
		 return true
	end, "springs")
	
	level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function (entity)
		entity.remaining = 3
    end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ITEM_MATTOCK)
	
	local frames = 0
	level_state.callbacks[#level_state.callbacks+1] = set_callback(function ()			
        frames = frames + 1			
    end, ON.FRAME)
	
	toast(volcana1.title)
end

volcana1.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return volcana1
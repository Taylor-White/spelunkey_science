outfit_list = {}
function add_outfit(loc)
	-- special thanks to Dregu, for providing me with major help for this
	local texture_def = get_texture_definition(TEXTURE.DATA_TEXTURES_CHAR_YELLOW_0)
    local _, w, h = create_image("wardrobe_skins/"..loc)
    texture_def.texture_path = ("wardrobe_skins/"..loc)
    texture_def.sub_image_width = 2048
    texture_def.sub_image_height = 2048
    texture_def.width = w
    texture_def.height = h
	local nextup = #outfit_list+1
	outfit_list[nextup] = define_texture(texture_def)
end

for i=0,187 do
    add_outfit(tostring(i) .. ".png")
end

-- wardrobe texture
local t_def = get_texture_definition(TEXTURE.DATA_TEXTURES_DECO_BASECAMP_0)
t_def.texture_path = "wardrobe.png"
wardrobe_tex = define_texture(t_def)

-- wardrobe positions
wardrobe_x = 32.5
wardrobe_y = 87

-- init some player values
prev_door = {}
outfit = {}
default_outfit = {}

for p=1,4 do
	prev_door[p] = false
	outfit[p] = 0
	default_outfit[p] = 0
end

-- spawn and initialize the wardrobe
wardrobe_ent = nil

set_callback(function()
	
	-- reset the outfit when entering camp
	for p, player in ipairs(players) do
		local real_index = p
		for j=1,4 do
			if state.items.player_select[j].character == player.type.id then
				real_index = j
			end
		end
		prev_door[real_index] = false
		outfit[real_index] = 0
		default_outfit[real_index] = player:get_texture()
	end
	
	-- only make the wardrobe appear once shortcut zone exists
	local sg = savegame
	
	if sg.shortcuts > 0 then
		
		wardrobe_ent = spawn(ENT_TYPE.ITEM_CONSTRUCTION_SIGN, wardrobe_x, wardrobe_y+0.25, LAYER.FRONT, 0, 0)
		get_entity(wardrobe_ent):set_texture(wardrobe_tex)
		local wardrobe_ent_movable = get_entity(wardrobe_ent):as_movable()
		wardrobe_ent_movable.animation_frame = 0
		wardrobe_ent_movable.width = 1.5
		wardrobe_ent_movable.height = 1.5
		
		-- now, update the wardrobe
		-- loop through the players and check who's interacting
		set_interval(function()
	
			for p, player in ipairs(players) do
			
				if wardrobe_ent ~= nil and distance(player.uid, wardrobe_ent) < 1
				and get_entity(wardrobe_ent):get_texture() == wardrobe_tex then
				
					-- if button pressed
					if test_flag(player.buttons, 6) and not prev_door[p] and toast_visible() then
						
						
						local real_index = p
						for j=1,4 do
							if state.items.player_select[j].character == player.type.id then
								real_index = j
							end
						end
						
						-- hide the shortcut message
						cancel_toast()
						set_timeout(function()
							if not toast_visible() then
								toast("Player " .. tostring(p) .. " has changed their outfit!")
							end
						end, 1)
						
						-- change the player's outfit
						outfit[real_index] = outfit[real_index]+1
						if outfit[real_index] > #outfit_list then
							outfit[real_index] = 0
						end
						if outfit[real_index] ~= 0 then
							player:set_texture(outfit_list[outfit[real_index]])
						else
							player:set_texture(default_outfit[real_index])
						end
						
						-- particle effect
						generate_particles(PARTICLEEMITTER.HITEFFECT_STARS_BIG, player.uid)
						
						-- sound
						local sound = get_sound(VANILLA_SOUND.SHARED_COFFIN_RATTLE)
						if sound ~= nil then sound:play() end
						
					end
					
				end
				
				prev_door[p] = test_flag(player.buttons, 6)
			
			end
	
		end, 1)
		
	end
	
end, ON.CAMP)

-- apply textures (funny)
function apply_funny()

	for p, player in ipairs(players) do
		
		-- find the proper player slot (doesnt work if players use the same skin (impossible))
		
		local real_index = p
		for j=1,4 do
			if state.items.player_select[j].character == player.type.id then
				real_index = j
			end
		end
		
		if outfit[real_index] ~= 0 then
			player:set_texture(outfit_list[outfit[real_index]])
		end
	end
	
end

set_callback(function() apply_funny() end, ON.GAMEFRAME)
set_callback(function() apply_funny() end, ON.SCREEN)
set_callback(function() apply_funny() end, ON.LEVEL)

-- reset the textures when in the menu
set_callback(function()
	
	for p=1,4 do
		prev_door[p] = false
		outfit[p] = 0
		default_outfit[p] = 0
	end
	
end, ON.MENU)



meta.name = 'Wardrobe'
meta.version = '1.0'
meta.description = 'Additional character skins!'
meta.author = 'Trixelized'
meta.unsafe = false

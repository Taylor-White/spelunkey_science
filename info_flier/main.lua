meta.name = "The_Marble"
meta.version = "The_Marble"
meta.description = "The_Marble"
meta.author = "The_Marble"
what_how, w, h = create_image('nut.png')
sanctuary = create_sound('nut_music.mp3')
funny_bop = sanctuary:play(false, SOUND_TYPE.SFX)
funny_bop:set_looping(SOUND_LOOP_MODE.LOOP)
funny_bop:set_pause(true)
funny_time = 0
funny_time_max = 24
funny_frame = 91
funny_replace = ENT_TYPE.ITEM_ROCK
set_callback(function()
	local previous_is_playing = (funny_time > 0)
	for i, player in ipairs(players) do
		local held = player.holding_uid
		if held > -1 then
			local held_move = get_entity(held):as_movable()
			local held_type = get_entity_type(held)
			if (held_type == funny_replace) and (held_move.animation_frame == funny_frame) then
				funny_time = funny_time_max
			end
		end
	end
	if funny_time > 0 then
		funny_time = funny_time-1
		draw_image(what_how, -1, 1, 1, -1, 0, 0, 1, 1, 0xffffffff)
	end
	if (state.screen == 13) and funny_time > 0 then
		funny_time = funny_time_max
	end
	local portals = get_entities_by_type(ENT_TYPE.FX_PORTAL)
	if #portals > 0 and funny_time > 0 then
		funny_time = funny_time_max
	end
	local is_playing = (funny_time > 0)
	if is_playing ~= previous_is_playing then
		if is_playing == true then
			funny_bop:set_pause(false)
		else
			funny_bop:set_pause(true)
		end
	end
end, ON.GUIFRAME)
set_callback(function()
	--local rocks = get_entities_by_type(funny_replace)
	if state.level == 1 and state.theme == 1 and state.world == 1 then
		local x, y, l = get_position(players[1].uid)
		local sock = spawn(ENT_TYPE.ITEM_ROCK, x+0.5, y-0.18, l, 0, 0)
		local rock_ent = get_entity(sock):as_movable()
		rock_ent.animation_frame = funny_frame
		rock_ent.hitboxx = 0.2
		rock_ent.hitboxy = 0.35
	end
	
	for i, player in ipairs(players) do
		local held = player.holding_uid
		if held > -1 then
			local held_move = get_entity(held):as_movable()
			local held_type = get_entity_type(held)
			if (held_type == funny_replace) and (funny_time > 0) then
				funny_time = funny_time_max
				local rock_ent = held_move
				rock_ent.animation_frame = funny_frame
				rock_ent.hitboxx = 0.2
				rock_ent.hitboxy = 0.35
			end
		end
	end
	
end, ON.LEVEL)
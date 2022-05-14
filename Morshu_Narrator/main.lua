--------------------------------------------------------------------
meta.name = "Morshu"
meta.version = "0.00"
meta.description = "It's yours, my friend"
meta.author = "Morshu himself"
--------------------------------------------------------------------

-- Sounds
snd_ropes = create_sound('soundbank/wav/rope.wav')
snd_bombs = create_sound('soundbank/wav/bombs.wav')
snd_l_oil = create_sound('soundbank/wav/lamp_oil.wav')
snd_rare = create_sound('soundbank/wav/its_yours.wav')


-- Delay (in frames) inbetween specific lines
ropes_said = 0
bombs_said = 0
l_oil_said = 0
rare_said = 0

audio_delay = 60

-- Image indexes
ropes_indexes = {96}
bombs_indexes = {32, 33, 97, 98}
l_oil_indexes = {34}



-- If table has value
function table_has_value(_tab, _val)
	local _return = false
	for i, _value in ipairs(_tab) do
		if _value == _val then
			_return = true
		end
	end
	return (_return)
end



-- Create the game loop
set_callback(function()
	
	-- If there's no players, don't run code
	if #players < 1 then return end
	
	
	if ropes_said > 0 then
		ropes_said = ropes_said - 1
	end
	
	if bombs_said > 0 then
		bombs_said = bombs_said - 1
	end	
	
	if l_oil_said > 0 then
		l_oil_said = l_oil_said - 1
	end
	
	if rare_said > 0 then
		rare_said = rare_said - 1
	end
	
	-- Loop through all the pickup effects
	local p_fx_list = get_entities_by_type(ENT_TYPE.FX_PICKUPEFFECT)
	for i, p_fx in ipairs(p_fx_list) do
		-- Get the entity 'as movable'
		local p_ent = get_entity(p_fx):as_movable()
		
		if (ropes_said <= 0) and (p_ent.color.a > 0.5) and table_has_value(ropes_indexes, p_ent.animation_frame) then
			snd_ropes:play(false, SOUND_TYPE.SFX)
			ropes_said = audio_delay
		end
		
		if (bombs_said <= 0) and (p_ent.color.a > 0.5) and table_has_value(bombs_indexes, p_ent.animation_frame) then
			snd_bombs:play(false, SOUND_TYPE.SFX)
			bombs_said = audio_delay
		end
		
		if (l_oil_said <= 0) and (p_ent.color.a > 0.5) and table_has_value(l_oil_indexes, p_ent.animation_frame) then
			snd_l_oil:play(false, SOUND_TYPE.SFX)
			l_oil_said = audio_delay
		end
		
		-- rare
		if (rare_said <= 0) and (ropes_said <= 0) and (bombs_said <= 0) and (l_oil_said <= 0) and (p_ent.color.a > 0.5) then
			if math.random(300) == 1 then
				rare_said = audio_delay * 10
				snd_rare:play(false, SOUND_TYPE.SFX)
			end
		end
		
		
	end
	
	
end, ON.FRAME)

meta.name = "Olmec variations"
meta.version = "1.0"
meta.description = "Makes Olmec different every time!"
meta.author = "Gugubo"

local texture_images = {} --All textures with unique names
local n = 23 -- Number of textures named "Olmec (x).png"
local load_all_on_start = false
local textures = {}

for i=1, n do
	texture_images[#texture_images+1] = "Olmec ("..tostring(i)..").png"
end

function get_texture_from_image(image_path)
	local texture_defs = {}
	for original = TEXTURE.DATA_TEXTURES_MONSTERS_OLMEC_0, TEXTURE.DATA_TEXTURES_MONSTERS_OLMEC_4 do
		local texture_def = get_texture_definition(original)
		texture_def.texture_path = image_path
		texture_defs[original] = define_texture(texture_def)
	end
	return texture_defs
end

if load_all_on_start then
	prinspect("Loading all textures")
	for i, texture_image in ipairs(texture_images) do
		textures[i]=get_texture_from_image(texture_image)
	end
	prinspect("Loaded")
end

--Change texture of each olmec part
function change_olmec_texture(olmec, texture_defs)
	local olmec_parts = entity_get_items_by(olmec.uid, MASK.ANY, MASK.ANY)
	for i, olmec_part_uid in ipairs(olmec_parts) do
		local olmec_part = get_entity(olmec_part_uid)
		local new_texture = texture_defs[olmec_part:get_texture()]
		if new_texture then olmec_part:set_texture(new_texture) end
		change_olmec_texture(olmec_part, texture_defs)
	end
end

--Loads random texture and applies it
function random_olmec(olmec)
	local texture_defs = nil
	if load_all_on_start then
		texture_defs = textures[math.random(#textures)]
	else
		texture_defs = get_texture_from_image(texture_images[math.random(#texture_images)])
	end
	change_olmec_texture(olmec, texture_defs)
end

set_post_entity_spawn(function(ent)
    set_global_timeout(function()
        random_olmec(ent)
    end, 1)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.ACTIVEFLOOR_OLMEC)
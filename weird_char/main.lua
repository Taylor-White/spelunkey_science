meta = {
    name = "RGBee",
    description = "Enjoy caving with this cute gamer bee.",
    author = "daker & Mala🐈",
    version = "0.1",
}

require('color')

-- Change values here to your liking
local player_type = ENT_TYPE.CHAR_ROFFY_D_SLOTH
local orig_texture = TEXTURE.DATA_TEXTURES_CHAR_BLACK_0
local base_texture = "Data/Textures/char_black_base.png"
local led_texture = "Data/Textures/char_black_led.png"
local rgb_frequency = 0.1 -- bigger values are faster
local rgb_saturation = 1.0
local rgb_value = 1.0
local shader = WORLD_SHADER.DEFERRED_TEXTURE_COLOR_EMISSIVE_COLORIZED_GLOW_SATURATION
--[[ try one of:
    WORLD_SHADER.DEFERRED_TEXTURE_COLOR_EMMISIVE_GLOW_HEAVY
    WORLD_SHADER.DEFERRED_TEXTURE_COLOR_EMMISIVE_GLOW
    WORLD_SHADER.DEFERRED_TEXTURE_COLOR_EMISSIVE_GLOW_BRIGHTNESS
    WORLD_SHADER.DEFERRED_TEXTURE_COLOR_EMISSIVE_COLORIZED_GLOW
    WORLD_SHADER.DEFERRED_TEXTURE_COLOR_EMISSIVE_COLORIZED_GLOW_DYNAMIC_GLOW
    WORLD_SHADER.DEFERRED_TEXTURE_COLOR_EMISSIVE_COLORIZED_GLOW_SATURATION
]]
-- don't touch below

---@type TEXTURE
local bee_orig_id = TEXTURE.DATA_TEXTURES_CHAR_BLACK_0 + player_type - ENT_TYPE.CHAR_ROFFY_D_SLOTH
---@type TEXTURE
local bee_base_id
---@type TEXTURE
local bee_led_id
do
    local texture_def = get_texture_definition(orig_texture)
    texture_def.texture_path = base_texture
    bee_base_id = define_texture(texture_def)
    texture_def.texture_path = led_texture
    bee_led_id = define_texture(texture_def)
end

local char_hues = {}

---@type number | nil
local refresh_rate = get_setting(GAME_SETTING.FREQUENCY_NUMERATOR) / get_setting(GAME_SETTING.FREQUENCY_DENOMINATOR)
set_callback(function()
    refresh_rate = get_setting(GAME_SETTING.FREQUENCY_NUMERATOR) / get_setting(GAME_SETTING.FREQUENCY_DENOMINATOR)
end, ON.SCREEN)

---@param render_ctx VanillaRenderContext
---@param char Player
function beesley_post_render(render_ctx, char)
    local char_uid = char.uid
    local tile_id = char.animation_frame
    local tile_x, tile_y = tile_id % 16, tile_id // 16

    ---@type Quad
    local quad
    do
        local x, y, _ = get_render_position(char_uid)
        local w, h = char.width, char.height
        local aabb = AABB:new():offset(x, y)
        aabb.left = aabb.left - w / 2.0
        aabb.right = aabb.right + w / 2.0
        aabb.bottom = aabb.bottom - h / 2.0
        aabb.top = aabb.top + h / 2.0
        if test_flag(char.flags, ENT_FLAG.FACING_LEFT) then
            aabb.left, aabb.right = aabb.right, aabb.left
        end
        quad = Quad:new(aabb)
    end

    local hue = char_hues[char_uid] or 0

    if state.pause == 0 then
        hue = math.fmod(hue + rgb_frequency / refresh_rate, 1.0)
        char_hues[char_uid] = hue
    end

    local r, g, b, _ = hsvToRgb(hue, rgb_saturation, rgb_value, 1.0)
    local color = Color:new(r / 255 * char.color.r, g / 255 * char.color.g, b / 255 * char.color.b, char.color.a)

    render_ctx:draw_world_texture(bee_led_id, tile_y, tile_x, quad, color, shader)

    for _, light in ipairs(char.emitted_light.lights) do
        light.red = color.r
        light.green = color.g
        light.blue = color.b
    end
end

---@param char Player
local function beesley_kill(char)
    char:set_texture(bee_orig_id)
end

---@param char Player
local function beesley_setup(char)
    char:set_texture(bee_base_id)
    set_post_render(char.uid, beesley_post_render)
    set_on_kill(char.uid, beesley_kill)
end

---@param char_ghost PlayerGhost
local function beesley_ghost_setup(char_ghost)
    local texture_id = char_ghost:get_texture()
    if texture_id == bee_orig_id or texture_id == bee_base_id then
        beesley_setup(char_ghost)
    end
end

---@param char Player
set_post_entity_spawn(function(char)
    set_global_timeout(function()
        beesley_setup(char)
    end, 1)
end, SPAWN_TYPE.ANY, MASK.ANY, player_type)

---@param char_ghost PlayerGhost
set_post_entity_spawn(function(char_ghost)
    set_global_timeout(function()
        beesley_ghost_setup(char_ghost)
    end, 1)
end, SPAWN_TYPE.ANY, MASK.ANY, ENT_TYPE.ITEM_PLAYERGHOST)

-- Note: Only for script-hotloading support
set_callback(function()
    local chars = get_entities_by(player_type, MASK.PLAYER, LAYER.BOTH)
    for _, char_uid in pairs(chars) do
        beesley_setup(get_entity(char_uid))
    end

    local char_ghosts = get_entities_by(ENT_TYPE.ITEM_PLAYERGHOST, MASK.ANY, LAYER.BOTH)
    for _, char_ghost_uid in pairs(char_ghosts) do
        beesley_ghost_setup(get_entity(char_ghost_uid))
    end
end, ON.LOAD)

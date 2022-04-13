gilded_ents = {}

function spawn_as_gilded(type, x, y, l, xvel, yvel)
    local ent = get_entity(spawn(type, x, y, l, xvel, yvel))
    ent.color.r = 1
    ent.color.g = 0.5
    ent.color.b = 0
    generate_particles(PARTICLEEMITTER.AU_GOLD_SPARKLES, ent.uid)
    table.insert(gilded_ents, ent.uid)
    return ent.uid
end
function clear_gilded_ents()
    gilded_ents = {}
end
function manage_gilded_ents()
    for i, v in ipairs(gilded_ents) do
        local ent = get_entity(v)
        local ex, ey, el = get_position(v)
        if ent ~= nil then
            if ent.health == 0 then
                play_vanilla_sound(VANILLA_SOUND.ENEMIES_SORCERESS_ATK_SPAWN)
                table.remove(gilded_ents, i)
                spawn(ENT_TYPE.FX_NECROMANCER_ANKH, ex, ey, el, 0, 0)
                generate_particles(160, v)
                set_timeout(function()
                    spawn(ENT_TYPE.FX_ANUBIS_SPECIAL_SHOT_RETICULE, ex, ey, el, 0, 0)
                end, 80)
                set_timeout(function()
                    local mummy = get_entity(spawn(ENT_TYPE.MONS_MUMMY, ex, ey, el, 0, 0))
                    mummy.health = 4
                    mummy.hitboxx = mummy.hitboxx / 1.4
                    mummy.hitboxy = mummy.hitboxy / 1.4
                    mummy.width = mummy.width / 1.4
                    mummy.height = mummy.height / 1.4
                    play_vanilla_sound(VANILLA_SOUND.ENEMIES_NECROMANCER_SPAWN)
                    generate_particles(PARTICLEEMITTER.NECROMANCER_SUMMON, mummy.uid)
                end, 120)
                --drop gold
                for j=1, math.random(16, 20), 1 do
                    spawn(ENT_TYPE.ITEM_NUGGET, ex, ey, el, math.random(-2, 2)/15, math.random(1, 2)/10)
                end
                ent.x = -900
            end
        end
    end
end

set_callback(clear_gilded_ents, ON.PRE_LEVEL_GENERATION)
set_callback(manage_gilded_ents, ON.FRAME)
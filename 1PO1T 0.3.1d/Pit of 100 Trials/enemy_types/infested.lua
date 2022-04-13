infested_ents = {}
orbiting_fly_uids = {}
fly_owner_uids = {}
fly_offset = {}

function spawn_as_infested(type, x, y, l, xvel, yvel)
    local ent = get_entity(spawn(type, x, y, l, xvel, yvel))
    ent.color.r = 0.4
    ent.color.b = 0.2
    ent.color.g = 0.9
    generate_particles(PARTICLEEMITTER.GASTRAIL_BIG, ent.uid)
    for i=1, 4, 1 do
        spawn_orbiting_fly(ent.uid)
        table.insert(fly_offset, i)
    end
    table.insert(infested_ents, ent.uid)
    return ent.uid
end
function spawn_orbiting_fly(owner_uid)
    local px, py, pl = get_position(players[1].uid) --for some unholy reason,, these enemies will die if they arent spawned somewhat near the player.. i have zero idea what causes this.
    local fly = get_entity(spawn(ENT_TYPE.MONS_ALIEN, px, py+1, 0, 0, 0))
    fly.flags = clr_flag(fly.flags, 13)
    fly.flags = clr_flag(fly.flags, 14)
    fly.flags = set_flag(fly.flags, 10)
    fly.flags = set_flag(fly.flags, 1)
    fly.flags = clr_flag(fly.flags, 21)
    fly:set_texture(texturevars.alienfly)
    fly:set_draw_depth(5)
    table.insert(orbiting_fly_uids, fly.uid)
    table.insert(fly_owner_uids, owner_uid)
end
function clear_infested_ents()
    infested_ents = {}
    orbiting_fly_uids = {}
    fly_owner_uids = {}
    fly_offset = {}
end
function manage_infested_ents()
    --spawn maggots on death
    for i, v in ipairs(infested_ents) do
        local ent = get_entity(v)
        if ent ~= nil then
            local ex, ey, el = get_position(v)
            if ent.health == 0 then 
                table.remove(infested_ents, i)
                if distance(players[1].uid, v) < 10 then
                    play_vanilla_sound(VANILLA_SOUND.ENEMIES_EGGSAC_BURST)
                end
                if math.random(PO1T_DROPCHANCE.INFESTED) == 1 then
                    spawn_maggotgun(ex, ey, el, 0, 0)
                end
                --maggots
                for i=1, 3, 1 do
                    local grub = get_entity(spawn(ENT_TYPE.MONS_GRUB, ex+math.random(-2, 2)/5, ey+math.random(-2, 2)/5, el, 0, 0))
                    grub.flags = set_flag(grub.flags, 4)
                    grub.width = grub.width / 1.5
                    grub.height = grub.height / 1.5
                    grub.hitboxx = grub.hitboxx / 1.5
                    grub.hitboxy = grub.hitboxy / 1.5
                    set_timeout(function()
                        grub.flags = clr_flag(grub.flags, 4)
                        grub:set_draw_depth(25)
                    end, 20)
                end
                kill_entity(v)
            end
        else
            table.remove(infested_ents, i)
        end
    end
    --flies orbit the owner
    for i, v in ipairs(orbiting_fly_uids) do
        local fly = get_entity(v)
        local owner_uid = fly_owner_uids[i]
        local owner = get_entity(owner_uid)
        local offset = fly_offset[i]*1.5
        local ox, oy, ol = get_position(owner_uid)
        --if owner is dead then kill these entities
        if owner == nil then
            kill_entity(v)
        end
        if fly ~= nil and owner ~= nil then
            fly.x = ox+math.sin(fly.stand_counter/25-offset)*owner.hitboxx*3+owner.velocityx
            fly.y = oy+math.cos(fly.stand_counter/25-offset)*owner.hitboxy*3+owner.velocityy
        end
    end
end
function reveal_flies()
    set_timeout(function()
        for _, v in ipairs(orbiting_fly_uids) do
            local fly = get_entity(v)
            fly.flags = clr_flag(fly.flags, 1)
            generate_particles(PARTICLEEMITTER.GASTRAIL, fly.uid)
        end
    end, 2)
end

set_callback(reveal_flies, ON.LEVEL)
set_callback(clear_infested_ents, ON.PRE_LEVEL_GENERATION)
set_callback(manage_infested_ents, ON.FRAME)
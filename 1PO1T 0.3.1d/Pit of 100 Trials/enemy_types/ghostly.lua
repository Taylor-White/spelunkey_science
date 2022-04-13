ghostly_ents = {}

function spawn_as_ghostly(type, x, y, l, xvel, yvel)
    local ent = get_entity(spawn(type, x, y, l, xvel, yvel))
    ent.color.r = 0.3
    ent.color.b = 0.8
    ent.color.g = 0.3
    ent.color.a = 1
    table.insert(ghostly_ents, ent.uid)
    table.insert(ghostly_ents_a, ent.color.a)
    return ent.uid
end
function clear_ghostly_ents()
    ghostly_ents = {}
    ghostly_ents_a = {}
end
function manage_ghostly_ents()
    for i, v in ipairs(ghostly_ents) do
        local ent = get_entity(v)
        if ent ~= nil and players[1] ~= nil then
            local ex, ey, el = get_position(v)
            local px, py, pl = get_position(players[1].uid)
            --determine if the entity should be untouchable or not
            local player_looking_at = false
            if not test_flag(players[1].flags, 17) then
                if px < ex then
                    player_looking_at = true
                end
            else
                if px > ex then
                    player_looking_at = true
                end
            end
            if player_looking_at and ent.state ~= 18 and distance(players[1].uid, v) < 7.5 then
                ent.color.r = 0.3
                ent.color.b = 0.8
                ent.color.g = 0.3
                ghostly_ents_a[i] = 0.2
                ent.flags = set_flag(ent.flags, 4)
                ent.flags = set_flag(ent.flags, 6)
            else
                ent.color.r = 0.3
                ent.color.b = 0.8
                ent.color.g = 0.3
                ghostly_ents_a[i] = 1
            end
            --move alpha at a linear rate
            if ent.color.a > ghostly_ents_a[i] then
                ent.color.a = ent.color.a - 0.02
            end
            if ent.color.a < ghostly_ents_a[i] then
                ent.color.a = ent.color.a + 0.02
            end
            if ent.color.a >= 1 then
                ent.flags = clr_flag(ent.flags, 4)
                ent.flags = clr_flag(ent.flags, 6)
            end

            if ent.health == 0 then
                generate_particles(PARTICLEEMITTER.ALTAR_SMOKE, v)
                ent.x = -900
                ent.y = -900
            end
        end
    end
end

set_callback(clear_ghostly_ents, ON.PRE_LEVEL_GENERATION)
set_callback(manage_ghostly_ents, ON.FRAME)
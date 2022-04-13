recursive_ents = {}
recursive_ents_w = {}
recursive_ents_h = {}
recursive_ents_hx = {}
recursive_ents_hy = {}
recursive_ent_count = {}
recursive_ent_overriden = {}

function spawn_as_recursive(type, x, y, l, xvel, yvel)
    local ent = get_entity(spawn(type, x, y, l, xvel, yvel))
    ent.color.r = 1
    ent.color.g = 0
    ent.color.b = 0.5
    table.insert(recursive_ents, ent.uid)
    table.insert(recursive_ent_count, 1)
    table.insert(recursive_ents_w, ent.width)
    table.insert(recursive_ents_h, ent.height)
    table.insert(recursive_ents_hx, ent.hitboxx)
    table.insert(recursive_ents_hy, ent.hitboxy)
    table.insert(recursive_ent_overriden, false)
    return ent.uid
end
function clear_recursive_ents()
    recursive_ents = {}
    recursive_ents_w = {}
    recursive_ents_h = {}
    recursive_ents_hx = {}
    recursive_ents_hy = {}
    recursive_ent_count = {}
    recursive_ent_overriden = {}
end
function manage_recursive_ents()
    --recursive ents
    for i, v in ipairs(recursive_ents) do
        local ent = get_entity(v)
        local ex, ey, el = get_position(v)
        if ent ~= nil then
            if ent.health == 0 and recursive_ent_count[i] < 3 then
                local id = ent.type.id
                local maxhealth = ent.type.life
                local newhealth = math.ceil(maxhealth/2)
                if newhealth < 1 then newhealth = 1 end
                --spawn the entities
                local ent1 = get_entity(spawn(id, ex-0.5, ey, el, 0, 0.1))
                table.insert(recursive_ent_overriden, false)
                ent1.width = ent.width/1.35
                ent1.height = ent.height/1.35
                ent1.hitboxx = ent.hitboxx/1.6
                ent1.hitboxy = ent.hitboxy/1.6
                ent1.health = newhealth
                ent1.color.r = 1
                ent1.color.g = 0
                ent1.color.b = 0.5
                ent1.flags = set_flag(ent1.flags, 4)
                ent1.flags = set_flag(ent1.flags, 25)
                table.insert(recursive_ents, ent1.uid)
                table.insert(recursive_ent_count, recursive_ent_count[i]+1)
                table.insert(recursive_ents_w, ent1.width)
                table.insert(recursive_ents_h, ent1.height)
                table.insert(recursive_ents_hx, ent1.hitboxx)
                table.insert(recursive_ents_hy, ent1.hitboxy)
                local ent2 = get_entity(spawn(id, ex+0.5, ey, el, 0, 0.1))
                table.insert(recursive_ent_overriden, false)
                ent2.width = ent.width/1.35
                ent2.height = ent.height/1.35
                ent2.hitboxx = ent.hitboxx/1.6
                ent2.hitboxy = ent.hitboxy/1.6
                ent2.health = newhealth
                ent2.color.r = 1
                ent2.color.g = 0
                ent2.color.b = 0.5
                ent2.flags = set_flag(ent2.flags, 4)     
                ent2.flags = set_flag(ent2.flags, 25)               
                table.insert(recursive_ents, ent2.uid)
                table.insert(recursive_ent_count, recursive_ent_count[i]+1)
                table.insert(recursive_ents_w, ent2.width)
                table.insert(recursive_ents_h, ent2.height)
                table.insert(recursive_ents_hx, ent2.hitboxx)
                table.insert(recursive_ents_hy, ent2.hitboxy)
                generate_particles(PARTICLEEMITTER.UFOLASERSHOTHITEFFECT_BIG, v)
                if distance(players[1].uid, v) < 10 then
                    play_vanilla_sound(VANILLA_SOUND.ITEMS_CLONE_GUN)
                end
                ent.x = -900
                kill_entity(v)
                --make newly spawned ents invincible for a few frames
                set_timeout(function()
                    ent2.flags = clr_flag(ent2.flags, 4)       
                    ent1.flags = clr_flag(ent1.flags, 4)       
                    ent2.flags = clr_flag(ent2.flags, 25)
                    ent1.flags = clr_flag(ent1.flags, 25)
                end, 10)
            end
        end
    end
    for i, v in ipairs(recursive_ents) do
        local ent = get_entity(v)
        if ent ~= nil and recursive_ent_overriden[i] == false then
            recursive_ent_overriden[i] = true
            set_post_statemachine(v, function()
                if players[1] ~= nil then
                    if players[1].health > 0 then
                        local widthbig = recursive_ents_w[i]*1.25
                        ent.width = recursive_ents_w[i]
                        ent.height = recursive_ents_h[i]
                        ent.hitboxx = recursive_ents_hx[i]
                        ent.hitboxy = recursive_ents_hy[i]
                        if ent.stun_timer < 45 and math.fmod(ent.stun_timer, 6) == 1 then
                            ent.width = widthbig
                        end
                        if ent.stun_timer < 45 and math.fmod(ent.stun_timer, 5) == 1 then
                            ent.width = widthbig*0.9
                        end
                    end
                end
            end)
        end 
    end
end

set_callback(clear_recursive_ents, ON.PRE_LEVEL_GENERATION)
set_callback(manage_recursive_ents, ON.FRAME)
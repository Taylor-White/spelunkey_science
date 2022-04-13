exit_unlocked_functions = {}
monster_death_functions = {}
PO1T_ON = {
    EXIT_UNLOCKED = 1;
    MONSTER_DEATH = 2;
}
function set_po1t_callback(fun, event)
    if event == PO1T_ON.EXIT_UNLOCKED then
        table.insert(exit_unlocked_functions, fun)
    end
    if event == PO1T_ON.MONSTER_DEATH then
        table.insert(monster_death_functions, fun)
    end
end
function run_po1t_callback(event, ctx)
    if event == PO1T_ON.EXIT_UNLOCKED then
        for _, v in ipairs(exit_unlocked_functions) do
            v()
        end
    end
    if event == PO1T_ON.MONSTER_DEATH then
        for _, v in ipairs(monster_death_functions) do
            v(ctx)
        end
    end
end
function clear_po1t_callback(cb)

end
function hook_monster_death()
    for _, v in ipairs(get_entities_by_type(enemies)) do
        local ent = get_entity(v)
        if (ent.health == 0 or test_flag(ent.flags, 29)) and not test_flag(ent.more_flags, 32) then --kind of dirty, but im using more_flags 32 since its unused to check for initial death.
            ent.more_flags = set_flag(ent.more_flags, 32)
            local ctx = ent.uid
            run_po1t_callback(PO1T_ON.MONSTER_DEATH, ctx)
        end
        if not test_flag(ent.flags, 29) and test_flag(ent.more_flags, 32) then
            ent.more_flags = clr_flag(ent.flags, 32)
        end
    end
end

set_callback(hook_monster_death, ON.FRAME)

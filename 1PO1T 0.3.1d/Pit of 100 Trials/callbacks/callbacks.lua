exit_unlocked_functions = {}
PO1T_ON = {
    EXIT_UNLOCKED = 1;
}
function set_po1t_callback(fun, event)
    if event == PO1T_ON.EXIT_UNLOCKED then
        table.insert(exit_unlocked_functions, fun)
    end
end
function run_po1t_callbacks(event)
    if event == PO1T_ON.EXIT_UNLOCKED then
        for _, v in ipairs(exit_unlocked_functions) do
            v()
        end
    end
end
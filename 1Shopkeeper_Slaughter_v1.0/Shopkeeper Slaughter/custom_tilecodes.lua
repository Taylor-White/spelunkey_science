set_pre_tile_code_callback(function(x, y, layer)
    local shoppie_generator = get_entity(spawn(ENT_TYPE.FLOOR_FACTORY_GENERATOR, x, y, layer, 0, 0))
    table.insert(shoppie_generators, shoppie_generator.uid)
end, "shoppie_generator")
--these lua files should contain the spawn functions, the ai for the enemy type and the callback for their ai code
require "enemy_types/armored"
require "enemy_types/cursed"
require "enemy_types/explosive"
require "enemy_types/ghostly"
require "enemy_types/gilded"
require "enemy_types/infested"
require "enemy_types/shadow"
require "enemy_types/recursive"
require "enemy_types/caveman_as_lizard"
require "enemy_types/caveman_as_snake"

function is_ceiling_enemy(id)
    if id == ENT_TYPE.MONS_BAT or id == ENT_TYPE.MONS_SPIDER or id == ENT_TYPE.MONS_GIANTSPIDER or id == ENT_TYPE.MONS_HANGSPIDER or id == ENT_TYPE.MONS_IMP or id == ENT_TYPE.MONS_VAMPIRE or id == ENT_TYPE.MONS_VLAD then
        return true
    end
    return false
end

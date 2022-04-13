--This holds tons of variables that control the custom gamemode
local game_controller = {
    default_music_volume = 0.2; --can be changed via settings, i think this amount is good..
    paused_music_volume = 0.02; --these don't have to be changed. btw.

    enemy_with_key = -1; --UID of entity holding the exit key
    exit_key_effect_uid = -1;
    exit_key_uid = -1;
    exit_key_last_known_x = 0;
    exit_key_last_known_y = 0;

    progress = 0;
    floor = 1;
    enemies_left = 0;
    spawn_x = 0;
    spawn_y = 0;
    exit_spawned = false;
    godmode_graceperiod = 120; --player needs a short bit of time to react to the now spawning enemies, would be kinda unfair otherwise
    current_theme = THEME.DWELLING;
    current_world = 1;

    camp_music_playing = false;

    max_health = 5; --can be increased

    current_floor_width = 2;
    current_floor_height = 2;

    special_playerbags = {}; --UIDs of playerbags that should do something special when picked up (usually give perks)
    special_playerbag_effects = {}; --the effect each playerbag should give.

    brokenkapala_timer = 120;
    brokenkapala_timer_max = 120;

    enemy_spawner_max_x = 22;
    enemy_spawner_max_y = 107;
    
    kapala_blood_previous = 0;

    equipped_perks = {};
    equipped_perks_amount = {}; --how many of a given perk are equipped
    
    ammo = 0;
    has_midastouch = 0;
    has_crateperk = 0;
    has_returnpostage = 0;
    has_brokenkapala = 0;
    has_payoffpain = 0;
    has_payoffpain_start = 0;
    has_stunshield = 0;
    has_sparkshield = 0;
    has_firewhip = 0;
    has_groundpound = 0;

    firewhip_front_spawned = false;
    firewhip_back_spawned = false;

    shotgun_fired = false; --basically used for the clicking effect the shotgun makes when its out of ammo.

    yangchallenge_showmessage = false; --used so the message yang says isnt spammed over and over
    yangchallenge_buymessage = false;
    yangchallenge_active = false;
    yangchallenge_spawned = false; --whether or not yang has been spawned
    yangchallenge_spawntime = 1800;
    yangchallenge_angry = false; --whether or not you have pissed off yang (wont drop better loot + his brothers show up)

    cursed_ent = -1;
    cursed_ent_challenge = false;
    cursed_ent_challenge_index = 0;

    is_key_level = false; --used to determine if a key should spawn on this level
    activate_shrink = false;
    is_shrunk = false;

    --groundpound
    groundpound_timer = 31;
    can_groundpound = false;
    can_breakfloor = true;
    crush_floor = -1;

    --BUTTERFLYKNIFE
    butterflyknife_machetes = {}; --butterfly knife overrides machetes with a custom texture, their UIDs are stored here
    player_is_holding_butterflyknife = false;
    player_was_holding_butterflyknife = false; --used for level transitions to turn a machete into a butterfly knife

    custom_pickup = nil; --used for picking up custom items (ammo, perks etc.)
    custom_pickup_texture = nil; --what texture to use

    player_health_previous = 0;
    player_sparktrap_uid = nil;
    sparkshield_timer = 600;

    boss_ceiling_spawned = false;
    boss_intro_music_stop = false;
    boss_started = false;

    text_scaling = 1; --this amount is multiplied by the size of text so that it is constant regardless of resolution
    
    --miniboss room
    miniboss_active = 0;
    miniboss_walls = {};
    miniboss_enemies = {};
    miniboss_x = 0;
    miniboss_y = 0;
    --repel gel
    repelgel_active = false;
    repelgel_health_before_use = 0;
}

return game_controller
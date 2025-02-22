extends Node2D

signal player_shieldhp_change(new_value)
signal player_xp_change(new_value)
signal level_up(new_value, play_effect)
signal update_score(new_value)
signal update_round_info(score, time)

signal play_sound(sound_name)
signal spawn_xp_shards(amount, position)

signal on_main_menu_entry()
signal on_game_start()
signal game_over()
signal game_reset()

extends Node

signal recalculate_navmesh

signal add_key(key_name:String)
signal add_enemy(enemy_pos:Vector2, is_still:bool)
signal add_enemy_to_player(the_enemy:enemy)
signal add_player_to_enemy(the_player:player)

signal shake_camera
signal stop_shake_camera

signal should_player_move(can_move:bool)

signal display_energy(en_current:float, en_max:float)
signal player_sprinting(sprint:bool)
signal can_still_sprint(sprintable:bool)

signal game_over

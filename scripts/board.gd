class_name BitLevel
extends Node2D

@export var point_list:Node
@export var is_single_level:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.recalculate_navmesh.connect(_on_recalculate_navmesh)
	EventBus.add_enemy.connect(_on_add_enemy)
	AudioManager.load_amb_from_link("res://audio/ambience/drone.mp3")

func _on_recalculate_navmesh():
	$NavigationRegion2D.bake_navigation_polygon()

func _on_add_enemy(start_point:Vector2, is_still:bool):
	print("added enemy")
	var new_enemy:enemy = preload("res://scenes/enemy_node.tscn").instantiate()
	new_enemy.global_position = start_point
	new_enemy.scale = Vector2(0.1, 0.1)
	if is_still:
		new_enemy.starting_mode = new_enemy.EEnemyMode.STILL
	else:
		new_enemy.starting_mode = new_enemy.EEnemyMode.FOLLOWING
	new_enemy.list_of_random_points = point_list.get_children()
	call_deferred("add_child", new_enemy)

func get_level_warp():
	return $level_warp

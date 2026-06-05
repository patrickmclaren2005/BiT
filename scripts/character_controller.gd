class_name player
extends CharacterBody2D

enum EMovementState {
	NONE,
	STANDARD,
	NO_SPRINT
}

@export var speed = 200
@export var sprint_speed = 400
@export var vision_range = 100
@export var the_enemy:enemy
@export var energy_max:float = 4
@export var energy_decay_rate:float = 1
@export var starting_movement_state:EMovementState = EMovementState.STANDARD

@onready var anim = $animator
@onready var sprint_handler = $sprint_handler

var key_list:Dictionary[String, bool] = {}

var is_sprinting:bool = false
var energy_level:float
var can_sprint:bool = true
var can_move:bool = true
var movement_state:EMovementState

func _ready():
	EventBus.add_key.connect(add_key)
	EventBus.add_enemy_to_player.connect(_on_enemy_added)
	EventBus.can_still_sprint.connect(change_sprint_state)
	EventBus.should_player_move.connect(change_can_move)
	
	energy_level = energy_max
	movement_state = starting_movement_state
	
	anim.play("pulse")

func get_input():
	if movement_state != EMovementState.NONE and can_move:
		var dir = Input.get_vector("left", "right", "up", "down")
		if Input.is_action_pressed("run") and can_sprint and movement_state != EMovementState.NO_SPRINT and dir != Vector2.ZERO: 
			is_sprinting = true
		else:
			is_sprinting = false
		
		var current_speed = sprint_speed if is_sprinting and movement_state != EMovementState.NO_SPRINT else speed
		velocity = dir * current_speed

func check_field_of_view():
	if the_enemy:
		if is_enemy_visible_in_fov(the_enemy):
			the_enemy.on_enter_fov()
		else:
			the_enemy.on_exit_fov()

func handle_sprinting(delta:float):
	sprint_handler.handle_sprint(delta, is_sprinting)

func _physics_process(delta: float) -> void:
	check_field_of_view()
	get_input()
	move_and_slide()
	handle_sprinting(delta)

func is_enemy_visible_in_fov(enemy_body:Node2D) -> bool:
	if global_position.distance_to(enemy_body.global_position) > vision_range:
		return false
	
	var space = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, enemy_body.global_position)
	query.exclude = [self]
	query.collide_with_areas = false
	query.collide_with_bodies = true
	
	query.collision_mask = 2
	
	var result = space.intersect_ray(query)
	if result:
		if result is not door:
			return false
	return true

func _on_enemy_added(new_enemy:enemy):
	the_enemy = new_enemy
	EventBus.add_player_to_enemy.emit(self)

func add_key(key_name:String):
	key_list[key_name] = true
func use_key(key_name:String):
	if key_list.has(key_name):
		key_list[key_name] = false
	else:
		push_error("Error: Key not found in key list")
func has_key(key_name:String) -> bool:
	return key_list.has(key_name)

func change_sprint_state(state:bool):
	can_sprint = state

func change_can_move(_can_move:bool):
	can_move = _can_move

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is enemy:
		AudioManager.kill_em_all()
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")

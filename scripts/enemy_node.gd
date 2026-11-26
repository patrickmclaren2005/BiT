class_name enemy
extends CharacterBody2D

enum EEnemyMode {
	NONE,
	CHASING,
	FOLLOWING,
	STILL,
	DISABLED,
	MODE_COUNT
}

@export var movement_speed = 60
@export var vision_range = 100
@export var enemy_colour:Color = Color(1,0,0,1)
@export var player_to_chase:player
@export var random_points:Node
@export var starting_mode:EEnemyMode = EEnemyMode.FOLLOWING
@export var can_vent:bool = false
@export var vent_timer_length:float = 0

@onready var nav_agent = $NavigationAgent2D
@onready var sprite = $Sprite2D
@onready var jump_audio = $jumpscare_sfx
@onready var jump_audio_timer = $jumpscare_sfx/jumpscare_timer
@onready var footstep_audio = $footstep
@onready var footstep_timer = $footstep/footstep_timer
@onready var on_screen_enabler = $on_screen
@onready var vent_audio = $vent_sfx

const nav_check_radius:float = 16.0

var current_enemy_mode:EEnemyMode = EEnemyMode.NONE
var list_of_random_points:Array = []
var is_visible:bool = false
var start_point:Vector2
var current_point
var vent_timer:float

func setup(start_mode:EEnemyMode):
	starting_mode = start_mode

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!player_to_chase) or current_enemy_mode != EEnemyMode.CHASING:
		return
	set_movement_target(player_to_chase.global_position)

func _ready() -> void:
	if (GlobalSettings.monster_enabled == false):
		self.queue_free()
	$Sprite2D.material.set_shader_parameter("nodeColour", enemy_colour)
	nav_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	if random_points:
		list_of_random_points = random_points.get_children()
	if can_vent:
		vent_timer = vent_timer_length
	set_enemy_mode(starting_mode)
	nav_agent.max_speed = movement_speed
	start_point = global_position
	EventBus.add_player_to_enemy.connect(_on_player_assigned)
	EventBus.add_enemy_to_player.emit(self)
	
	if !OS.has_feature("editor"):
		nav_agent.debug_enabled = false

func set_movement_target(movement_target: Vector2):
	nav_agent.set_target_position(movement_target)
	if current_enemy_mode == EEnemyMode.FOLLOWING:
		current_point = movement_target

func _on_player_assigned(new_player:player):
	player_to_chase = new_player

func _physics_process(delta):
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer2D.map_get_iteration_id(nav_agent.get_navigation_map()) == 0 or current_enemy_mode == EEnemyMode.DISABLED:
		return
	check_if_player_in_range()
	if nav_agent.is_navigation_finished():
		if current_enemy_mode == EEnemyMode.FOLLOWING:
			select_new_random_point()
		elif current_enemy_mode == EEnemyMode.CHASING:
			set_movement_target(player_to_chase.global_position)
		return
	
	if !nav_agent.is_target_reachable():
		if is_monster_trapped():
			if !on_screen_enabler.is_on_screen() and can_vent:
				handle_venting(delta)
	
	var next_path_position: Vector2 = nav_agent.get_next_path_position()
	var new_velocity: Vector2 = global_position.direction_to(next_path_position) * movement_speed
	if nav_agent.avoidance_enabled:
		nav_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)
	handle_footsteps()

func _on_velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
	move_and_slide()

func handle_footsteps():
	if footstep_timer.time_left <= 0:
		footstep_timer.start()
		footstep_audio.play()

func handle_venting(delta:float):
	if on_screen_enabler.is_on_screen():
		vent_timer = vent_timer_length
	else:
		vent_timer -= delta
		if vent_timer <= 0:
			vent()
			vent_timer = vent_timer_length

func vent():
	global_position = list_of_random_points.pick_random().global_position
	vent_audio.play()

func set_enemy_mode(mode:EEnemyMode):
	if (mode == current_enemy_mode):
		return
	current_enemy_mode = mode
	match mode:
		EEnemyMode.FOLLOWING:
			if current_point != null:
				set_movement_target(current_point)

func on_enter_fov():
	if !is_visible:
		$animator.play("fade_in")
		is_visible = true
		if jump_audio_timer.time_left <= 0:
			jump_audio.play()
			jump_audio_timer.start()
func on_exit_fov():
	if is_visible:
		$animator.play("fade_out")
		is_visible = false

func check_if_player_in_range():
	if !player_to_chase:
		return
	var in_range = is_enemy_visible_in_fov(player_to_chase)
	if in_range or player_to_chase.is_sprinting:
		set_enemy_mode(EEnemyMode.CHASING)
	elif current_enemy_mode == EEnemyMode.CHASING:
		set_enemy_mode(EEnemyMode.FOLLOWING)

func is_enemy_visible_in_fov(enemyBody:Node2D) -> bool:
	if !enemyBody:
		return false
	if global_position.distance_to(enemyBody.global_position) > vision_range:
		return false
	
	var space = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, enemyBody.global_position)
	query.exclude = [self]
	query.collide_with_areas = false
	query.collide_with_bodies = true
	
	var result = space.intersect_ray(query)
	if result.has("collider"):
		var result_collider = result.collider
		if result_collider:
			if result_collider is not CharacterBody2D:
				return false
	return true

func select_new_random_point():
	var new_point:Vector2 = list_of_random_points.pick_random().global_position
	if (new_point != current_point or list_of_random_points.size() <= 1):
		set_movement_target(new_point)
	else:
		select_new_random_point()

func is_monster_trapped() -> bool:
	var path = nav_agent.get_current_navigation_result().path
	if path.is_empty():
		return true
	var final_point = path[path.size()-1]
	var divided = final_point.distance_to(nav_agent.target_position) >= nav_check_radius
	
	return divided

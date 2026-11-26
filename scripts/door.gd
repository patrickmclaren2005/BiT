class_name door
extends Sprite2D

@export var is_open:bool = false
@export var key_value:String = ""
@export var door_unlocked = true
@export var door_key_colour:Color

@onready var collider = $StaticBody2D/CollisionShape2D
@onready var nav_obstacle = $NavigationObstacle2D
@onready var key_indicator = $key_indicator
@onready var door_audio = $door_sound
@onready var unlock_audio = $key_indicator/unlock_sound

var is_player_in_range = false
var the_player:player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_open:
		open_door()
		unlock_door()
	if door_unlocked:
		unlock_door()
	else:
		key_indicator.material.set_shader_parameter("node_colour", door_key_colour)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and is_player_in_range:
		if door_unlocked:
			change_open_state(!is_open)
		else:
			if the_player.has_key(key_value):
				unlock_door()
			else:
				print("No key detected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func open_door():
	collider.disabled = is_open
	nav_obstacle.affect_navigation_mesh = !is_open
	door_audio.play()
	EventBus.recalculate_navmesh.emit()
	if (is_open):
		material.set_shader_parameter("current_alpha", 0.5);
		key_indicator.material.set_shader_parameter("current_alpha", 0.5);
	else:
		material.set_shader_parameter("current_alpha", 1.0)
		key_indicator.material.set_shader_parameter("current_alpha", 1.0)

func change_open_state(open):
	if (is_open == open):
		return
	else:
		is_open = open
		open_door()

func unlock_door():
	door_unlocked = true
	key_indicator.visible = false
	unlock_audio.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is player:
		is_player_in_range = true
		the_player = body

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is player:
		is_player_in_range = false

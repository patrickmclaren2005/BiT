class_name door_key
extends Node2D

@export var key_name:String = ""
@export var key_colour:Color
@export var rotation_speed = 10

@onready var sprite = $Sprite2D

var is_player_within_range = false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact") and is_player_within_range:
		EventBus.add_key.emit(key_name)
		print("Obtained key " + key_name)
		self.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.material.set_shader_parameter("node_colour", key_colour)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite.rotate(deg_to_rad(rotation_speed*delta))


func _on_pickup_range_body_entered(body: Node2D) -> void:
	if body is player:
		is_player_within_range = true


func _on_pickup_range_body_exited(body: Node2D) -> void:
	if body is player:
		is_player_within_range = false

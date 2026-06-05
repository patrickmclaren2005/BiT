extends Node2D

@export var node_colour:Color = Color(1.0, 1.0, 1.0, 1.0)

@onready var sprite = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_colour()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_colour():
	sprite.material.set_shader_parameter("nodeColour", node_colour)

extends Node2D

enum EGeneratorState {
	BLANK,
	OFF,
	TURNING_ON,
	ON,
	TURNING_OFF
}

@onready var detection_area = $Area2D
@onready var anim = $AnimationPlayer

@export var is_on:bool = false

var generator_state:EGeneratorState = EGeneratorState.BLANK

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generator_state = EGeneratorState.ON if is_on else EGeneratorState.OFF


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match generator_state:
		EGeneratorState.OFF:
			anim.play("off")
		EGeneratorState.ON:
			anim.play("on")
		EGeneratorState.TURNING_ON:
			anim.play("turn_on")
			anim.speed_scale = 1.0
		EGeneratorState.TURNING_OFF:
			anim.play("turn_on")
			anim.speed_scale = -1.0

func handle_activation():
	if generator_state != EGeneratorState.ON:
		if Input.is_action_pressed("interact"):
			generator_state = EGeneratorState.TURNING_ON
		elif generator_state != EGeneratorState.OFF:
			generator_state = EGeneratorState.TURNING_OFF

func _unhandled_input(event: InputEvent) -> void:
	for body in detection_area.get_overlapping_bodies():
		if body is player:
			handle_activation()

func set_on():
	generator_state = EGeneratorState.ON
	AudioManager.load_play_sfx(AudioReference.sfx_generator_finish)

func set_off():
	generator_state = EGeneratorState.OFF

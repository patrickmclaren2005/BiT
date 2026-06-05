extends Node

@export var sprint_max:float = 1
@export var sprint_decay_rate:float = 1
@export var sprint_restore_rate:float = 0.05
@export var sprint_timer_cooldown:float = 2

@onready var timer = $sprint_timer

var sprint_energy:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = sprint_timer_cooldown
	sprint_energy = sprint_max

func handle_sprint(delta:float, sprinting:bool):
	if sprinting:
		sprint_energy -= sprint_decay_rate*delta
		timer.start()
	elif timer.time_left <= 0:
		sprint_energy += sprint_restore_rate*delta
		sprint_energy = minf(sprint_energy, sprint_max)
	EventBus.display_energy.emit(sprint_energy, sprint_max)

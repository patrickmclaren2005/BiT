extends ProgressBar

@export var decrease_rate = 20
@export var increase_rate = 10
@export var rest_time = 2

var is_sprinting:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.player_sprinting.connect(_on_sprint_change)
	EventBus.display_energy.connect(_on_sprint_current_change)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	EventBus.can_still_sprint.emit(value > 0)

func _on_sprint_change(sprint:bool):
	is_sprinting = sprint

func _on_sprint_current_change(current:float, max:float):
	value = minf(current/max, max)

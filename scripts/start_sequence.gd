extends Control

@onready var contents = $VBoxContainer
@onready var butt = $VBoxContainer/Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.load_amb_from_link("res://audio/ambience/drone.mp3")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	TimeManager.start_speedrun_timer()
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")

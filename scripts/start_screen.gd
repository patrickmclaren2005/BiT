extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_game_button_pressed() -> void:
	AudioManager.load_play_sfx(AudioReference.sfx_ui_button_click)
	get_tree().change_scene_to_file("res://scenes/start_sequence.tscn")


func _on_level_select_button_pressed() -> void:
	AudioManager.load_play_sfx(AudioReference.sfx_ui_button_click)
	get_tree().change_scene_to_file("res://scenes/title_screens/level_select.tscn")

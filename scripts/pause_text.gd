extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		if get_tree().paused:
			hide()
			get_tree().paused = false
		else:
			get_tree().paused = true
			show()


func _on_button_pressed() -> void:
	get_tree().paused = false
	$sound_options.visible = false
	$main_pause.visible = false
	AudioManager.load_play_sfx(AudioReference.sfx_ui_button_back_click)
	get_tree().change_scene_to_file("uid://bk7umdm7y5bl2")


func _on_to_sound_pressed() -> void:
	$sound_options.visible = true
	$main_pause.visible = false


func _on_sound_options_visibility_changed() -> void:
	if $sound_options.visible == false:
		$main_pause.visible = true

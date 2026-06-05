extends Control


func _on_button_pressed() -> void:
	AudioManager.load_play_sfx(AudioReference.sfx_ui_button_back_click)
	get_tree().change_scene_to_file("uid://bk7umdm7y5bl2")

extends Button

@export var attach_level:PackedScene
var instant

func can_switch_to_level() -> bool:
	if !attach_level:
		print("Error: No Level Detected")
		return false
	instant = attach_level.instantiate()
	if !instant:
		print("Error: Instant is null")
		return false
	if instant is not BitLevel:
		print("Error: Attached script is not proper bitLevel script")
		return false
	var level_warp = instant.get_level_warp()
	if !level_warp:
		print("Error: Level warp is null")
		return false
	if level_warp is not bit_level_warp:
		print("Error: level_warp is not bit_level_warp")
		return false
	level_warp.change_single_level(true)
	return true


func _on_pressed() -> void:
	if can_switch_to_level():
		get_tree().change_scene_to_node(instant)

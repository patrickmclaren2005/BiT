extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("RESET")
	EventBus.shake_camera.connect(screen_shake)
	EventBus.stop_shake_camera.connect(stop_screen_shake)

func screen_shake():
	$AnimationPlayer.play("screen_shake")

func stop_screen_shake():
	$AnimationPlayer.play("RESET")

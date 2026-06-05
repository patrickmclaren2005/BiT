extends Control

@onready var anim = $AnimationPlayer
@onready var final_time = $final_time
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.kill_em_all()
	TimeManager.pause_speedrun_timer()
	anim.play("end_cred")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	var total_seconds = TimeManager.time_in_seconds
	
	var hours = int(total_seconds) / 3600
	var minutes = int(total_seconds) / 60
	var seconds = int(total_seconds) % 60
	var milliseconds = int((total_seconds - int(total_seconds))*1000)
	
	var timestamp = "%02d:%02d:%02d.%02d" % [hours, minutes, seconds, milliseconds]
	final_time.text = "Final Time: " + timestamp

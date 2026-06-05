class_name bit_level_warp
extends Area2D

@export var level_name:String 

@export var next_scene:PackedScene
@export var audio_clip:AudioStream
@export var door_to_lock:door
@export var timer_load_time:float = 4

@onready var load_timer = $Timer

var is_activated = false
var is_single_level = false

func _on_body_entered(body: Node2D) -> void:
	if body is player and is_activated == false:
		if door_to_lock:
			door_to_lock.door_unlocked = false
		
		is_activated = true
		EventBus.shake_camera.emit()
		if audio_clip:
			AudioManager.load_play_voice(audio_clip)
			await AudioManager.voice.finished
		load_timer.start(timer_load_time)
		EventBus.should_player_move.emit(false)

func load_scene():
	EventBus.should_player_move.emit(true)
	if is_single_level == false:
		get_tree().change_scene_to_packed(next_scene)
	else:
		get_tree().change_scene_to_file("uid://wvy2l3hg0k85")


func _on_timer_timeout() -> void:
	load_scene()

func change_single_level(single:bool):
	is_single_level = single

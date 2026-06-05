extends Node

var time_in_seconds:float
var started:bool = false

func _process(delta):
	if started:
		time_in_seconds += delta

func start_speedrun_timer():
	started = true

func stop_speedrun_timer():
	started = false
	time_in_seconds = 0

func pause_speedrun_timer():
	started = false

extends Node

@onready var amb = $amb
@onready var voice = $voice
@onready var sfx = $sfx

func _ready():
	print(get_children())

func kill_em_all():
	for i in get_children():
		if i is AudioStreamPlayer:
			i.stop()

func load_amb(clip:AudioStream):
	amb.stream = clip

func play_amb():
	amb.play()

func load_play_amb(clip:AudioStream):
	amb.stream = clip
	amb.play()

func stop_amb():
	amb.stop()

func load_amb_from_link(link):
	var amb_stream:AudioStream = load(link)
	if amb_stream == null:
		push_error("amb_stream is null")
		return
	amb.stream = amb_stream
	amb.play()

func load_voice(clip:AudioStream):
	voice.stream = clip

func play_voice():
	voice.play()

func load_play_voice(clip:AudioStream):
	voice.stream = clip
	voice.play()

func stop_voice():
	voice.stop()

func load_play_sfx(clip:AudioStream):
	sfx.stream = clip
	sfx.play()

func load_sfx_from_link(link:String):
	var sfx_stream:AudioStream = load(link)
	if sfx_stream == null:
		push_error("sfx_stream is null")
		return
	sfx.stream = sfx_stream
	sfx.play()

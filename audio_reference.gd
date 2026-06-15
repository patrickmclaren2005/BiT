extends Node

# LEVEL STUFF
@export_group("Environment Audio")
@export var sfx_door_open:AudioStream
@export var sfx_door_close:AudioStream
@export var sfx_generator_finish:AudioStream

# ENEMY STUFF
@export_group("Enemy Audio")
@export var sfx_enemy_footstep:AudioStream
@export var sfx_enemy_vent:AudioStream
@export var sfx_enemy_jumpscare:AudioStream

# VOICE LINES
@export_group("Voicelines")
@export var voice_call_for_help:AudioStream

# UI AND MENU STUFF
@export_group("UI Audio")
@export var sfx_ui_button_click:AudioStream
@export var sfx_ui_button_back_click:AudioStream

# AMBIENCE
@export_group("Ambience")
@export var amb_lab_audio:AudioStream

# MUSIC
@export_group("Music")
@export var mus_title_screen:AudioStream

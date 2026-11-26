class_name sound_menu_node
extends Control

@onready var mas_slider:HSlider = $ReferenceRect/VBoxContainer/master_slider
@onready var mus_slider:HSlider = $ReferenceRect/VBoxContainer/mus_slider
@onready var sfx_slider:HSlider = $ReferenceRect/VBoxContainer/sfx_slider
@onready var amb_slider:HSlider = $ReferenceRect/VBoxContainer/amb_slider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_audio_bus_volume(value:float, name:String):
	var bus_index = AudioServer.get_bus_index(name)
	if !bus_index and bus_index != 0:
		push_error("Error: Invalid audio bus name. " + name + " is not an audio bus name.")
		return
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	save_slider_values()

func _on_master_slider_value_changed(value: float) -> void:
	change_audio_bus_volume(value, "Master")

func _on_mus_slider_value_changed(value: float) -> void:
	change_audio_bus_volume(value, "Music")

func _on_sfx_slider_value_changed(value: float) -> void:
	change_audio_bus_volume(value, "SFX")

func _on_amb_slider_value_changed(value: float) -> void:
	change_audio_bus_volume(value, "Ambience")

func _on_back_pressed() -> void:
	visible = false

func set_slider_values():
	mas_slider.value = GlobalSettings.master_volume
	mus_slider.value = GlobalSettings.mus_volume
	sfx_slider.value = GlobalSettings.sfx_volume
	amb_slider.value = GlobalSettings.amb_volume

func save_slider_values():
	GlobalSettings.master_volume = mas_slider.value
	GlobalSettings.mus_volume = mus_slider.value
	GlobalSettings.sfx_volume = sfx_slider.value
	GlobalSettings.amb_volume = amb_slider.value


func _on_visibility_changed() -> void:
	if visible:
		set_slider_values()

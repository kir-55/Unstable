extends Control

@onready var global_audio_index = AudioServer.get_bus_index("Master")
@export var master_volume_percantage : Label

func _on_h_slider_value_changed(value):
	var volume_db = linear_to_db(value / 100)
	AudioServer.set_bus_volume_db(global_audio_index, volume_db)
	master_volume_percantage.text = str(value) + "%"


func _on_back_pressed():
	GlobalFunctions.load_menu("main", true)

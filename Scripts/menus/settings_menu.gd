extends Control

@export_category("Audio Sliders")
@export var master_slider : Slider
@export var music_slider : Slider
@export var sfx_slider : Slider

@export_category("Audio Labels")
@export var master_volume_percantage : Label
@export var music_volume_percantage : Label
@export var sfx_volume_percantage : Label

@onready var settings := {
	"master_volume": {
		"slider": master_slider,
		"label": master_volume_percantage,
		"bus": "Master",
		"setting": "master_volume"
	},
	"music_volume": {
		"slider": music_slider,
		"label": music_volume_percantage,
		"bus": "Music",
		"setting": "music_volume"
	},
	"sfx_volume": {
		"slider": sfx_slider,
		"label": sfx_volume_percantage,
		"bus": "SFX",
		"setting": "sfx_volume"
	}
}

func _ready():
	for setting_name in settings.keys():
		var setting = settings[setting_name]
		var slider: Slider = setting["slider"]
		var label: Label = setting["label"]
		var setting_key = setting["setting"]
		var bus_name = setting["bus"]
	
		var value = GlobalVariables.settings.get(setting_key, 100)
		slider.value = value
		label.text = str(value) + "%"
		change_bus_volume(bus_name, value)
	
		slider.value_changed.connect(func(val): on_slider_value_changed(bus_name, label, val))
		slider.drag_ended.connect(func(value_changed): 
			if value_changed:
				on_slider_drag_ended(setting_key, slider, value_changed)
		)

func change_bus_volume(bus_name, value):
	var volume_db = linear_to_db(value / 100)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus_name), volume_db)

func on_slider_value_changed(bus_name: String, label: Label, value: float) -> void:
	change_bus_volume(bus_name, value)
	label.text = str(value) + "%"

func on_slider_drag_ended(setting_key: String, slider: Slider, value_changed: bool) -> void:
	if value_changed:
		GlobalVariables.settings[setting_key] = slider.value
		GlobalFunctions.save_player_data()

func _on_back_pressed():
	GlobalFunctions.load_menu("main", true)

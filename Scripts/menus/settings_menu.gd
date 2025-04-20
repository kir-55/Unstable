extends Control

@export_category("Audio Sliders")
@export var master_slider : Slider
@export var music_slider : Slider
@export var sfx_slider : Slider

@export_category("Audio Labels")
@export var master_volume_percantage : Label
@export var music_volume_percantage : Label
@export var sfx_volume_percantage : Label

@export_category("Color Pickers")
@export var color_prefab : PackedScene 
@export var color_picker_container : Control  # Container for dynamically generated color pickers

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

@onready var color_settings := {
	"skin_color": "Skin Color",
	"skin_shadow": "Skin Shadow",
	"ear_color": "Ear Color",

	"hair_color": "Hair Color",
	"hair_shadow": "Hair Shadow",

	"coat_color": "Coat Color",
	"coat_shadow": "Coat Shadow",
	"coat_shadow2": "Coat Shadow 2",

	"tshirt_color": "T-shirt Color",
	"tshirt_shadow": "T-shirt Shadow",

	"pocket_color": "Pocket Color",
	"pocket_color2": "Pocket Color 2",

	"pants_light": "Pants Light",
	"pants_color": "Pants Color",
	"pants_shadow": "Pants Shadow",

	"shoes_light": "Shoes Light",
	"shoes_color": "Shoes Color",
	"shoes_shadow": "Shoes Shadow",

	"glasses_color": "Glasses Color",
	"glasses_frame": "Glasses Frame",
	"glasses_light": "Glasses Light"
}

func _ready():
	# Audio sliders setup
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

	# Color pickers setup
	var y_offset = 0
	for color_key in color_settings.keys():
		var color_instance = color_prefab.instantiate()
		
		# Create a Label for each color
		var label = color_instance.get_node("Label")
		label.text = color_settings[color_key]
		
		# Create a ColorPicker for each color setting
		var color_picker = color_instance.get_node("ColorPickerButton")
		color_picker.color = GlobalVariables.player_colors[color_key]
		color_picker.color_changed.connect(_on_color_changed.bind(color_key))
		
		color_picker_container.add_child(color_instance)

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

func _on_color_changed(new_color: Color, color_key: String) -> void:
	# Update the color in global variables
	GlobalVariables.player_colors[color_key] = new_color
	GlobalFunctions.save_player_data()

func _on_back_pressed():
	GlobalFunctions.load_menu("main", true)

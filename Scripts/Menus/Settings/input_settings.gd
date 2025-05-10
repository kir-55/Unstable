extends VBoxContainer

@export var input_button_scene : PackedScene
@export var action_list : VBoxContainer

var is_user_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"use_amulet_1": "1",
	"use_amulet_2": "2",
	"use_amulet_3": "3",
	"use_amulet_4": "4",
	"use_amulet_5": "5"
}

func _ready():
	_create_action_list()

func _create_action_list():
	for item in action_list.get_children():
		item.queue_free()
	
	for action in GlobalVariables.remappable_actions:
		var button = input_button_scene.instantiate()
		var action_name_label = button.find_child("ActionNameLabel")
		var action_keybind_label = button.find_child("ActionKeybindLabel")
		
		
		action_name_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			action_keybind_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			action_keybind_label.text = ""
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))

func _on_input_button_pressed(button, action):
	if !is_user_remapping:
		is_user_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("ActionKeybindLabel").text = "Press key to bind..."

func _input(event):
	if is_user_remapping:
		if (
			(event is InputEvent and !(event is InputEventMouseMotion)) ||
			(event is InputEventMouseButton && event.pressed)
		):
			if event is InputEventMouseButton:
				event.double_click = false
			
			GlobalFunctions.save_keybind(action_to_remap, event)
			remapping_button.find_child("ActionKeybindLabel").text = event.as_text().trim_suffix(" (Physical)")
			
			
			is_user_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()

func reset_to_defaults():
	for item in action_list.get_children():
		item.queue_free()
	
	for action in GlobalVariables.remappable_actions:
		var button = input_button_scene.instantiate()
		var action_name_label = button.find_child("ActionNameLabel")
		var action_keybind_label = button.find_child("ActionKeybindLabel")
		
		GlobalFunctions.save_keybind(action, GlobalFunctions.get_input_event_from_str(GlobalVariables.default_use_amulet_events[action]))
		action_name_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			action_keybind_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			action_keybind_label.text = ""
			
		print("hmmm")
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func _on_button_pressed():
	reset_to_defaults()

extends VBoxContainer

@export var input_button_scene : PackedScene
@export var action_list : VBoxContainer

var is_user_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"use_amulet_1": "1st Amulet",
	"use_amulet_2": "2nd Amulet",
	"use_amulet_3": "3rd Amulet",
	"use_amulet_4": "4th Amulet",
	"use_amulet_5": "5th Amulet"
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
			action_keybind_label.text = get_keybind_string(events[0])
		else:
			action_keybind_label.text = ""
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))

func _on_input_button_pressed(button, action):
	if !is_user_remapping:
		is_user_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("ActionKeybindLabel").remove_theme_color_override("font_color")
		button.find_child("ActionKeybindLabel").text = "Press key to bind..."

func _input(event):
	if is_user_remapping:
		if (
			(event is InputEvent and !(event is InputEventMouseMotion)) ||
			(event is InputEventMouseButton && event.pressed)
		):
			if event is InputEventMouseButton:
				event.double_click = false
			if event is InputEventJoypadMotion and abs(event.axis_value) < 0.5:
				return
			
			var actions_to_check = input_actions.duplicate()
			for action in GlobalVariables.not_remappable_actions:
				actions_to_check[action] = ""
				
			for action in actions_to_check:
				for action_event in InputMap.action_get_events(action):
					print(event.as_text(), action_event.as_text().trim_suffix(" (Physical)"))
					if get_keybind_string(action_event) == get_keybind_string(event):
						remapping_button.find_child("ActionKeybindLabel").text = "The key is already in use..."
						remapping_button.find_child("ActionKeybindLabel").add_theme_color_override("font_color", Color(1, 0.4, 0.4))
						remapping_button.find_child("Timer").start()
						
						is_user_remapping = false
						action_to_remap = null
						remapping_button = null
						accept_event()
						return
			
			
			
			remapping_button.find_child("ActionKeybindLabel").text = get_keybind_string(event)
			GlobalFunctions.save_keybind(action_to_remap, event)
			
			
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
			
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func _on_button_pressed():
	reset_to_defaults()

func get_keybind_string(event : InputEvent):
	var keybind_label_text
	if event is InputEventJoypadButton:
		keybind_label_text = "Gamepad Button " + str(event.button_index)
	elif event is InputEventJoypadMotion:
		if event.axis == JOY_AXIS_TRIGGER_LEFT:
			keybind_label_text = "Gamepad Trigger Left"
		elif event.axis == JOY_AXIS_TRIGGER_RIGHT:
			keybind_label_text = "Gamepad Trigger Right"
		else:
			keybind_label_text = "Gamepad Axis " + str(event.axis)
	else:
		keybind_label_text = event.as_text().trim_suffix(" (Physical)")
		
	return keybind_label_text

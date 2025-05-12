extends Timer

@export var action_keybind_label : Label
@export var action_name_label : Label

func _on_timeout():
	if !get_parent().get_parent().is_user_remapping:
		action_keybind_label.remove_theme_color_override("font_color")
		var action = get_parent().get_parent().input_actions.find_key(action_name_label.text)
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			action_keybind_label.text = get_parent().get_parent().get_keybind_string(events[0])
		else:
			action_keybind_label.text = ""

extends Node


func _ready():
	create_amulet_use_actions()
	load_player_data()
	load_settings()



func _input(event):
	if Input.is_action_just_pressed("use_amulet_1"):
		print("Akcja use_amulet_1 została uruchomiona!")
	
	if event.is_action_pressed("fullscreen"):  # Check if F11 is pressed
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			GlobalVariables.settings["fullscreen"] = true
			GlobalFunctions.save_player_data()
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			GlobalVariables.settings["fullscreen"] = false
			GlobalFunctions.save_player_data()



# Function to apply the theme to a scene
func apply_theme_to_scene(scene: Node):
	if scene is Control:
		scene.theme = GlobalVariables.global_theme

# This function will be triggered whenever the scene changes
func _on_scene_changed(_from: Node, to: Node):
	apply_theme_to_scene(to)


func reload():
	start_timer()
	Engine.time_scale = 1
	GlobalVariables.last_score = 0
	GlobalVariables.player_global_speed = GlobalVariables.initial_player_speed
	GlobalVariables.game_is_on = true
	print(GlobalVariables.player_amulets)
	#GlobalVariables.player_amulets.clear()
	GlobalVariables.current_epoch_id = randi_range(0, GlobalVariables.epochs.size()-1)
	#GlobalVariables.current_epoch_id = 3
	GlobalVariables.player_amulets.assign(GlobalVariables.initial_player_amulets.duplicate())
	GlobalVariables.player_new_amulets.clear()
	GlobalVariables.times_treveled = 0
	GlobalVariables.terrain_code = randi()
	GlobalVariables.items_in_home = GlobalVariables.initial_items_in_home
	get_tree().change_scene_to_file("res://Scenes/Locations/epoch.tscn")





func start_timer():
	GlobalVariables.time_started = Time.get_ticks_msec()

func end_timer():
	GlobalVariables.time_ended = Time.get_ticks_msec()

func load_settings():
	############################ GRAPHICS SETTINGS #############################
	
	if GlobalVariables.settings["fullscreen"] == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	############################################################################
	
	############################ AUDIO SETTINGS ################################
	
	var bus_to_setting_keys = {
	"Master": "master_volume",
	"Music": "music_volume",
	"SFX": "sfx_volume"
	}
	
	for i in range(AudioServer.bus_count):
		var bus_name = AudioServer.get_bus_name(i)
		if bus_name in bus_to_setting_keys:
			var setting_key = bus_to_setting_keys[bus_name]
			var value = GlobalVariables.settings[setting_key]
			var volume_db = linear_to_db(value / 100)
			AudioServer.set_bus_volume_db(i, volume_db)
	
	############################################################################
	
	############################ KEYBIND SETTINGS ##############################
	
	if GlobalVariables.settings["keybinds"].is_empty():
		for action in GlobalVariables.remappable_actions:
			if action in GlobalVariables.default_use_amulet_events:
				GlobalVariables.settings["keybinds"][action] = GlobalVariables.default_use_amulet_events[action]
			else:
				GlobalVariables.settings["keybinds"][action] = InputMap.action_get_events(action)[0].as_text().trim_suffix(" (Physical)")
			
	elif GlobalVariables.settings["keybinds"].has_all(GlobalVariables.remappable_actions.keys()):
		for action in GlobalVariables.settings["keybinds"]:
				if action in GlobalVariables.remappable_actions:
					var event_name = GlobalVariables.settings["keybinds"].get(action)
					if event_name and (event_name != "" or !(event_name is String)):
						InputMap.action_erase_event(action, InputMap.action_get_events(action)[0])
						InputMap.action_add_event(action, get_input_event_from_str(event_name))

	else:
		var valid_keybinds = {}
		for action in GlobalVariables.settings["keybinds"]:
			if action in GlobalVariables.remappable_actions:
				InputMap.action_erase_event(action, InputMap.action_get_events(action)[0])
				InputMap.action_add_event(action, get_input_event_from_str(GlobalVariables.settings["keybinds"][action]))
				valid_keybinds[action] = GlobalVariables.settings["keybinds"][action]
		GlobalVariables.settings["keybinds"] = valid_keybinds
		
		for action in GlobalVariables.remappable_actions:
			if !(action in valid_keybinds):
				InputMap.action_erase_event(action, InputMap.action_get_events(action)[0])
				InputMap.action_add_event(action, get_input_event_from_str(GlobalVariables.default_use_amulet_events[action]))
	save_player_data()
	
	############################################################################
	

func save_player_data():
	var file = FileAccess.open(GlobalVariables.player_data_path, FileAccess.WRITE)
	if file:
		var serialized_colors = {}
		for key in GlobalVariables.player_colors:
			var color = GlobalVariables.player_colors[key]
			serialized_colors[key] = [color.r, color.g, color.b, color.a]
		
		var data = {
			"best_score": GlobalVariables.best_score,
			"amulet_collection": GlobalVariables.player_amulet_collection,
			"settings": GlobalVariables.settings,
			"player_colors": serialized_colors
		}
		file.store_string(JSON.stringify(data))
		file.close()

func load_player_data():
	var file = FileAccess.open(GlobalVariables.player_data_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		file.close()
		var data = JSON.parse_string(content)
		if data:
			if "best_score" in data:
				GlobalVariables.best_score = data["best_score"]
			if "amulet_collection" in data:
				GlobalVariables.player_amulet_collection.clear()
				for value in data["amulet_collection"]:
					GlobalVariables.player_amulet_collection.append(int(value))
			if "settings" in data:
				for setting in data["settings"]:
					if setting in GlobalVariables.settings:
						GlobalVariables.settings[setting] = data["settings"][setting]
			if "player_colors" in data:
				for key in data["player_colors"]:
					if key in GlobalVariables.player_colors:
						var arr = data["player_colors"][key]
						GlobalVariables.player_colors[key] = Color(arr[0], arr[1], arr[2], arr[3])


func add_amulet(id):
	GlobalVariables.player_amulets.append(id)
	GlobalVariables.on_player_amulets_changed.emit()
	
func remove_amulet(id):
	GlobalVariables.player_amulets.erase(id)
	GlobalVariables.on_player_amulets_changed.emit()

func get_current_menu_instance():
	var canvas_layer = get_tree().current_scene.find_child("CanvasLayer")
	if canvas_layer:
		var menu = canvas_layer.find_child("menu", false, false)
		return menu if menu else null
	else:
		return null

func load_menu(menu: String, remove_all_children = true, transition_to_main = false, menu_instance_callable : Callable = func(x): pass):
	var container = get_tree().current_scene.find_child("CanvasLayer")
	
	if !container:
		#print("Could not find canvas layer. Please add one!")
		return
	
	GlobalVariables.previous_menu = GlobalVariables.current_menu
	
	if transition_to_main:
		GlobalVariables.current_menu = menu
		get_tree().change_scene_to_file("res://Scenes/Locations/main.tscn")
		return
	
	
	if remove_all_children:
		for menu_child in container.get_children():
			container.remove_child(menu_child)
	else:
		for menu_child in container.get_children():
			if menu_child.name == "menu":
				container.remove_child(menu_child)
				break
	
	
	GlobalVariables.current_menu = menu
	var menu_instance = GlobalVariables.menus[menu].instantiate()
	menu_instance.name = "menu"
	menu_instance_callable.call(menu_instance)
	container.add_child(menu_instance)

func save_keybind(action : StringName, event : InputEvent):
	var event_str
	if event is InputEventKey:
		event_str = OS.get_keycode_string(event.physical_keycode)
	elif event is InputEventMouseButton:
		event_str = "mouse_" + str(event.button_index)

	var f = InputMap.action_get_events(action)
	print(f)
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, get_input_event_from_str(event_str))
	
	GlobalVariables.settings["keybinds"][action] = event_str
	save_player_data()

func create_amulet_use_actions():
	for i in range(1, GlobalVariables.max_amulets + 1):
		var action_name = GlobalVariables.use_amulet_action_name + "_" + str(i)
		InputMap.add_action(action_name)
		InputMap.action_add_event(action_name, get_input_event_from_str(GlobalVariables.default_use_amulet_events[action_name]))
		print(InputMap.action_get_events(action_name))
		GlobalVariables.remappable_actions[action_name] = GlobalVariables.default_use_amulet_events[action_name]

func get_input_event_from_str(name : StringName):
	var input_event
	if name.contains("mouse_"):
		input_event = InputEventMouseButton.new()
		input_event.button_index = int(name.split("_")[1])
	else:
		input_event = InputEventKey.new()
		input_event.physical_keycode = OS.find_keycode_from_string(name)
	
	return input_event

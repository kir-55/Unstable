extends Node

func reload():
	start_timer()
	Engine.time_scale = 1
	GlobalVariables.last_score = 0
	GlobalVariables.player_global_speed = GlobalVariables.initial_player_speed
	GlobalVariables.game_is_on = true
	print(GlobalVariables.player_amulets)
	#GlobalVariables.player_amulets.clear()
	GlobalVariables.player_amulets.assign(GlobalVariables.initial_player_amulets.duplicate())
	GlobalVariables.player_new_amulets.clear()
	GlobalVariables.times_treveled = 0
	GlobalVariables.terrain_code = randi()
	GlobalVariables.items_in_home = GlobalVariables.initial_items_in_home
	get_tree().change_scene_to_file("res://Scenes/Locations/city.tscn")


func _ready():
	load_player_data()
	load_settings()


func start_timer():
	GlobalVariables.time_started = Time.get_ticks_msec()

func end_timer():
	GlobalVariables.time_ended = Time.get_ticks_msec()

func load_settings():
	
	############################ AUDIO SETTINGS ###############################
	
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
	
	###########################################################################

func save_player_data():
	var file = FileAccess.open(GlobalVariables.player_data_path, FileAccess.WRITE)
	if file:
		var data = {
			"best_score": GlobalVariables.best_score,
			"amulet_collection": GlobalVariables.player_amulet_collection,
			"settings": GlobalVariables.settings
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

func load_menu(menu: String, remove_all_children = true, transition_to_main = false, menu_instance_callable : Callable = func(x): pass):
	if transition_to_main:
		GlobalVariables.current_menu = menu
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
		return
	
	var container = get_tree().current_scene.find_child("CanvasLayer")
	
	if !container:
		#print("Could not find canvas layer. Please add one!")
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


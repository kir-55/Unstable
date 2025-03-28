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
	GlobalVariables.items_in_home = GlobalVariables.initial_items_in_home
	get_tree().change_scene_to_file("res://Scenes/Locations/city.tscn")


func _ready():
	load_player_data()


func start_timer():
	GlobalVariables.time_started = Time.get_ticks_msec()

func end_timer():
	GlobalVariables.time_ended = Time.get_ticks_msec()

func save_player_data():
	var file = FileAccess.open(GlobalVariables.player_data_path, FileAccess.WRITE)
	if file:
		var data = {
			"best_score": GlobalVariables.best_score,
			"amulet_collection": GlobalVariables.player_amulet_collection
		}
		file.store_string(JSON.stringify(data))
		file.close()

func load_player_data():
	var file = FileAccess.open(GlobalVariables.player_data_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		var data = JSON.parse_string(content)
		if data and "best_score" in data:
			GlobalVariables.best_score = data["best_score"]
		if data and "amulet_collection" in data:
			GlobalVariables.player_amulet_collection.clear()
			for value in data["amulet_collection"]:
				GlobalVariables.player_amulet_collection.append(int(value))
				file.close()

func load_menu(menu: String, remove_all_children = true, transition_to_main = false):
	if transition_to_main:
		GlobalVariables.current_menu = menu
		get_tree().change_scene_to_file("res://Scenes/main.tscn")
		return
	
	var container = get_tree().current_scene.find_child("CanvasLayer")
	
	if !container:
		print("Could not find canvas layer. Please add one!")
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
	container.add_child(menu_instance)


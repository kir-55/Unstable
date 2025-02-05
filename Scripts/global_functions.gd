extends Node

func reload():
	Engine.time_scale = 1
	GlobalVariables.last_score = 0
	GlobalVariables.player_global_speed = GlobalVariables.initial_player_speed
	GlobalVariables.game_is_on = true
	print(GlobalVariables.player_amulets)
	GlobalVariables.player_amulets = []
	GlobalVariables.player_new_amulets = []
	GlobalVariables.times_treveled = 0
	GlobalVariables.items_in_home = GlobalVariables.initial_items_in_home
	get_tree().change_scene_to_file("res://Scenes/Locations/city.tscn")

func load_menu(menu, remove_all_children = true, transition_to_main = false):
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
	
	if menu != GlobalEnums.MENU_LEVEL.NONE:
		GlobalVariables.current_menu = menu
		var menu_instance = load(GlobalVariables.menus[menu]).instantiate()
		menu_instance.name = "menu"
		container.add_child(menu_instance)

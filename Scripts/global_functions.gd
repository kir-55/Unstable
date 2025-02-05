extends Node

func reload():
	Engine.time_scale = 1
	GlobalVariables.last_score = 0
	GlobalVariables.player_global_speed = GlobalVariables.initial_player_speed
	GlobalVariables.game_is_on = true
	print(GlobalVariables.player_amulets)
#	GlobalVariables.player_amulets = [] // what the fu##
	GlobalVariables.times_treveled = 0
	GlobalVariables.items_in_home = GlobalVariables.initial_items_in_home
	get_tree().change_scene_to_file("res://Scenes/Locations/city.tscn")

func load_menu(menu, menu_parent):
	var container = menu_parent
	
	for menu_child in container.get_children():
		if menu_child.name == "menu":
			container.remove_child(menu_child)
			break
	
	if menu != GlobalVariables.MENU_LEVEL.NONE:
		GlobalVariables.current_menu = GlobalVariables.menus[menu].instantiate()
		var menu_instance = GlobalVariables.current_menu
		menu_instance.name = "menu"
		container.add_child(menu_instance)

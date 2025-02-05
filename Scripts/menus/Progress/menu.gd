extends Control



func _on_back_pressed():
	GlobalFunctions.load_menu(GlobalVariables.MENU_LEVEL.MAIN, get_node(get_parent().get_path()))

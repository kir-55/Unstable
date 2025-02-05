extends Control



func _on_back_pressed():
	GlobalFunctions.load_menu(GlobalEnums.MENU_LEVEL.MAIN, true, false)

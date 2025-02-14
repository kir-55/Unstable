extends Control



func _on_back_pressed():
	GlobalVariables.player_new_amulets.clear()
	GlobalFunctions.load_menu("main", true)

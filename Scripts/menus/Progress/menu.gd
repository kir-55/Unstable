extends Control

func _on_back_pressed():
	GlobalVariables.player_new_amulets.clear()
	if GlobalVariables.previous_menu == "game_over":
		var current_menu_instance = GlobalFunctions.get_current_menu_instance()
		if current_menu_instance and current_menu_instance.has_meta("death_message"):
			GlobalFunctions.load_menu("game_over", true, false, func(instance):
				var death_message = current_menu_instance.get_meta("death_message")
				instance.find_child("DeathMessage").append_text("[center][font_size=24][shake rate=20.0 level=3 connected=1][color='#c33c40']" + death_message + "[/color][/shake][/font_size][center]")
				instance.set_meta("death_message", death_message)
			)
		else:
			GlobalFunctions.load_menu("game_over")
	elif GlobalVariables.previous_menu == "win":
		if GlobalVariables.latest_win_type == GlobalEnums.WIN_TYPES.REPAIR:
			GlobalFunctions.load_menu("win", false, false, func(instance):
				instance.win_type = GlobalEnums.WIN_TYPES.REPAIR
				)
		elif GlobalVariables.latest_win_type == GlobalEnums.WIN_TYPES.DESTRUCTION:
			GlobalFunctions.load_menu("win", false, false, func(instance):
				instance.win_type = GlobalEnums.WIN_TYPES.DESTRUCTION
				)
	else:
		GlobalFunctions.load_menu("main", false)

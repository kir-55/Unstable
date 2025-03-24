extends Timer

@export var player: Node2D
@export var current_world: GlobalEnums.LEVELS

func _on_timeout():
	Engine.time_scale = 1
	if GlobalVariables.game_is_on:
		GlobalVariables.last_score = GlobalVariables.last_score + int(player.global_position.x) / GlobalVariables.score_divider
		GlobalVariables.last_epoch = current_world
		
		if GlobalVariables.win_after_next_epoch:
			GlobalVariables.win_after_next_epoch = false
			get_tree().change_scene_to_file("res://Scenes/Menus/progress_menu.tscn")
			return
		
		if GlobalVariables.player_amulets.has(5):
			GlobalVariables.player_amulets.remove_at(GlobalVariables.player_amulets.find(5))
		
		
		GlobalVariables.next_epoch = GlobalEnums.LEVELS[GlobalEnums.LEVELS.keys()[randi() % GlobalEnums.LEVELS.size()]]
		while GlobalVariables.last_epoch == GlobalVariables.next_epoch:
			GlobalVariables.next_epoch = GlobalEnums.LEVELS[GlobalEnums.LEVELS.keys()[randi() % GlobalEnums.LEVELS.size()]]
		
		var rnd = randi_range(0, 100)
		print(GlobalVariables.initial_chance_for_lag+GlobalVariables.times_treveled*3)
		if GlobalVariables.times_treveled == 0 or rnd <= GlobalVariables.initial_chance_for_lag+GlobalVariables.times_treveled*3:
			get_tree().change_scene_to_file("res://Scenes/Locations/home.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/age_travel_machine.tscn")
			
		GlobalVariables.times_treveled += 1


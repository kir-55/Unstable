extends Area2D

@export var death_messages: Array[String]

func _on_body_entered(body):
	if body.name == "Player" and GlobalVariables.game_is_on:
		GlobalVariables.game_is_on = false
		
		var last_score = GlobalVariables.last_score + int(body.global_position.x) / GlobalVariables.score_divider
		var best_score = GlobalVariables.best_score
		if last_score > best_score:
			GlobalVariables.best_score = last_score
			
		GlobalVariables.last_score = last_score
		GlobalVariables.player_global_speed = 0
		

		
		# spawning death menu
		var game_over_menu = load("res://Scenes/menus/game_over_menu.tscn")
		var instance = game_over_menu.instantiate()
		if death_messages and death_messages.size() != 0:
			instance.get_child(0).get_child(1).get_child(0).get_child(0).get_child(0).text = death_messages.pick_random()
		get_tree().current_scene.add_child(instance)

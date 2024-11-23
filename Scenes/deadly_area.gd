extends Area2D



func _on_body_entered(body):
	if body.name == "Player":
		var last_score = GlobalVariables.last_score + body.global_position.x / GlobalVariables.score_divider
		var best_score = GlobalVariables.best_score
		if last_score > best_score:
			GlobalVariables.best_score = last_score
			
		GlobalVariables.last_score = last_score
		print("name: "  + get_parent().name)
		GlobalVariables.player_global_speed = 0
		get_tree().change_scene_to_file("res://Scenes/menus/game_over_menu.tscn")

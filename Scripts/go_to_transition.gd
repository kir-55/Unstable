extends Timer

@export var player: Node2D
@export var current_world: GlobalVariables.LEVELS

func _on_timeout():
	if GlobalVariables.game_is_on:
		print("timeout")
		GlobalVariables.last_score = GlobalVariables.last_score + int(player.global_position.x) / GlobalVariables.score_divider
		GlobalVariables.last_world = current_world
		var rnd = randi_range(0, 100)
		
		if GlobalVariables.times_treveled == 0 or rnd <= 40+GlobalVariables.times_treveled*2:
			get_tree().change_scene_to_file("res://Scenes/home.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/age_travel_machine.tscn")
			
		GlobalVariables.times_treveled += 1


extends Timer

@export var player: Node2D
@export var current_world: GlobalVariables.LEVELS

func _on_timeout():
	GlobalVariables.last_score += player.global_position.x / GlobalVariables.score_divider
	var rnd = GlobalVariables.LEVELS[GlobalVariables.LEVELS.keys()[randi() % GlobalVariables.LEVELS.size()]]
	while current_world == rnd:
		rnd = GlobalVariables.LEVELS[GlobalVariables.LEVELS.keys()[randi() % GlobalVariables.LEVELS.size()]]
	GlobalVariables.change_level(rnd)
 

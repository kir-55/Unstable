extends Timer

@export var player: Node2D
@export var current_world: GlobalVariables.LEVELS

func _on_timeout():
	print("timeout")
	GlobalVariables.last_score += player.global_position.x / GlobalVariables.score_divider
	GlobalVariables.last_world = current_world
	var transition_scene = preload("res://Scenes/age_travel_machine.tscn")
	get_tree().change_scene_to_packed(transition_scene)

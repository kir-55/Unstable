extends Area2D


func _on_body_entered(body):
	if body.is_in_group("Player"):
		GlobalFunctions.load_menu("game_over")
		GlobalVariables.game_is_on = false

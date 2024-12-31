extends Control


@export var initialPlayerSpeed:int =  500

@export var last_score_label : Label
@export var best_score_label : Label

func _on_exit_pressed():
	get_tree().quit()
	

func _on_again_pressed():
	GlobalVariables.last_score = 0
	GlobalVariables.player_global_speed = initialPlayerSpeed
	GlobalVariables.game_is_on = true
	
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _ready():
	while(!last_score_label or !best_score_label):
		return
	last_score_label.set_text(last_score_label.get_text() + str(GlobalVariables.last_score))
	best_score_label.set_text(best_score_label.get_text() + str(GlobalVariables.best_score))

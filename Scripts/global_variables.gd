extends Node

var player_global_speed : float
var best_score : int = 0
var last_score : int = 0

var score_divider: int = 12

enum LEVELS {
		START,
		FUTURE,
		MEDIVEL
	}
	
enum DECORATION_LAYERS{
	AIR,
	ON_GROUND,
	GROUND,
	BACKGROUND
}

var levels = { 
	LEVELS.START : preload("res://Scenes/game.tscn"),
	LEVELS.FUTURE : preload("res://Scenes/future.tscn"),
	LEVELS.MEDIVEL : preload("res://Scenes/medieval.tscn")
}

func change_level(new_level):
	if new_level is LEVELS:
		get_tree().change_scene_to_packed(levels[new_level])
	else:
		print("didnt change the scene")
		return false


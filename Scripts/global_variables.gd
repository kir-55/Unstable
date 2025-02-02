extends Node

var player_global_speed : float
var best_score : int = 0
var last_score : int = 0
var times_treveled: int = 0
var items_in_home: int = 5
var player_amulets: Array[int]
var initial_chance_for_lag = 40

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


var last_world: LEVELS

var game_is_on := true


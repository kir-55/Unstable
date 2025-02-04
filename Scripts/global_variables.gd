class_name Global
extends Node

var player_global_speed : float
var best_score : int = 0
var last_score : int = 0
var times_treveled: int = 0

@export var initial_player_speed: int = 500


@export var initial_items_in_home: int = 3
var items_in_home: int = initial_items_in_home


@export var initial_chance_for_lag = 40

@export var score_divider: int = 12

@export var epochs: Array[LevelInfo]

@export var amulets: Array[Amulet]
var player_amulets: Array[int]


var last_epoch: GlobalEnums.LEVELS
var next_epoch: GlobalEnums.LEVELS

var game_is_on := true






class_name Global
extends Node

signal game_state_changed(state)

var terrain_code: int = 1

var player_global_speed: float = 0
var best_score : int = 0
var last_score : int = 0


var time_started: int = 0
var time_ended: int = 0



var times_treveled: int = 0

var win_after_next_epoch : bool = false

@export var initial_player_speed: int = 500
@export var initial_player_amulets := [0]


@export var pre_game_countdown_time = 3



@export var initial_items_in_home: int = 3
var items_in_home: int = initial_items_in_home


@export var initial_chance_for_lag = 100

@export var score_divider: int = 12

@export var epochs: Array[LevelInfo]

@export var amulets: Array[Amulet]
var player_amulets: Array[int]
var player_amulet_collection : Array[int]
var player_new_amulets : Array[int]


var last_epoch: GlobalEnums.LEVELS
var next_epoch: GlobalEnums.LEVELS

var game_is_on := true:
	set(value):
		game_is_on = value
		game_state_changed.emit(value)
		

var menus = {
	"main" : load("res://Scenes/Menus/start_menu.tscn"),
	"settings" : load("res://Scenes/Menus/settings_menu.tscn"),
	"progress" : load("res://Scenes/Menus/progress_menu.tscn"),
	"win" : load("res://Scenes/Menus/win_menu.tscn"),
	"multiplayer_join" : load("res://Scenes/Menus/multiplayer_join.tscn"),
	"multiplayer_lobby" : load("res://Scenes/Menus/multiplayer_lobby.tscn"),
	"multiplayer_victory" : load("res://Scenes/Menus/multiplayer_victory.tscn"),
	"multiplayer_loss" : load("res://Scenes/Menus/multiplayer_loss.tscn"),
	"multiplayer_draw" : load("res://Scenes/Menus/multiplayer_draw.tscn")
	
}
var current_menu = "main"

@export var player_data_path: String = "res://player_data.json"

var settings = {
	"master_volume": 100,
	"music_volume": 100,
	"sfx_volume": 100
}



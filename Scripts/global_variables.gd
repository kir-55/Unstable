class_name Global
extends Node

signal on_game_state_changed(state)
signal on_player_died(message)

signal on_player_colors_changed
signal on_player_amulets_changed



var terrain_code: int = 1

var player : CharacterBody2D

var player_global_speed: float = 0
var best_score : int = 0
var last_score : int = 0


var time_started: int = 0
var time_ended: int = 0



var times_treveled: int = 0

var win_after_next_epoch : bool = false

@export var initial_player_speed: int = 500
@export var initial_player_amulets: Array[int]


@export var pre_game_countdown_time = 3



@export var initial_items_in_home: int = 3
var items_in_home: int = initial_items_in_home


@export var initial_chance_for_lag = 100

@export var score_divider: int = 12

@export var epochs: Array[LevelInfo]

@export var amulets: Array[Amulet]
var player_amulets: Array[int]:
	set(value):
		player_amulets = value
		on_player_amulets_changed.emit()
		
var player_amulet_collection : Array[int]
var player_new_amulets : Array[int]


@export var active_weapon_types: Array[WeaponType]

var last_epoch: GlobalEnums.LEVELS
var current_epoch : GlobalEnums.LEVELS = GlobalEnums.LEVELS.START
var next_epoch: GlobalEnums.LEVELS

var game_is_on := true:
	set(value):
		game_is_on = value
		on_game_state_changed.emit(value)
		

var menus = {
	"main" : load("res://Scenes/Menus/start_menu.tscn"),
	"game_over" : load("res://Scenes/Menus/game_over_menu.tscn"),
	"settings" : load("res://Scenes/Menus/settings_menu.tscn"),
	"progress" : load("res://Scenes/Menus/progress_menu.tscn"),
	"win" : load("res://Scenes/Menus/win_menu.tscn"),
	"multiplayer_join" : load("res://Scenes/Menus/multiplayer_join.tscn"),
	"multiplayer_lobby" : load("res://Scenes/Menus/multiplayer_lobby.tscn"),
	"multiplayer_victory" : load("res://Scenes/Menus/multiplayer_victory.tscn"),
	"multiplayer_loss" : load("res://Scenes/Menus/multiplayer_loss.tscn"),
	"multiplayer_draw" : load("res://Scenes/Menus/multiplayer_draw.tscn")	
}

var previous_menu = null
var current_menu = "main"

@export var player_data_path: String = "res://player_data.json"

var settings = {
	"master_volume": 100,
	"music_volume": 100,
	"sfx_volume": 100,
	"fullscreen": false
}

var player_colors := {
	"skin_color": Color(1, 0.8, 0.6),
	"skin_shadow": Color(0.9, 0.6, 0.4),
	"ear_color": Color(1, 0.8, 0.8),

	"hair_color": Color(0.2, 0.1, 0.05),
	"hair_shadow": Color(0.1, 0.05, 0.02),

	"coat_color": Color(0.2, 0.4, 0.6),
	"coat_shadow": Color(0.15, 0.3, 0.45),
	"coat_shadow2": Color(0.1, 0.2, 0.3),

	"tshirt_color": Color(1, 1, 1),
	"tshirt_shadow": Color(0.8, 0.8, 0.8),

	"pocket_color": Color(0.2, 0.4, 0.6),
	"pocket_color2": Color(0.15, 0.3, 0.45),

	"pants_light": Color(0.4, 0.4, 0.4),
	"pants_color": Color(0.2, 0.2, 0.2),
	"pants_shadow": Color(0.1, 0.1, 0.1),

	"shoes_light": Color(0.7, 0.7, 0.7),
	"shoes_color": Color(0.3, 0.3, 0.3),
	"shoes_shadow": Color(0.1, 0.1, 0.1),

	"glasses_color": Color(0, 0, 0),
	"glasses_frame": Color(0.1, 0.1, 0.1),
	"glasses_light": Color(1, 1, 1),
	
	"mouth_color" : Color(1, 0.8, 0.8),
	"hand_color" :  Color(0.9, 0.6, 0.4),
	"hand_color_shadow" :  Color(0.9, 0.6, 0.4)
}


var global_theme := Theme.new() #needed for font
var fonts = ["res://Styles/Fonts/Minecraft.ttf", "res://Styles/Fonts/C&C Red Alert [LAN].ttf"]

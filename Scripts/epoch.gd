extends Node2D

signal player_spawned(player)

@export var player_prefab: String = "res://Scenes/Entities/player.tscn"
@export var spawn_point: Node2D
@export var amulets_panel: VBoxContainer
@export var canvas_layer : CanvasLayer

@export var countdown_panel: Panel
@export var countdown_label: Label
var current_countdown_value: int


func _ready():
	GlobalVariables.game_is_on = false
	current_countdown_value = GlobalVariables.pre_game_countdown_time
	
	if Client.active:
		for i in Client.players:
			var player = load(player_prefab).instantiate()
			if int(i) == Client.id:
				player_spawned.emit(player)
			
			player.global_position = spawn_point.global_position + Vector2(randf_range(-1000, 1000), randf_range(-1000, 1000))
			player.name = "Player" + str(i)
			get_tree().current_scene.add_child(player)
	else:
		var player = load(player_prefab).instantiate()
		player.global_position = spawn_point.global_position
		player_spawned.emit(player)
		get_tree().root.get_child(4).add_child(player)


func _on_timer_timeout():
	current_countdown_value -= 1
	if current_countdown_value <= 0:
		countdown_panel.queue_free()
		GlobalVariables.game_is_on = true
	else:
		countdown_label.text = str(current_countdown_value)
	

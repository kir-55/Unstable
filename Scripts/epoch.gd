extends Node2D

signal player_spawned(player)

@export var player_prefab: String = "res://Scenes/Entities/player.tscn"
@export var spawn_point: Node2D
@export var amulets_panel: VBoxContainer
@export var canvas_layer : CanvasLayer
@export var world_environment : WorldEnvironment
@export var grass_line : Line2D
@export var ground_line : Line2D
@export var audio_player : AudioStreamPlayer2D
@export var decoration_spawner : Node2D

@export var countdown_panel: Panel
@export var countdown_label: Label
var current_countdown_value: int


func _ready():
	GlobalVariables.game_is_on = false
	current_countdown_value = GlobalVariables.pre_game_countdown_time
	var current_epoch = GlobalVariables.epochs[GlobalVariables.current_epoch]
	if current_epoch:
		decoration_spawner.decorations = current_epoch.decorations
		decoration_spawner.spawn_pattern = current_epoch.decoration_spawn_pattern
		grass_line.default_color = current_epoch.grass_color
		ground_line.default_color = current_epoch.ground_color
		if current_epoch.music:
			audio_player.stream = current_epoch.music
		if current_epoch.environment:
			world_environment.environment = current_epoch.environment
		if current_epoch.directional_light:
			add_child(current_epoch.directional_light.instantiate())
		if current_epoch.parallax_background:
			add_child(current_epoch.parallax_background.instantiate())
	
	
	if Client.active:
		for i in Client.players_alive:
			#(Client.players_alive)
			var player = load(player_prefab).instantiate()
			if int(i) == Client.id:
				player_spawned.emit(player)
			
			player.global_position = spawn_point.global_position + Vector2(randf_range(-1000, 1000), randf_range(-1000, 1000))
			player.name = "Player" + str(i)
			player.id = int(i)
			#print("spawning player: " + str(player.id))
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
		if !Client.active or Client.players_alive.has(Client.id):
			GlobalVariables.game_is_on = true
	else:
		countdown_label.text = str(current_countdown_value)
	

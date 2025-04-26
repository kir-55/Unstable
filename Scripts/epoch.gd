class_name Epoch
extends Node2D

signal player_spawned(player)

@export var world_environment: WorldEnvironment
@export var grass_line: Line2D
@export var ground_line: Line2D
@export var audio_player: AudioStreamPlayer2D
@export var decoration_spawner: Node2D
@export var player_prefab: String = "res://Scenes/Entities/player.tscn"
@export var spawn_point: Node2D
@export var amulets_panel: VBoxContainer
@export var canvas_layer: CanvasLayer
@export var score_label: Label
@export var camera: Camera2D
var player: Player


@export_category("Countdown Panel")
@export var countdown_panel: Panel
@export var countdown_label: Label
var current_countdown_value: int

@export_category("Death Panel")
@export var death_panel: Panel
@export var death_message_label: Label

var death_animation: bool = false
var can_accept_input: bool = false
@export var text_unwrap_speed: float = 12
@export var death_circle_min_size: float = 0.1

func _ready():
	death_panel.visible = false
	GlobalVariables.game_is_on = false
	current_countdown_value = GlobalVariables.pre_game_countdown_time
<< << << < HEAD
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


	GlobalVariables.on_player_died.connect(on_player_died)


	if Client.active:
		for i in Client.players_alive:
			#(Client.players_alive)
			var player = load(player_prefab).instantiate()
			if int(i) == Client.id:
				self.player = player
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
		self.player = player
		get_tree().root.get_child(4).add_child(player)



func _process(delta):
	if death_animation:
		var circle_size = death_panel.material.get_shader_parameter("circle_size")
		if circle_size >= death_circle_min_size:
			death_panel.material.set_shader_parameter("circle_size", circle_size -0.1)
		elif death_message_label.size.x < get_viewport().size.x:
			death_message_label.size.x += text_unwrap_speed
			death_message_label.position.x -= text_unwrap_speed / 2
		else:
			can_accept_input = true


func _input(event):
	if can_accept_input and death_animation and event.is_pressed():
		death_animation = false
		GlobalFunctions.load_menu("game_over")

# SMART PANEL
func _on_timer_timeout():
	current_countdown_value -= 1
	if current_countdown_value <= 0:
		countdown_panel.queue_free()
		if !Client.active or Client.players_alive.has(Client.id):
			GlobalVariables.game_is_on = true
	else:
		countdown_label.text = str(current_countdown_value)

func on_player_died(message):
	if !Client.active and death_panel and death_message_label:
		score_label.visible = false
		death_panel.visible = true

		death_message_label.size.x = 0
		death_message_label.position.x = get_viewport().size.x / 2
		death_message_label.text = message
		#death_panel.material.set_shader_parameter("circle_size", 0.34)

		var viewport := get_viewport()
		var viewport_size = viewport.size

		# The camera center in world space is its global position
		# So the top-left corner is global_position - half viewport_size * zoom
		var camera_top_left = camera.global_position - (viewport_size * 0.5 * camera.zoom)

		# Local player position relative to camera view
		var local_pos = (player.global_position - camera_top_left) / camera.zoom

		# Normalize to 0-1
		var normalized_pos = local_pos / Vector2(viewport_size)


		death_panel.material.set_shader_parameter("circle_position", normalized_pos)
		print(normalized_pos)
		death_animation = true
		# spawning death menu
		#var game_over_menu = load("res://Scenes/Menus/game_over_menu.tscn")
		#var instance = game_over_menu.instantiate()


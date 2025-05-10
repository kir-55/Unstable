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

@export var parallax_background_close: Sprite2D

@export var parallax_background_far1: Sprite2D
@export var parallax_background_far2: Sprite2D

@export var parallax_foreground: Sprite2D

var player: Player



@export_category("Countdown Panel")
@export var countdown_panel: Panel
@export var countdown_label: Label
var current_countdown_value: int

@export_category("Death Panel")
@export var death_panel: Panel
@export var death_message_label: Label

@export var press_to_continue_label: Label

var death_animation: bool = false
var can_accept_input: bool = false
@export var text_unwrap_speed: float = 12
@export var death_circle_min_size: float = 0.1

@export var score_mark_prefab: PackedScene

var initial_view_port_size := Vector2(1152, 648)

func _ready():
	death_panel.visible = false
	countdown_panel.visible = true
	GlobalVariables.is_in_epoch = true
	GlobalVariables.game_is_on = false
	current_countdown_value = GlobalVariables.pre_game_countdown_time
	var current_epoch = GlobalVariables.epochs[GlobalVariables.current_epoch_id]
	if current_epoch:
		decoration_spawner.decorations = current_epoch.decorations
		decoration_spawner.spawn_pattern = current_epoch.decoration_spawn_pattern
		grass_line.default_color = current_epoch.grass_color
		ground_line.default_color = current_epoch.ground_color
		if current_epoch.music:
			audio_player.stream = current_epoch.music
			audio_player.playing = true
		if current_epoch.environment:
			world_environment.environment = current_epoch.environment
		if current_epoch.directional_light:
			add_child(current_epoch.directional_light.instantiate())
		if current_epoch.parallax_background_close:
			parallax_background_close.texture = current_epoch.parallax_background_close
		if current_epoch.parallax_background_far:
			parallax_background_far1.texture = current_epoch.parallax_background_far
			parallax_background_far2.texture = current_epoch.parallax_background_far
		if current_epoch.parallax_foreground:
			parallax_foreground.texture = current_epoch.parallax_foreground
		RenderingServer.set_default_clear_color(current_epoch.background_color) 

	GlobalVariables.on_player_died.connect(on_player_died)


	if Client.active:
		for i in Client.players_alive:
			#(Client.players_alive)
			var player = load(player_prefab).instantiate()
			if int(i) == Client.id:
				self.player = player
				player_spawned.emit(player)
			else:
				player.get_node("CollisionShape2D").disabled = true

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

var last_zoom = Vector2(0,0)
var last_viewport = Vector2.ZERO

func _process(delta):
	# Musisz mieć aktualne viewport_size i zoom
	var zoom = camera.zoom
	if zoom != last_zoom:
		print("zoom: ",zoom)
		last_zoom = zoom
		
	
		
	var viewport_size_pixels = Vector2(get_viewport().size)
	if viewport_size_pixels != last_viewport:
		print("viewport: ", viewport_size_pixels)
		last_viewport = viewport_size_pixels
		
	
	if death_animation:
		var circle_size = death_panel.material.get_shader_parameter("circle_size")
		if circle_size >= death_circle_min_size:
			death_panel.material.set_shader_parameter("circle_size", circle_size -0.1)
		elif death_message_label.size.x < get_viewport().size.x:
			death_message_label.size.x += text_unwrap_speed
			death_message_label.position.x -= text_unwrap_speed / 2
		else:
			can_accept_input = true
			press_to_continue_label.visible = true


func _input(event):
	if can_accept_input and death_animation and event.is_pressed():
		death_animation = false
		GlobalFunctions.load_menu("game_over")
		var score_mark_instance = score_mark_prefab.instantiate()
		score_mark_instance.global_position = player.global_position
		score_mark_instance.get_child(0).text = "Score: " + str(GlobalVariables.last_score) + "\nBest Score: " + str(GlobalVariables.best_score)
		get_tree().current_scene.add_child(score_mark_instance)

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
		press_to_continue_label.visible = false


		var scale_factor = Vector2(get_viewport().size) / initial_view_port_size
		death_message_label.size.x = 0
		death_message_label.position.x = get_viewport().size.x / scale_factor.x / 2
		death_message_label.text = message
		#death_panel.material.set_shader_parameter("circle_size", 0.34)

		var zoom = camera.zoom


		print("scale factor", scale_factor)
		var viewport_size = Vector2(get_viewport().size) / scale_factor / zoom

		var camera_top_left = camera.global_position - (viewport_size * 0.5)

		var local_pos = player.global_position - camera_top_left

		# the final position shoud be in rage 0-1 where (0.5, 0.5) is center of screen 0 and one are the edges
		var normalized_pos = local_pos / (Vector2(viewport_size))

		death_panel.material.set_shader_parameter("circle_size",  3)
		death_panel.material.set_shader_parameter("circle_position", normalized_pos)
		print(normalized_pos)
		death_animation = true
		# spawning death menu
		#var game_over_menu = load("res://Scenes/Menus/game_over_menu.tscn")
		#var instance = game_over_menu.instantiate()
	

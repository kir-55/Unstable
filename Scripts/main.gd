extends Node2D

@export var world_environment: WorldEnvironment
@export var grass_line: Line2D
@export var ground_line: Line2D
@export var audio_player: AudioStreamPlayer2D
@export var decoration_spawner: Node2D

@export var parallax_background_close: Sprite2D
@export var parallax_background_far1: Sprite2D
@export var parallax_background_far2: Sprite2D

@export var parallax_foreground: Sprite2D

func _ready():
	var current_epoch = GlobalVariables.epochs.pick_random()
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
		if current_epoch.parallax_background_close:
			parallax_background_close.texture = current_epoch.parallax_background_close
		if current_epoch.parallax_background_far:
			parallax_background_far1.texture = current_epoch.parallax_background_far
			parallax_background_far2.texture = current_epoch.parallax_background_far
		if current_epoch.parallax_foreground:
			parallax_foreground.texture = current_epoch.parallax_foreground

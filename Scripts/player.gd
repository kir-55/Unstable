class_name Player
extends CharacterBody2D


var id

@export var REMOTE_PLAYER_POSITION: Vector2

# Constants
@export var SPEED: float = 600.0  # Horizontal movement speed
@export var MAX_SPEED: float = 1000.0

@export var jump_grace_ray: RayCast2D
@export var JUMP_VELOCITY: float = -500.0  # Jump velocity
@export var MAX_JUMP_VEL: float = -700.0
var jump_buffer_time = 0.15  # seconds to remember the jump input
var jump_buffer_timer = 0.0



const BASE_JUMP_VELOCITY = -300.0
const JUMP_HOLD_FORCE = -25
const MAX_JUMP_HOLD_TIME = 0.35 

var jump_hold_timer = 0.0
var is_jump_button_held = false



@export var DROP_THROUGH_VELOCITY: float = 700  # Downward drop velocity (controlled fall)

@export var DASH_SPEED_BOOST: float = 400.0  # Speed boost for dash
@export var DASH_DURATION: float = 0.5  # Dash duration in seconds
@export var DASH_COOLDOWN: float = 0.4  # Time between dashes


@export var STOP_DURATION: float = 0.5  # Dash duration in seconds
@export var STOP_COOLDOWN: float = 0.4  # Time between dashes

@export var score_label: Label


@export var sprite: Sprite2D
@export var player_animator: AnimationPlayer
@export var effects_animator: AnimationPlayer


@export var trail: Node

@export var weapon: Node
@export var amulet_system: Node

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")  # Sync gravity with project settings
var direction: Vector2 = Vector2.ZERO  # Movement direction
var start_x

# Multiplayer
@export var multiplayer_synchronizer: MultiplayerSynchronizer
@export var collision_shape: CollisionShape2D
@export var nickname_label: Label

@export var head: Node2D
@export var feet: Node2D
@export var landing_particles_prefab: PackedScene

@export var dash_sound_prefab: PackedScene

# Doble jump
@onready var doble_jump_active = GlobalVariables.player_amulets.has(9)  # checks if player has pizza
var doble_jump_used = false


# Dash variables
var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var original_speed: float = SPEED

# Stop
var is_stopping: bool = false
var stop_timer: float = 0.0
var stop_cooldown_timer: float = 0.0

# Drop
var is_dropping = false
var is_jumping




func _enter_tree():
	if Client.active:
		#print("player name in enter tree: " + name)
		set_multiplayer_authority(id)

func _ready():
	if Client.active:
		nickname_label.text = Client.players[str(id)].name
	else:
		multiplayer_synchronizer.queue_free()

	if is_multiplayer_authority() or !Client.active:
		$Nickname.queue_free()
		#amulet_system.amulets_available = GlobalVariables.player_amulets
		GlobalVariables.player = self
		
		if GlobalVariables.player_amulets.has(3):
			$Sprite2D.glasses = true
		
		for i in range(GlobalVariables.player_amulets.count(12)):
			DASH_DURATION += amulet_system.dash_duration_increase
			DASH_SPEED_BOOST += amulet_system.dash_speed_increase
			DASH_COOLDOWN += amulet_system.dash_cooldown_increase
			DROP_THROUGH_VELOCITY += amulet_system.drop_throgh_speed_increase

		start_x = global_position.x
		if GlobalVariables.player_global_speed:
			SPEED = GlobalVariables.player_global_speed

		if GlobalVariables.player_amulets.has(3):
			var camera = get_tree().current_scene.find_child("Camera2D")
			camera.zoom = Vector2(0.7, 0.7)
			camera.offsett = Vector2(320, -200)
			
		reset_velocity()
	else:
		collision_shape.disabled = true
		sprite.self_modulate = Color("#ffffff8e")

		$Amulets.queue_free()
		$SpeedUpTimer.queue_free()



	
func can_jump() -> bool:
	return jump_grace_ray.is_colliding() or (doble_jump_active and !doble_jump_used)

func reset_velocity():
	velocity.x = SPEED


func _physics_process(delta: float) -> void:
	if GlobalVariables.game_is_on and (!Client.active or is_multiplayer_authority()):
		if velocity.x < SPEED:
			velocity.x += 10

		if jump_buffer_timer > 0:
			jump_buffer_timer -= delta

		REMOTE_PLAYER_POSITION = global_position

		# Apply gravity if not on the floor
		if not is_on_floor():
			velocity.y += gravity * delta

		# Apply extra jump force while holding jump
		if is_jump_button_held and jump_hold_timer > 0 and velocity.y < 0:
			var hold_strength = JUMP_HOLD_FORCE * (jump_hold_timer / MAX_JUMP_HOLD_TIME)
			velocity.y += hold_strength
			jump_hold_timer -= delta

		# Handle movement input
		direction.x = 1  # Fixed direction (right movement)

		# Handle dash activation
		if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0 and not is_dashing:
			start_dash()

		# Handle dashing
		if is_dashing:
			trail.process_points()
			velocity.y = 0
			dash_timer -= delta
			if dash_timer <= 0:
				end_dash()

		if is_stopping:
			player_animator.stop()
			velocity.x = 0
			stop_timer -= delta
			if stop_timer <= 0:
				reset_velocity()
				is_stopping = false
				player_animator.play()

		if is_dropping:
			trail.process_points()

		if is_jumping:
			trail.process_points()
			if velocity.y > 0:
				is_jumping = false

		# Dash cooldown
		if dash_cooldown_timer > 0:
			dash_cooldown_timer -= delta

		if stop_cooldown_timer > 0:
			stop_cooldown_timer -= delta

		if is_on_floor():
			doble_jump_used = false
			if is_dropping:
				var grass_color = get_tree().current_scene.current_epoch.grass_color
				var ground_color = get_tree().current_scene.current_epoch.ground_color
				spawn_landing_particles(grass_color, ground_color, feet.global_position)
				is_dropping = false

		# Handle jumping
		if Input.is_action_just_pressed("up"):
			jump_buffer_timer = jump_buffer_time

		if jump_buffer_timer > 0 and can_jump():
			trail.remove_points()
			is_jumping = true
			jump_buffer_timer = 0
			is_jump_button_held = true
			jump_hold_timer = MAX_JUMP_HOLD_TIME
			velocity.y = BASE_JUMP_VELOCITY

			if is_dashing:
				end_dash()

			if !is_on_floor():
				doble_jump_used = true

		if Input.is_action_just_released("up"):
			is_jump_button_held = false

		# Stop applying extra force if rising ends
		if velocity.y >= 0:
			is_jump_button_held = false

		# Handle dropping down
		if Input.is_action_just_pressed("bottom") and not is_on_floor():
			drop_through()

		var direction = 1

		if not jump_grace_ray.is_colliding():
			player_animator.play("jump")
		else:
			player_animator.play("run")

		# Move the character
		move_and_slide()

	elif !GlobalVariables.game_is_on:
		if velocity.x < SPEED and !is_stopping:
			reset_velocity()

		player_animator.stop()
		global_position = REMOTE_PLAYER_POSITION
	else:
		global_position = REMOTE_PLAYER_POSITION



func start_dash() -> void:
	if dash_sound_prefab:
		var instance = dash_sound_prefab.instantiate()
		get_tree().current_scene.add_child(instance)
		
	
	if !is_jumping:
		trail.remove_points()

	if is_dropping:
		is_dropping = false

	scale.y = scale.y / 2
	# Start the dash by increasing the speed and setting timers
	is_stopping = false
	is_dashing = true
	dash_timer = DASH_DURATION
	dash_cooldown_timer = DASH_COOLDOWN
	original_speed = SPEED  # Store the original speed
	SPEED += DASH_SPEED_BOOST
	reset_velocity()
	velocity.y = 0

func end_dash() -> void:
	scale.y *= 2
	# End the dash and restore the original speed
	is_dashing = false
	SPEED = original_speed
	reset_velocity()

func drop_through() -> void:
	is_dropping = true
	if is_dashing:
		end_dash()
	position.y += DROP_THROUGH_VELOCITY * get_physics_process_delta_time()
	velocity.y = DROP_THROUGH_VELOCITY

func kill():
	if GlobalVariables.player_amulets.has(11): #check if has heart
		GlobalFunctions.remove_amulet(11)
		return false;
	return true;


func _on_speed_up_timer_timeout():
	if SPEED < MAX_SPEED and GlobalVariables.game_mode != GlobalEnums.GAME_MODES.TUTORIAL:
		SPEED += 20
		GlobalVariables.player_global_speed = SPEED

func spawn_landing_particles(grass_color: Color, ground_color: Color, position: Vector2):
	var particles = landing_particles_prefab.instantiate()
	particles.global_position = position

	var gradient := Gradient.new()

	gradient.add_point(0.5, grass_color)
	gradient.add_point(0.99, ground_color)
	gradient.remove_point(0)
	gradient.remove_point(0)


	# Clone the existing process_material to avoid editing the original
	particles.color_initial_ramp = gradient

	get_tree().current_scene.add_child(particles)
	particles.emitting = true





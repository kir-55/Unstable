extends CharacterBody2D

# Constants
@export var SPEED: float = 600.0              # Horizontal movement speed
@export var MAX_SPEED: float = 1000.0
@export var JUMP_VELOCITY: float = -500.0     # Jump velocity
@export var MAX_JUMP_VEL: float = -700.0

@export var DROP_THROUGH_VELOCITY: float = 700  # Downward drop velocity (controlled fall)

@export var DASH_SPEED_BOOST: float = 400.0  # Speed boost for dash
@export var DASH_DURATION: float = 0.5       # Dash duration in seconds
@export var DASH_COOLDOWN: float = 0.4      # Time between dashes


@export var STOP_DURATION: float = 0.5       # Dash duration in seconds
@export var STOP_COOLDOWN: float = 0.4      # Time between dashes

@export var score_label: Label
@export var amulets_panel: Container


@export var animated_sprite : AnimatedSprite2D
@export var trail: Node

@export var weapon: Node
@export var amulet_system: Node

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")  # Sync gravity with project settings
var direction: Vector2 = Vector2.ZERO  # Movement direction
var start_x

# Doble jump
@onready var doble_jump_active = GlobalVariables.player_amulets.has(5) # checks if player has pizza
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

func _ready():
	amulet_system.amulets_available = GlobalVariables.player_amulets
	amulet_system.amulets_panel = amulets_panel
	
	if !amulet_system.amulets_available.has(0):
		weapon.set_process(false)
		
	for i in range(amulet_system.amulets_available.count(2)):
		DASH_DURATION += amulet_system.dash_duration_increase
		DASH_SPEED_BOOST += amulet_system.dash_speed_increase 
		DASH_COOLDOWN += amulet_system.dash_cooldown_increase
		DROP_THROUGH_VELOCITY += amulet_system.drop_throgh_speed_increase
		
	start_x = global_position.x
	if GlobalVariables.player_global_speed:
		SPEED = GlobalVariables.player_global_speed

func _physics_process(delta: float) -> void:
	if GlobalVariables.game_is_on:
		
		# Apply gravity if not on the floor
		if not is_on_floor():
			
			velocity.y += gravity * delta

		# Handle movement input
		direction.x = 1  # Fixed direction (right movement)
		
		# Handle dash activation
		if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0 and not is_dashing:
			start_dash()
		if Input.is_action_just_pressed("stop") and stop_cooldown_timer <= 0 and not is_stopping:
			is_stopping = true
			stop_timer = STOP_DURATION
			stop_cooldown_timer = STOP_COOLDOWN
		# Handle dashing
		if is_dashing:
			trail.process_points()
			velocity.y = 0
			dash_timer -= delta
			if dash_timer <= 0:
				end_dash()
				
		if is_stopping: 
			animated_sprite.stop()
			velocity.x = 0
			stop_timer -= delta
			if stop_timer <= 0:
				is_stopping = false
				animated_sprite.play()
				
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
				is_dropping = false
		
		# Handle jumping
		if (is_on_floor() or (doble_jump_active and !doble_jump_used)) and Input.is_action_just_pressed("up"):
			trail.remove_points()
			is_jumping = true
			is_dashing = false
			
			velocity.y = JUMP_VELOCITY
			
			if !is_on_floor():
				doble_jump_used = true
				
			if JUMP_VELOCITY < MAX_JUMP_VEL:
				JUMP_VELOCITY += 5
				


		# Handle dropping down
		if Input.is_action_just_pressed("bottom") and not is_on_floor():
			drop_through()
		
		# Set horizontal movement speed
		if !is_stopping:
			velocity.x = direction.x * SPEED
		var direction=1
		
		if not is_on_floor():
			animated_sprite.play("jump")
		else:
			animated_sprite.play("walk")
		# Update score
		score_label.set_text(str(int(GlobalVariables.last_score + int(global_position.x) / GlobalVariables.score_divider)))
		
		# Move the character
		move_and_slide()
	else:
		animated_sprite.stop()

func start_dash() -> void:
	if !is_jumping:
		trail.remove_points()
	
	if is_dropping:
		is_dropping = false
	
	scale.y = scale.y/2
	# Start the dash by increasing the speed and setting timers
	is_stopping = false
	is_dashing = true
	dash_timer = DASH_DURATION
	dash_cooldown_timer = DASH_COOLDOWN
	original_speed = SPEED  # Store the original speed
	SPEED += DASH_SPEED_BOOST
	velocity.y = 0

func end_dash() -> void:
	scale.y *= 2
	# End the dash and restore the original speed
	is_dashing = false
	SPEED = original_speed

func drop_through() -> void:
	is_dropping = true
	if is_dashing:
		end_dash()
	position.y += DROP_THROUGH_VELOCITY * get_physics_process_delta_time()
	velocity.y = DROP_THROUGH_VELOCITY

func kill():
	if amulet_system.amulets_available.has(3):
		amulet_system.remove_amulet(3)
		return false;
	return true;
	

func _on_speed_up_timer_timeout():
	if SPEED < MAX_SPEED:
		SPEED += 20
		GlobalVariables.player_global_speed = SPEED



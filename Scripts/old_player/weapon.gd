extends Node2D

@export var bullet_scene: PackedScene        # Drag & drop the bullet scene here
@export var bullet_speed: float = 600.0      # Speed of the spawned bullets
@export var knockback_force: float = 200.0   # Knockback magnitude applied to the parent
@export var timer: Timer


@export var description: String              # Reference to the timer for cooldown

var can_shoot: bool = true

func _process(delta: float) -> void:
	# Check if the player wants to shoot
	if GlobalVariables.game_is_on and Input.is_action_just_pressed("fire") and can_shoot:
		fire_weapon()

func fire_weapon() -> void:
	if bullet_scene:
		# Spawn the bullet
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		get_tree().current_scene.add_child(bullet)
		 
		# Determine shooting direction based on player's input
		var input_direction = get_parent().direction

		# Default to shooting right if no inputd
		if input_direction == Vector2.ZERO:
			input_direction = Vector2.RIGHT

		bullet.set_velocity(Vector2(get_parent().velocity.x, 0) + input_direction * bullet_speed)

		# Apply knockback to the player
		if owner is CharacterBody2D:
			owner.velocity -= input_direction * knockback_force

		# Start cooldown
		can_shoot = false
		timer.start()



func _on_timer_timeout():
	can_shoot = true

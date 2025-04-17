extends Area2D

@export var rotation_factor := 0.3
var velocity: Vector2 = Vector2.ZERO   # Bullet velocity
var speed_value

var rotation_direction = 1


func _process(delta: float) -> void:
	rotation += rotation_factor * rotation_direction
	# Move the bullet based on velocity and direction
	if GlobalVariables.game_is_on:
		var direction_to_player = (GlobalVariables.player.global_position - global_position).normalized()
		var is_behind_player = global_position.x < GlobalVariables.player.global_position.x
		print(is_behind_player)
		if rotation_direction != 1:
			if is_behind_player:
				velocity = direction_to_player * (GlobalVariables.player.velocity.x + speed_value)
			else:
				scale *= 0.99
				velocity = direction_to_player * (speed_value - GlobalVariables.player.velocity.x)
		position += velocity * delta


func set_velocity(speed: Vector2) -> void:
	# Set the bullet's velocity in a specific direction
	velocity = speed
	speed_value = velocity.x

func _on_area_entered(body: Node) -> void:
	if body and body.has_node("HealthSystem"):
		body.get_node("HealthSystem").take_damage(100) 
	  # Destroy the bullet upon collision

	 # Example: Apply 10 damages



func _on_timer_timeout():
	if rotation_direction == -1:
		queue_free()
	else:
		rotation_direction = -1
		set_collision_mask_value(1, true)

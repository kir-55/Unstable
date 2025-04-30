extends Area2D

@export var damage : float = 100.0
@export var rotation_factor := 0.3
@export var return_on_minimum_max_health := 500

var velocity: Vector2 = Vector2.ZERO   # Bullet velocity
var speed_value

var rotation_direction = 1

func _process(delta: float) -> void:
	rotation += rotation_factor * rotation_direction
	if GlobalVariables.game_is_on:
		var direction_to_player = (GlobalVariables.player.global_position - global_position).normalized()
		var is_behind_player = global_position.x < GlobalVariables.player.global_position.x
		
		if rotation_direction != 1:
			if is_behind_player:
				velocity = direction_to_player * (GlobalVariables.player.velocity.x + speed_value)
			else:
				scale *= 0.99
				velocity = direction_to_player * speed_value
		position += velocity * delta


func set_velocity(speed: Vector2) -> void:
	# Set the bullet's velocity in a specific direction
	velocity = speed
	speed_value = velocity.x
	if GlobalVariables.player.is_dashing:
		velocity.x = GlobalVariables.player.velocity.x - GlobalVariables.player.DASH_SPEED_BOOST + speed_value
	else:
		velocity.x = GlobalVariables.player.velocity.x + speed_value
	
func _on_area_entered(body: Node) -> void:
	if GlobalVariables.game_is_on and body and body.has_node("HealthSystem"):
		var body_health_system = body.get_node("HealthSystem")
		if body_health_system.health >= return_on_minimum_max_health:
			rotation_direction = -1
		
		body_health_system.take_damage(damage)

func _on_timer_timeout():
	if rotation_direction == -1:
		queue_free()
	else:
		rotation_direction = -1

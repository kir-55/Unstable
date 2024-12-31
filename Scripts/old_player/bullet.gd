extends Area2D

@export var speed: float = 600.0        # Bullet movement speed
var velocity: Vector2 = Vector2.ZERO   # Bullet velocity


func _process(delta: float) -> void:
	
	# Move the bullet based on velocity
	if GlobalVariables.game_is_on:
		position += velocity * delta


func set_velocity(direction: Vector2) -> void:
	# Set the bullet's velocity in a specific direction
	velocity = direction.normalized() * speed

func _on_area_entered(body: Node) -> void:
	if body and body.get_parent() and body.get_parent().get_node("HealthSystem"):
		body.get_parent().get_node("HealthSystem").take_damage(40) 
	queue_free()  # Destroy the bullet upon collision

	 # Example: Apply 10 damages


func _on_body_entered(body):
	queue_free()  # D

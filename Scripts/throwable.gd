extends RigidBody2D

@export var damage: int = 100
@export var explosion_prefab: PackedScene
@export var explosion_point: Node2D



func _on_area_2d_area_entered(body):
	if body and body.has_node("HealthSystem"):
		body.get_node("HealthSystem").take_damage(damage)
		
	var explosion = explosion_prefab.instantiate()
	
	if explosion is RigidBody2D:
		explosion.get_child(0).scale = get_parent().scale
	else:
		explosion.scale = get_parent().scale
	
	if explosion_point:
		explosion.global_position = explosion_point.global_position
	else:
		explosion.global_position = global_position
	
	if "emitting" in explosion:
		explosion.emitting = true
	elif "emitting" in explosion.get_child(0):
		explosion.get_child(0).emitting = true
		
	get_tree().current_scene.add_child(explosion)
	
	queue_free()  # Destroy the bullet upon collision




func _on_destructor_timeout():
	var explosion = explosion_prefab.instantiate()
	if explosion_point:
		explosion.global_position = explosion_point.global_position
	else:
		explosion.global_position = global_position
	
	if "emitting" in explosion:
		explosion.emitting = true
	elif "emitting" in explosion.get_child(0):
		explosion.get_child(0).emitting = true
		
	get_tree().current_scene.add_child(explosion)
	
	queue_free()  # Destroy the bullet upon collision

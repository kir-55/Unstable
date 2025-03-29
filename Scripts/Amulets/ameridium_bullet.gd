extends Area2D

@export var explosion_scene : PackedScene
@export var velocity : Vector2 = Vector2(0,0)

func set_velocity(new_velocity: Vector2):
	pass

func explode():
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	queue_free()

func _physics_process(delta):
	position += velocity * delta


func _on_area_entered(area):
	if area.is_in_group("Obsticle") or area.get_parent().is_in_group("Obsticle"):
		if explosion_scene:
			var explosion = explosion_scene.instantiate()
			explosion.global_position = global_position
			get_tree().current_scene.add_child(explosion)
			queue_free()


func _on_timer_timeout():
	explode()

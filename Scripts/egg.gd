extends RigidBody2D


@export var explosion_scene: PackedScene

# Called when the egg is created
func _ready():
	# Apply initial impulse to launch the egg (adjust values as needed)
	apply_impulse(Vector2.ZERO, Vector2(3000, -4000))  # Right & up

# Optional: rotate while flying
func _physics_process(delta):
	rotation += deg_to_rad(3)




func _on_ameridium_bullet_area_entered(area):
	if area.is_in_group("Obsticle") or area.get_parent().is_in_group("Obsticle"):
		if explosion_scene:
			var explosion = explosion_scene.instantiate()
			explosion.global_position = global_position
			get_tree().current_scene.add_child(explosion)
			queue_free()

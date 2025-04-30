extends Area2D

@export var particles : CPUParticles2D
@export var collision_shape : CollisionShape2D

func _ready():
	particles.emitting = true
	particles.emission_sphere_radius = collision_shape.shape.radius / 5


func _on_cpu_particles_2d_finished():
	queue_free()


func _on_area_entered(area2d):
	var colliding_areas = get_overlapping_areas()
	for area in colliding_areas:
		if area.is_in_group("Obsticle") or area.get_parent().is_in_group("Obsticle") or area.is_in_group("Breakable"):
			if area.has_node("HealthSystem"):
				area.get_node("HealthSystem").take_damage(3000)
			else:
				area.queue_free()

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
	print(str(colliding_areas))
	for area in colliding_areas:
		if area.get_parent():
			area.get_parent().queue_free()
		else:
			area.queue_free()

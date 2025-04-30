extends Node2D

@export var can_mirror: bool = false

@export var x_variation_radius: int = 0
@export var y_variation_radius: int = 0

@export var chance_to_despawn: int = 0


func _ready():
	if can_mirror:
		scale.x *= [1, -1].pick_random()
	if x_variation_radius > 0:
		position.x += randf_range(-x_variation_radius, x_variation_radius)
	if y_variation_radius > 0:
		position.y += randf_range(-y_variation_radius, y_variation_radius)
	if chance_to_despawn > 0 and randf_range(0, 100) < chance_to_despawn:
		queue_free()
		



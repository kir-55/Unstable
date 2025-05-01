extends Node2D

var is_falling: bool = false
@export var ray: RayCast2D
@export var fall_speed: float = 150.0

func _process(delta):
	if not is_falling and ray.is_colliding():
		var collider = ray.get_collider()
		if collider.is_in_group("Player"):
			is_falling = true

	if is_falling and GlobalVariables.game_is_on:
		position.y += fall_speed * delta

extends Sprite2D

@export var fall_speed: float = 200.0  # Prędkość spadania strzały


func _process(delta):
	global_position.y += fall_speed * delta


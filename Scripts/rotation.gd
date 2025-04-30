extends Node2D

@export var rotation_speed_range := Vector2(0.1, 0.5) # degrees per frame
@export var direction_change_interval_range := Vector2(1.5, 4.0) # seconds
@export var max_rotation := 25.0 # degrees in either direction

var rotation_speed := 0.0
var direction := 1
var timer := 0.0
var next_change_time := 0.0
var base_rotation := 0.0

func _ready():
	base_rotation = rotation_degrees
	pick_new_rotation()

func _process(delta):
	timer += delta
	if timer > next_change_time:
		pick_new_rotation()
	
	var new_rotation = rotation_degrees + rotation_speed * direction
	var offset_from_base = new_rotation - base_rotation
	
	if abs(offset_from_base) > max_rotation:
		direction *= -1
		new_rotation = base_rotation + clamp(offset_from_base, -max_rotation, max_rotation)
	
	rotation_degrees = new_rotation

func pick_new_rotation():
	timer = 0.0
	next_change_time = randf_range(direction_change_interval_range.x, direction_change_interval_range.y)
	rotation_speed = randf_range(rotation_speed_range.x, rotation_speed_range.y)
	direction = sign(randf() - 0.5) # -1 or 1

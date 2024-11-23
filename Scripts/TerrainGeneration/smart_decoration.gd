extends Sprite2D

@export var max_angle := 30.0
@export var max_distance := 20
@export var rotation_speed := 0.1

var moving: Array[Node2D]

func unfollow_body(body):
	print("died: " + body.name)
	moving.erase(body)

func _process(delta):
	if moving:
		for obj in moving:
			if obj:
				var diff_x = obj.position.x - global_position.x
				if diff_x >= 0 and diff_x < max_distance and rotation > -deg_to_rad(max_angle):
					rotation = lerp_angle(rotation, rotation - deg_to_rad(max_angle), rotation_speed)
				elif diff_x < 0 and diff_x > -max_distance and rotation < deg_to_rad(max_angle):
					rotation = lerp_angle(rotation, rotation + deg_to_rad(max_angle), rotation_speed)



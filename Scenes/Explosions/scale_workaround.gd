extends RigidBody2D


# This script is necessary because godot is stupid 
# https://www.reddit.com/r/godot/comments/pq84de/scaling_of_rigidbodies/
func _ready():
	pass

func set_children_scale(scale: Vector2):
	pass

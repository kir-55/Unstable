class_name Sloper
extends Node


# This script spawns objects on the ground line and manages their rotaions

var line_start_x: float
var line_section_length: int
@export var line: Line2D
@export var terrain_generator: Node2D

@onready var line_offset = line.width / 2 - 1

func _ready():
	line_start_x = line.global_position.x
	line_section_length = terrain_generator.line_section_length


func _physics_process(delta):
	for sloper_target in get_tree().get_nodes_in_group("to_be_alined"):
		var closest_point = calc_closest_point(sloper_target)
		if closest_point > -1:
			var p1 = line.get_point_position(int(closest_point)) + line.global_position
			var p2 = line.get_point_position(int(closest_point) + 1) + line.global_position
			sloper_target.rotation = lerp_angle(sloper_target.rotation, (p2 - p1).angle(), 0.1)


func calc_closest_point(entity) -> int:
	return int((entity.global_position.x - line_start_x)/line_section_length)



func spawn_at_point(object: PackedScene, parent: Node, point: int, part_of_segment: float = 0):
	var p1 = line.get_point_position(point)
	var p2 = line.get_point_position(point + 1)
	
	var a = (p2.y - p1.y) / (p2.x - p1.x)
	var b = -a * p2.x + p2.y
	
	var distance = p2 - p1
	var instance = object.instantiate()
	var x = p1.x + line_section_length*part_of_segment
	
	instance.position = Vector2(x, x * a + b - line_offset)
	instance.rotation = distance.angle()
	parent.add_child(instance)
	return instance

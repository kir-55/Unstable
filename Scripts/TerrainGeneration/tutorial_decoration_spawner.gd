extends Node

var line_start_x: float
var line_section_length: int

@export var load_radius := 10
@export var max_radius := 15

@export var unload_radius := 500 # pixel-based

@export var random_system: RandomSystem
@export var sloper: Sloper

@export var camera : Camera2D

@export var line: Line2D
@export var terrain_generator: Node2D

@export var spawn_from: int = 2

@export var messages: Array[String]


@export var message_template: PackedScene

var decorations : Array[Decoration]
var last_point: int
var loaded_segments: Array[int]
var current_pattern_segment_index = 0


func _ready():
	line_start_x = line.global_position.x
	line_section_length = terrain_generator.line_section_length

func _process(delta):
	if camera:
		var cam_x = camera.global_position.x
		var closest_point = int((cam_x - line_start_x) / line_section_length)

		# Unload segments that are outside max_radius (in segments)
		for loaded_segment in loaded_segments:
			if abs(loaded_segment - closest_point) > max_radius:
				loaded_segments.erase(loaded_segment)

		# Unload decorations beyond unload_radius to the left of camera
		for child in get_children():
			if child.global_position.x < cam_x - unload_radius:
				child.queue_free()

		if closest_point != last_point:
			for i in range(load_radius * 2):
				var point = closest_point + i - load_radius
				var already_loaded := false

				for loaded_segment in loaded_segments:
					if point == loaded_segment:
						already_loaded = true
						break

				if !already_loaded and point > -1 and point < line.points.size():
					spawn_decoration(point)
					loaded_segments.append(point)

		last_point = closest_point

func spawn_decoration(point: int):
	if point%2 == 0 and point > spawn_from and decorations.size() > (point - spawn_from)/2-1 and point > spawn_from:
		var decoration: Decoration = decorations[(point - spawn_from)/2-1]
		
		var segment_part := 0.5
		var decoration_spawn_offset = float(decoration.width) / 2 / line_section_length
		var mirror = (random_system.get_rnd_int(0, 2) == 1) if decoration.can_be_mirrored else false
		sloper.spawn_at_point(decoration.prefab, self, point, segment_part, mirror)
		
	elif messages.size() > point/2 and point%2 == 1:
		var segment_part := 0.5
		var message = message_template.instantiate()
		message.get_child(0).text = messages[point/2]
		sloper.spawn_instance_at_point(message, self, point, segment_part, false)




extends Node

var line_start_x: float
var line_section_length: int

@export var load_radius := 10
@export var max_radius := 15

@export var unload_radius := 500 # pixel-based

@export var rs: RandomSystem
@export var sloper: Sloper

@export var camera : Camera2D

@export var line: Line2D
@export var terrain_generator: Node2D

@export var spawn_from: int = 2

var spawn_pattern := ""
var decorations : Array[Decoration]
var last_point: int
var loaded_segments: Array[int]
var current_pattern_segment_index = 0

class Position:
	var start: float
	var end: float

class DecorationSegment:
	var layer: GlobalEnums.DECORATION_LAYERS
	var position: Position

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

func spawn_decoration(point):
	var pattern_segments = spawn_pattern.split("|")
	var current_pattern_segment = pattern_segments[current_pattern_segment_index]
	var spawned_decorations_positions: Array[DecorationSegment]

	for i in range(current_pattern_segment.length()):
		var pattern_segment_char = current_pattern_segment[i]
		if pattern_segment_char == "*":
			continue

		var char_type_decorations = decorations.filter(func(x): return x.pattern_type == pattern_segment_char)
		var spawned = false

		if char_type_decorations.size() <= 0:
			continue

		if i + 1 < current_pattern_segment.length():
			if current_pattern_segment[i + 1] == "*":
				if rs.get_rnd_int_at(0, 99) < 50:
					continue

		while !spawned:
			for decoration in char_type_decorations:
				var decoration_segment: DecorationSegment = DecorationSegment.new()
				decoration_segment.layer = decoration.type

				if point < spawn_from and decoration.type != GlobalEnums.DECORATION_LAYERS.BACKGROUND:
					spawned = true
					break

				var rnd = rs.get_rnd_int_at(0, 99)
				if rnd < decoration.chance_to_spawn:
					var segment_part := 0.5
					var decoration_spawn_offset = float(decoration.width) / 2 / line_section_length

					if !decoration.spawn_on_center:
						segment_part = rs.get_rnd_float(0 + decoration_spawn_offset, 1 - decoration_spawn_offset)

					decoration_segment.position = calculate_start_end_pos(decoration.width, segment_part)

					var noMoreRetries = false
					for _i in range(7):
						if check_collision(decoration_segment, decoration.ignore_types, spawned_decorations_positions):
							segment_part = rs.get_rnd_float(0 + decoration_spawn_offset, 1 - decoration_spawn_offset)
							decoration_segment.position = calculate_start_end_pos(decoration.width, segment_part)
						else:
							noMoreRetries = true
							spawned_decorations_positions.append(decoration_segment)
							break

					if !noMoreRetries:
						spawned = true
						break

					var mirror = (rs.get_rnd_int(0, 2) == 1) if decoration.can_be_mirrored else false
					sloper.spawn_at_point(decoration.prefab, self, point, segment_part, mirror)
					spawned = true
					break

	current_pattern_segment_index = (current_pattern_segment_index + 1) % pattern_segments.size()

func check_collision(decoration_segment: DecorationSegment, ignore_types: Array[GlobalEnums.DECORATION_LAYERS], all_segments: Array[DecorationSegment]) -> bool:
	for segment in all_segments:
		if segment.layer in ignore_types:
			continue

		if decoration_segment.position.end >= segment.position.start and decoration_segment.position.start <= segment.position.end:
			return true

	return false

func calculate_start_end_pos(width: int, segment_part : float) -> Position:
	var segment_position = segment_part * line_section_length
	var position: Position = Position.new()
	position.start =  segment_position - width / 2
	position.end = segment_position + width / 2

	return position

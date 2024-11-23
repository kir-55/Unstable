extends Node

var line_start_x: float
var line_section_length: int

@export var load_radius := 10
@export var max_radius := 15

@export var rs: RandomSystem
@export var sloper: Sloper

@export var player: Node2D

@export var line: Line2D
@export var terrain_generator: Node2D

@export var spawn_from: int = 2 

@export var decorations: Array[Decoration]
var last_point: int
var loaded_segments: Array[int]

func _ready():
	line_start_x = line.global_position.x
	line_section_length = terrain_generator.line_section_length
	
func _process(delta):
	
	var x = player.position.x
	var closest_point = int((x - line_start_x)/line_section_length)
	
	for loaded_segment in loaded_segments:
		if abs(loaded_segment - closest_point) > max_radius:
			loaded_segments.erase(loaded_segment)
			for child in get_children():
				var cp = int((child.global_position.x - line_start_x)/line_section_length)
				if abs(cp - closest_point) > max_radius:
					child.queue_free()
	
	if closest_point != last_point:
		for i in range(load_radius*2):
			var point = closest_point + i - load_radius
			var already_loaded := false 
			for loaded_segment in loaded_segments:
				if point == loaded_segment:
					already_loaded = true
					break
			if !already_loaded and point > -1 and point < line.points.size():
				spawn_decoration(point)
				loaded_segments.append(point)
		

func spawn_decoration(point):
	if spawn_from <= point:
		var i := 0
		for decoration in decorations:
			if decoration and decoration.prefab:
				var rnd_i = rs.get_rnd_int_at(0, 99)
				if decoration.initial_chance > rnd_i:
					for _i in range(decoration.chance_multiplyer):
						var rnd = rs.get_rnd_int_at(0, 99)
						if decoration.chance_to_spawn > rnd:
							var segment_part := 0.5
							if !decoration.spawn_on_center:
								segment_part = rs.get_rnd_float_at(0, 1)
							var scale = rs.get_rnd_float(decoration.min_scale, decoration.max_scale)
							sloper.spawn_at_point(decoration.prefab, self, point, segment_part, Vector2(scale, scale))
				i += 1



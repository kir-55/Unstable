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

@export var spawn_gap : int = 2 # if there are problem with gaps please make sure every decoration has a unique name in .tres!

@export var spawn_from: int = 2

@export var decorations: Array[Decoration]

var last_point: int
var loaded_segments: Array[int]

var decorations_with_gap : Dictionary

func _ready():
	line_start_x = line.global_position.x
	line_section_length = terrain_generator.line_section_length
	spawn_from += int(GlobalVariables.times_treveled/3)
	
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
				for decoration_name in decorations_with_gap.keys():
					decorations_with_gap[decoration_name] +=1
				
				var decorations_with_gap_copy := decorations_with_gap.duplicate(true)
				
				for decoration_name in decorations_with_gap:
					if decorations_with_gap[decoration_name] > spawn_gap:
						decorations_with_gap_copy.erase(decoration_name)
				
				decorations_with_gap = decorations_with_gap_copy.duplicate(true)
				
				spawn_decoration(point)
				loaded_segments.append(point)
		

func spawn_decoration(point):
	var types_spawned: Array[GlobalEnums.DECORATION_LAYERS]
	if spawn_from <= point:
		var i := 0
		for decoration in decorations:
			var has_incompatible = false
			for type_spawned in types_spawned:
				if type_spawned in decoration.incompatible_with_types:
					has_incompatible = true
					break
				
			if has_incompatible:
				continue
			
			var decoration_gap = decorations_with_gap.get(decoration.name)
			if  decoration_gap != null and decoration_gap <= spawn_gap:
				continue
			
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
							types_spawned.append(decoration.type)
							if decoration.spawn_with_gap == true:
								if decoration_gap != null:
									decorations_with_gap[decoration.name] += 1
								else:
									decorations_with_gap[decoration.name] = 0
							sloper.spawn_at_point(decoration.prefab, self, point, segment_part, Vector2(scale, scale))
				i += 1

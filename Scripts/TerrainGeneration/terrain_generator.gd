extends Node

@export var light_occuluder: LightOccluder2D
@export var ground_line: Line2D
@export var grass_line: Line2D
@export var floor_collider: StaticBody2D

@export var rs: RandomSystem
@export var sloper: Sloper

@export var points_amount := 100

# x distance between points
@export var line_section_length = 300
@export var section_y_change_amplitude = 200

@export var decorations: Array[Decoration]



@export var big_rock: PackedScene

@export var tower_prefab: PackedScene
@export var main_house_prefab: PackedScene

@export var player: Node2D

@onready var line_offset = grass_line.width / 2 - 1

func _ready():
	for decoration in decorations:
		print(decoration.chance_to_spawn)
		
	ground_line.add_point(Vector2.ZERO)
	grass_line.add_point(Vector2.ZERO)
	points_amount -= 1
	
	for i in range(points_amount):
		if i % 2 == 1:
			create_next_point(grass_line.get_point_position(i) + Vector2(line_section_length, rs.get_rnd_float(-section_y_change_amplitude, section_y_change_amplitude)), grass_line.get_point_position(i))
		else:
			create_next_point(grass_line.get_point_position(i) + Vector2(line_section_length, 0), grass_line.get_point_position(i))
		
	
	
	var points = grass_line.points
		
	#poligon_points.append(points[points.size()-1] - Vector2(0, line_offset - 300))
	#poligon_points.append(points[0] - Vector2(0, line_offset - 300))
	
	#light_occuluder.occluder.polygon = poligon_points
	
	#print("occluder: " + str(light_occuluder.occluder.polygon[1]))
	#sloper.spawn_at_point(big_rock, self, 3, rs.get_rnd_float(0, 1))
	#$sloper.spawn_at_point(big_rock, self, points_amount - 3, rs.get_rnd_float(0, 1))
	
	#sloper.spawn_at_point(main_house_prefab, village, main_house_pos, rs.get_rnd_float(0, 1))

func _process(delta):
	if player.global_position.x > grass_line.get_point_position(grass_line.points.size()-1).x - 2000:
		if grass_line.points.size() % 2 == 1:
			create_next_point(grass_line.get_point_position(grass_line.points.size()-1) + Vector2(line_section_length, rs.get_rnd_float(-section_y_change_amplitude, section_y_change_amplitude)), grass_line.get_point_position(grass_line.points.size()-1))
		else:
			create_next_point(grass_line.get_point_position(grass_line.points.size()-1) + Vector2(line_section_length, 0), grass_line.get_point_position(grass_line.points.size()-1))


func create_next_point(position: Vector2, lastPosition: Vector2):
	var new_shape = CollisionShape2D.new()
	floor_collider.add_child(new_shape)
	var segment = SegmentShape2D.new()
	segment.a = lastPosition# - Vector2(0, line_offset)
	segment.b = position# - Vector2(0, line_offset)
	new_shape.shape = segment
	ground_line.add_point(position)
	grass_line.add_point(position)

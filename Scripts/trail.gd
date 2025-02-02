extends Node

@export var trails: Array[Line2D]
@export var amulet_system: Node
@export var max_number_of_points: int = 60

var player_old_positon: Vector2
@onready var player: Node2D = get_parent()


func _ready():
	player_old_positon = player.global_position
	if GlobalVariables.player_amulets.count(2) > 0:
		for trail in trails:
			trail.default_color = amulet_system.trail_color


func process_points():

	for trail in trails:
		trail.add_point(player.global_position)
	print("point spawned")
	
	for trail in trails:
		if trail.points.size() > max_number_of_points:
			trail.remove_point(0)

func remove_points():
	for trail in trails:
		trail.clear_points()

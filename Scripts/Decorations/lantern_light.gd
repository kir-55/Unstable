extends PointLight2D

@export_range(0.2, 2.0) var min_energy:= 0.6
@export_range(0.2, 2.0) var max_energy:= 1.0

@export_range(0.001, 0.1) var min_blink:= 0.005
@export_range(0.01, 0.2) var max_blink:= 0.05

@onready var distance = max_energy - min_energy

@export_color_no_alpha var color1: Color
@export_color_no_alpha var color2: Color

@export var blink_jump := 0.1
@export var change_speed := 0.05
var next_energy := 0.7

func _process(delta):
	change_speed = randf_range(min_blink,max_blink)
	
	if abs(next_energy - energy) < blink_jump:
		next_energy = randf_range(min_energy,max_energy)
	else:
		energy = lerp(energy, next_energy, change_speed)
	color = color2 * (energy-min_energy)/distance + color1

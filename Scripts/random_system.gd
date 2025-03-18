class_name RandomSystem
extends Node


# Use this script when generating terain, objects positions, man stats and other static stuff
# For dynamic stuff like man wounder direction don't use this script
var rng = RandomNumberGenerator.new()
var state


func _ready():
	rng.state = GlobalVariables.terrain_code

func get_rnd_int(min: int, max: int) -> int:
	return rng.randi_range(min, max)# randi_range
	
func get_rnd_float(min: float, max: float) -> float:
	return rng.randf_range(min, max)


func get_rnd_int_at(min: int, max: int) -> int:
	#var prev_state = rng.state
	var value = rng.randi_range(min, max)

	#rng.state = prev_state
	
	return value


func get_rnd_float_at(min: float, max: float) -> float:

	
	var value = rng.randf_range(min, max)

	
	return value

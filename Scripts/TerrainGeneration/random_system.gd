class_name RandomSystem
extends Node


# Use this script when generating terain, objects positions, man stats and other static stuff
# For dynamic stuff like man wounder direction don't use this script
var main_seed = "Dominik1"
var rng = RandomNumberGenerator.new()
var state


func _ready():
	rng.seed = hash(main_seed)
	#rng.state = 1
	pass

func get_rnd_int(min: int, max: int) -> int:
	return rng.randi_range(min, max)# randi_range
	
func get_rnd_float(min: float, max: float) -> float:
	return rng.randf_range(min, max)


func get_rnd_int_at(min: int, max: int, seed = main_seed) -> int:
	#var prev_state = rng.state
	
	rng.seed = hash(seed)
	#rng.state = at
	
	var value = rng.randi_range(min, max)
	
	rng.seed = hash(main_seed)
	#rng.state = prev_state
	
	return value


func get_rnd_float_at(min: float, max: float, seed = main_seed) -> float:
	#var prev_state = rng.state
	
	rng.seed = hash(seed)
	#rng.state = at
	
	var value = rng.randf_range(min, max)
	
	rng.seed = hash(main_seed)
	#rng.state = prev_state
	
	return value

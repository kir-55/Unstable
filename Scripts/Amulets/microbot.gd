extends CharacterBody2D

@export var speed: float = 100.0  # Movement speed
@export var acceleration: float = 5.0  # Smooth movement
@export var min_flight_time = 1.2 # Measured in seconds
@export var sizedown_sound_prefab: PackedScene

@onready var player_speed = GlobalVariables.player.velocity.x
@onready var player = get_tree().get

var min_distance_from_player = 0
var actual_speed : float
var target: Node2D = null

func get_new_speed():
	var new_speed
	if GlobalVariables.player.is_dashing:
		new_speed = GlobalVariables.player.velocity.x - GlobalVariables.player.DASH_SPEED_BOOST + speed
	else:
		new_speed = GlobalVariables.player.velocity.x + speed
	return new_speed

func _ready():
	min_distance_from_player = player_speed * min_flight_time
	actual_speed = get_new_speed()
	find_closest_target()

func _physics_process(delta):
	if target:
		actual_speed = get_new_speed()
		move_towards_target(delta)
	elif get_tree().get_nodes_in_group("Obsticle").size() == 0 or !is_instance_valid(target):
		velocity.x = lerp(velocity.x, actual_speed, acceleration * delta)
		find_closest_target()
		move_and_slide()

func find_closest_target():
	var closest_distance = INF
	var deadly_areas = get_tree().get_nodes_in_group("Obsticle")
	
	for area in deadly_areas:
		if area is Node2D:
			
			var distance = global_position.distance_to(area.global_position)
			if area.global_position.x - min_distance_from_player - global_position.x > 0 and distance < closest_distance:
				closest_distance = distance
				target = area

func move_towards_target(delta):
	if target and is_instance_valid(target) and !target.is_queued_for_deletion():
		var direction = (target.global_position - global_position).normalized()
		velocity = velocity.lerp(direction * actual_speed, acceleration * delta)  # Smooth movement
		rotation = velocity.angle()  # Rotate towards movement direction

		move_and_slide()

		# Check if close enough to scale the parent
		if global_position.distance_to(target.global_position) < 5:
			var instance = sizedown_sound_prefab.instantiate()
			get_tree().current_scene.add_child(instance)
			target.scale *= Vector2(0.5, 0.5)
			queue_free()
	else:
		find_closest_target()

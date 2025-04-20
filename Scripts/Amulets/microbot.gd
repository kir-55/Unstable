extends CharacterBody2D

@export var speed: float = 100.0  # Movement speed
@export var acceleration: float = 5.0  # Smooth movement
var target: Node2D = null
@onready var player = get_tree().get

@export var sizedown_sound_prefab: PackedScene

func _ready():
	find_closest_target()

func _physics_process(delta):
	if target:
		move_towards_target(delta)

func find_closest_target():
	var closest_distance = INF
	var deadly_areas = get_tree().get_nodes_in_group("Obsticle")  # Make sure nodes are in this group

	for area in deadly_areas:
		if area is Node2D:
			
			var distance = global_position.distance_to(area.global_position)
			if area.global_position.x - 500 - global_position.x > 0 and distance < closest_distance:
				closest_distance = distance
				target = area

func move_towards_target(delta):
	if target and is_instance_valid(target) and !target.is_queued_for_deletion():
		var direction = (target.global_position - global_position).normalized()
		velocity = velocity.lerp(direction * speed, acceleration * delta)  # Smooth movement
		rotation = velocity.angle()  # Rotate towards movement direction

		move_and_slide()

		# Check if close enough to scale the parent
		if global_position.distance_to(target.global_position) < 5:
			var instance = sizedown_sound_prefab.instantiate()
			get_tree().current_scene.add_child(instance)
			target.scale *= Vector2(0.5, 0.5)
			queue_free()

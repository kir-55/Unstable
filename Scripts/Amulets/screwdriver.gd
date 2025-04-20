extends CharacterBody2D

@export var target_decoration_pattern_char = "A"
@export var speed = 100.0
@export var acceleration: float = 5.0

@export var damage_factor := 70.0

var target : Node2D = null
var pattern_letter_variable_name = "pattern_letter"

func _ready():
	position.y -= 50
	find_closest_target()

func _physics_process(delta):
	move_towards_target(delta)

func find_closest_target():
	var closest_distance = INF
	var target_areas = get_tree().get_nodes_in_group("Obsticle").filter(func(obj):
		if pattern_letter_variable_name in obj and obj.has_node("HealthSystem"):
			return obj[pattern_letter_variable_name] == target_decoration_pattern_char
		else:
			return false
	)
	
	for obj in target_areas:
		if obj is Node2D:
			var distance = global_position.distance_to(obj.global_position)
			if obj.global_position.x - 500 - global_position.x > 0 and distance < closest_distance:
				closest_distance = distance
				target = obj
	if !target:
		velocity.x = speed

func move_towards_target(delta):
	if target and is_instance_valid(target) and !target.is_queued_for_deletion():
		var direction = (target.global_position - global_position).normalized()
		velocity = velocity.lerp(direction * speed, acceleration * delta)
		rotation = velocity.angle()  # Rotate towards movement direction
	else:
		find_closest_target()
	
	move_and_slide()

func _on_area_2d_area_entered(area):
	if area and area.has_node("HealthSystem"):
		if pattern_letter_variable_name in area:
			if area[pattern_letter_variable_name] == target_decoration_pattern_char:
				var area_health_system = area.get_node("HealthSystem")
				area_health_system.take_damage(area_health_system.max_health * damage_factor / 100)
				queue_free()

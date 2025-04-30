extends CharacterBody2D

@export_category("Movement")
@export var speed = 100.0
@export var acceleration: float = 5.0
@export var min_flight_time = 1.5 # Measured in seconds

@export_category("Attack related")
@export var damage_factor_percent := 70.0

@onready var player_speed = GlobalVariables.player.velocity.x

var min_distance_from_player = 0
var actual_speed : float
var target : Node2D = null

func _ready():
	min_distance_from_player = player_speed * min_flight_time
	actual_speed = player_speed + speed
	position.y -= 50
	find_closest_target()

func _physics_process(delta):
	actual_speed = player_speed + speed
	move_towards_target(delta)

func find_closest_target():
	var closest_distance = INF
	var target_areas = get_tree().get_nodes_in_group("Obsticle").filter(func(obj):
		if obj.has_node("HealthSystem"):
			return obj.global_position.x - min_distance_from_player - global_position.x > 0
		else:
			return false
		)
	target_areas.sort_custom(func(a, b):
		if a.get_node("HealthSystem").health == b.get_node("HealthSystem").health:
			return global_position.distance_to(a.global_position) >= global_position.distance_to(b.global_position)
		return a.get_node("HealthSystem").health > b.get_node("HealthSystem").health
	)
	
	for obj in target_areas:
		if obj is Node2D:
			var distance = global_position.distance_to(obj.global_position)
			if obj.global_position.x - min_distance_from_player - global_position.x > 0 and distance < closest_distance:
				closest_distance = distance
				target = obj
	if !target:
		velocity.x = actual_speed

func move_towards_target(delta):
	if target and is_instance_valid(target) and !target.is_queued_for_deletion():
		var direction = (target.global_position - global_position).normalized()
		velocity = velocity.lerp(direction * actual_speed, acceleration * delta)
		rotation = velocity.angle()  # Rotate towards movement direction
	else:
		find_closest_target()
	
	move_and_slide()

func _on_area_2d_area_entered(area):
	if area and area.has_node("HealthSystem"):
		var area_health_system = area.get_node("HealthSystem")
		area_health_system.take_damage(area_health_system.max_health * damage_factor_percent / 100)
		queue_free()

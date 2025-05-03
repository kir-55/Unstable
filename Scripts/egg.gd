extends CharacterBody2D

@export var explosion_scene: PackedScene

var speed = 250
const GRAVITY = 1000
const air_resistance = 2
var angle_change = 0.02

var in_flight := true

var motion = Vector2()

func _ready():
	var new_speed
	if GlobalVariables.player.is_dashing:
		new_speed = GlobalVariables.player.velocity.x - GlobalVariables.player.DASH_SPEED_BOOST + speed
	else:
		new_speed = GlobalVariables.player.velocity.x + speed
	speed = max(speed, new_speed)


func _physics_process(delta):
	$Sprite2D.rotation += 0.2
	
	
	
	motion = Vector2(0, -1).rotated(rotation) * speed
	if speed - 2 >= 0 and in_flight:
		speed -= 2
	else:
		speed = 0
	set_velocity(motion)
	move_and_slide()
	motion = velocity

	var probable_roatation = rotation + angle_change
	if(abs(probable_roatation) <= 90 and in_flight):
		if rotation > 0:
			rotation += angle_change
		else:
			rotation -= angle_change


	if is_on_floor() or is_on_wall():
		in_flight = false





func _on_egg_area_body_entered(body):
	if explosion_scene:
		var explosion = explosion_scene.instantiate()
		explosion.global_position = global_position
		get_tree().current_scene.add_child(explosion)
		queue_free()


func _on_egg_area_area_entered(area):
	if area.is_in_group("Obsticle") or area.get_parent().is_in_group("Obsticle") or area.is_in_group("Breakable"):
		if explosion_scene:
			var explosion = explosion_scene.instantiate()
			explosion.global_position = global_position
			get_tree().current_scene.add_child(explosion)
			queue_free()

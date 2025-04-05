extends CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		body.SPEED *= 1.5
		body.velocity.y -= 20
		

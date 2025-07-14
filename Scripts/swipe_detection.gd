extends Node

var swipe_start_pos := Vector2.ZERO
var is_swiping := false
var min_swipe_distance := 50  # Minimum distance to trigger swipe
var active_action := ""  # Action currently held

func _unhandled_input(event: InputEvent) -> void:
	# Start swipe
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			swipe_start_pos = event.position
			is_swiping = true
			active_action = ""
		else:
			# Release action when input ends
			if active_action != "":
				Input.action_release(active_action)
				active_action = ""
			is_swiping = false

	# Track swipe while dragging
	elif is_swiping and (event is InputEventScreenDrag or event is InputEventMouseMotion):
		var current_pos = event.position
		var delta = current_pos - swipe_start_pos
		if delta.length() >= min_swipe_distance and active_action == "":
			var abs_delta = delta.abs()
			if abs_delta.x > abs_delta.y:
				if delta.x > 0:
					print("Swipe Right → Dash")
					Input.action_press("dash")
					active_action = "dash"
				else:
					print("Swipe Left")
					# If you want action for left swipe, add here
			else:
				if delta.y > 0:
					print("Swipe Down")
					Input.action_press("bottom")
					active_action = "bottom"
				else:
					print("Swipe Up → Jump")
					Input.action_press("up")
					active_action = "up"

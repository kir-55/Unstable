extends AudioStreamPlayer2D

var pitched:= false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GlobalVariables.game_is_on and pitched:
		pitch_scale = 1
		pitched = false
	elif !GlobalVariables.game_is_on and !pitched:
		pitch_scale = 0.5
		pitched = true

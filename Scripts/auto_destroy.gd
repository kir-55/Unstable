extends Node  

@export var audio_stream : AudioStreamPlayer

func _on_finished():
	queue_free()
	
func play_sound():
	audio_stream.play()

extends Node  

@export var audio_stream : AudioStreamPlayer

func _on_finished():
	queue_free()


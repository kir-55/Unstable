extends Node2D

@export var speed = 50


func _process(delta):
	position.x += delta * speed

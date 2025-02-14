extends Camera2D

@export var speed = 50


func _process(delta):
	position.x += delta * speed

func _ready():
	GlobalFunctions.load_menu(GlobalVariables.current_menu)

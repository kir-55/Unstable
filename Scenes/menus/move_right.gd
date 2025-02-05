extends Node2D

@export var speed = 50
@export var menu_parent_path : NodePath


func _process(delta):
	position.x += delta * speed

func _ready():
	var menu_parent = get_node(menu_parent_path)
	GlobalFunctions.load_menu(GlobalVariables.MENU_LEVEL.MAIN, menu_parent)

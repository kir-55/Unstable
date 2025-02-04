extends Panel

@export var texture_rect: TextureRect

func _ready():
	if GlobalVariables.player_amulets.has(6):
		texture_rect.texture = GlobalVariables.epochs[GlobalVariables.next_epoch].baner

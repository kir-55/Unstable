extends Sprite2D

func _ready():
	self_modulate = GlobalVariables.epochs[GlobalVariables.current_epoch_id].grass_color


extends ProgressBar


func _ready():
	max_value = GlobalVariables.amulets.size()
	value = GlobalVariables.player_amulet_collection.size()

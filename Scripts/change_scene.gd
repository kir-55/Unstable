extends Timer


var destination: GlobalVariables.LEVELS


func _ready():
	destination = GlobalVariables.LEVELS[GlobalVariables.LEVELS.keys()[randi() % GlobalVariables.LEVELS.size()]]
	while GlobalVariables.last_world == destination:
		destination = GlobalVariables.LEVELS[GlobalVariables.LEVELS.keys()[randi() % GlobalVariables.LEVELS.size()]]
	
func _on_timeout():
	GlobalVariables.change_level(destination)
 

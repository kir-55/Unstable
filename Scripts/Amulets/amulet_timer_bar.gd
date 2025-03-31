extends ProgressBar

var amulet_timer: Timer # this variable value is later assigned after instantiating this scene

func _ready():
	max_value = amulet_timer.wait_time
	value = max_value

func _process(delta):
	value = amulet_timer.wait_time - amulet_timer.time_left

extends Label

var player


func _enter_tree():
	if !player:
		get_tree().current_scene.player_spawned.connect(_set_player)

func _set_player(player):
	self.player = player 

func _process(delta):
	if player:
		text = (str(int(GlobalVariables.last_score + int(player.global_position.x) / GlobalVariables.score_divider)))

extends Label

var player: Player


func _enter_tree():
	if !player:
		get_tree().root.get_child(4).player_spawned.connect(_set_player)

func _set_player(player):
	self.player = player 

func _process(delta):
	if player:
		text = (str(int(GlobalVariables.last_score + int(player.global_position.x) / GlobalVariables.score_divider)))

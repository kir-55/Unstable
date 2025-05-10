extends Timer

var player: Node2D
# 
@export var current_world_id: int



func _enter_tree():
	if !player:
		get_tree().root.get_child(4).player_spawned.connect(_set_player)

func _set_player(player):
	self.player = player 

@rpc("any_peer", "call_local")
func transition(destination, next_epoch_id: int):
	GlobalVariables.is_in_epoch = false
	if (GlobalVariables.game_is_on or (Client.active and Client.players_alive.size() > 1)):
		
		Engine.time_scale = 1
		if player:
			GlobalVariables.last_score = GlobalVariables.last_score + int(player.global_position.x) / GlobalVariables.score_divider
			
			if GlobalVariables.game_is_on and GlobalVariables.player_amulets.has(9):
				GlobalVariables.player_amulets.remove_at(GlobalVariables.player_amulets.find(9))
		
		GlobalVariables.next_epoch_id = next_epoch_id
		GlobalVariables.times_treveled += 1
		GlobalVariables.terrain_code += 1
		get_tree().change_scene_to_file(destination)
	else:
		print("cannot make transition")


func _on_timeout():
	print()
	print("TIMEOUT IN *** ", Client.id, "  ", Client.player_name ," ***")
	print("*** players: ", Client.players.keys())
	print("*** players alive: ", Client.players_alive)
	print("*** host_id: ", Client.host_id)
	print("*** reserved_host_id: ", Client.reserve_host_id)

	
	if !Client.active or Client.id == Client.host_id:
		print("CALLING TRANSITION (host is fine)")
		if GlobalVariables.game_is_on and player:
			var rnd = randi_range(0, 100)
			var destination = ""
			if GlobalVariables.times_treveled == 0 or rnd <= GlobalVariables.initial_chance_for_lag+GlobalVariables.times_treveled*3:
				destination = "res://Scenes/Locations/home.tscn"
			else:
				destination = "res://Scenes/age_travel_machine.tscn"
			
			
			var possible_epochs = range(GlobalVariables.epochs.size())
			print(possible_epochs)
			possible_epochs.erase(GlobalVariables.current_epoch_id)
			var next_epoch_id = possible_epochs.pick_random()

				
			if Client.active:
				transition.rpc(destination, next_epoch_id) 
			else: 
				transition(destination, next_epoch_id)
	

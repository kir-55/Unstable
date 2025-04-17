extends Timer

var player: Node2D
@export var current_world: GlobalEnums.LEVELS

func _enter_tree():
	if !player:
		get_tree().root.get_child(4).player_spawned.connect(_set_player)

func _set_player(player):
	self.player = player 

@rpc("any_peer", "call_local")
func transition(destination):
	if (GlobalVariables.game_is_on or (Client.active and Client.players_alive.size() > 1)):
		
		GlobalVariables.last_epoch = current_world
		Engine.time_scale = 1
		if player:
			GlobalVariables.last_score = GlobalVariables.last_score + int(player.global_position.x) / GlobalVariables.score_divider
			
			if GlobalVariables.game_is_on and GlobalVariables.player_amulets.has(9):
				GlobalVariables.player_amulets.remove_at(GlobalVariables.player_amulets.find(9))
		
		print("Next epoch" + str(GlobalVariables.next_epoch))
		GlobalVariables.times_treveled += 1
		GlobalVariables.terrain_code += 1
		get_tree().change_scene_to_file(destination)


func _on_timeout():
	if !Client.active or (Client.new_host_id != 0 and Client.new_host_id == Client.id) or (Client.new_host_id == 0 and Client.host_id == Client.id):
		if GlobalVariables.game_is_on and player:
			var rnd = randi_range(0, 100)
			var destination = ""
			if GlobalVariables.times_treveled == 0 or rnd <= GlobalVariables.initial_chance_for_lag+GlobalVariables.times_treveled*3:
				destination = "res://Scenes/Locations/home.tscn"
			else:
				destination = "res://Scenes/age_travel_machine.tscn"
				
			GlobalVariables.last_epoch = current_world
			GlobalVariables.next_epoch = GlobalEnums.LEVELS[GlobalEnums.LEVELS.keys()[randi() % GlobalEnums.LEVELS.size()]]
			while GlobalVariables.last_epoch == GlobalVariables.next_epoch:
				GlobalVariables.next_epoch = GlobalEnums.LEVELS[GlobalEnums.LEVELS.keys()[randi() % GlobalEnums.LEVELS.size()]]	
				
			if Client.active:
				transition.rpc(destination)
			else: 
				transition(destination)
	

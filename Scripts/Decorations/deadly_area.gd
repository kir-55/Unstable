extends Area2D

@export var death_messages: Array[String]

func _on_body_entered(body):
	if (body.name == "Player" or body.name == "Player" + str(Client.id)) and GlobalVariables.game_is_on:
		var canvas_layer = get_tree().current_scene.canvas_layer
		if body.kill():
			Engine.time_scale = 1
			GlobalVariables.game_is_on = false
			if canvas_layer:
				for child in canvas_layer.get_children():
					if child is TextureRect:
						child.queue_free()

			var last_score = GlobalVariables.last_score + int(body.global_position.x) / GlobalVariables.score_divider
			var best_score = GlobalVariables.best_score
			if last_score > best_score:
				GlobalVariables.best_score = last_score

			# Reset the variables
			GlobalVariables.last_score = last_score
			GlobalFunctions.end_timer()



			if !Client.active:
				# spawning death menu
				var game_over_menu = load("res://Scenes/Menus/game_over_menu.tscn")
				var instance = game_over_menu.instantiate()
				if death_messages and death_messages.size() != 0:
					instance.find_child("DeathMessage").append_text("[center][font_size=24][shake rate=20.0 level=3 connected=1][color='#c33c40']" + death_messages.pick_random() + "[/color][/shake][/font_size][center]")
				canvas_layer.add_child(instance)
			else:
				var time_elapsed = GlobalVariables.time_ended - GlobalVariables.time_started
				Client.player_died.rpc(Client.id, Client.player_name, last_score, time_elapsed)

		else:
				queue_free()



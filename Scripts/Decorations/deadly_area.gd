extends Area2D

@export var death_messages: Array[String]

func _on_body_entered(body):
	if (body.name == "Player" or body.name == "Player" + str(Client.id)) and GlobalVariables.game_is_on:
		var canvas_layer = get_tree().current_scene.canvas_layer

		if body.kill():

			Engine.time_scale = 1
			GlobalVariables.game_is_on = false


			var last_score = GlobalVariables.last_score + int(body.global_position.x) / GlobalVariables.score_divider
			var best_score = GlobalVariables.best_score
			if last_score > best_score:
				GlobalVariables.best_score = last_score

			# Reset the variables
			GlobalVariables.last_score = last_score
			GlobalFunctions.end_timer()



			if !Client.active:
				# GlobalFunctions.load_menu("game_over", true, false, add_death_message)
				if death_messages and death_messages.size() != 0:
					GlobalVariables.on_player_died.emit(death_messages.pick_random())
				else:
					GlobalVariables.on_player_died.emit()


				#canvas_layer.add_child(instance)

			else:
				var time_elapsed = GlobalVariables.time_ended - GlobalVariables.time_started
				Client.player_died.rpc(Client.id, Client.player_name, last_score, time_elapsed)

		else:
				queue_free()

# func add_death_message(instance):
# 	var death_message = death_messages.pick_random()
# 	instance.find_child("DeathMessage").append_text("[center][font_size=24][shake rate=20.0 level=3 connected=1][color='#c33c40']" + death_message + "[/color][/shake][/font_size][center]")
# 	instance.set_meta("death_message", death_message)

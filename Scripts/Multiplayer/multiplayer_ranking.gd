extends RichTextLabel

@export var end_state: Client.EndStates
@export var play_again: Button

func _ready():
	var sorted_dead_players = Client.dead_players.values()  # Get all players as an array
	sorted_dead_players.sort_custom(func(a, b): return a.time > b.time)  # Sort by survival time (descending)
	if end_state != Client.EndStates.Draw:
		var i = 1
		for p in Client.players:
			if !Client.dead_players.has(p.to_int()):
				append_text("[font_size=20]" + str(i) + ". " +Client.players[p].name + " 🥇[/font_size]" + "\n")
				break
			
		# Display sorted dead players
		for p in sorted_dead_players:
			i += 1
			var a =  "🥈" if i == 2 else "🥉"  if i == 3 else ""
			
			append_text("[font_size=20]" + str(i) + ". " + p.name + a + "[/font_size][font_size=12][shake rate=5 level=10](" + str(p.time) + "ms)[/shake][/font_size]" + "\n")
	
	elif play_again and Client.id == Client.host_id:
		play_again.disabled = false


func _process(delta):
	pass


func _on_play_again_pressed():
	Client.queue_to_play_again = true
	Client.join_lobby("", Client.player_name)
	


func _on_leave_pressed():
	Client.reset_multiplayer_connection()
	GlobalFunctions.load_menu("main")

extends RichTextLabel



func _ready():
	for p in Client.dead_players:
		append_text( "[font_size=20]" + p.name + "[/font_size][font_size=12][shake rate=5 level=10][sup](" + str(p.time) + "ms)[/sup][/shake][/font_size]" + "\n")



func _process(delta):
	pass


func _on_play_again_pressed():
	Client.join_lobby("", Client.player_name)
	Client.queue_to_play_again = true
		
		

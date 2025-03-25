extends Control

@export var in_lobby_label: RichTextLabel
@export var players_list: RichTextLabel

@export var start_game_button: Button

@export var timer: Timer

var old_players
var rtc_players


func _on_button_pressed():
	if !Client.voted_to_start_game:
		Client.start_game.rpc(Client.id)
		start_game_button.disabled = true
		
func _process(delta):
	if Client.players != old_players:
		rtc_players = Client.rtc_players.duplicate()
		if Client.players.size() != Client.rtc_players.size()+1:
			start_game_button.disabled = true
		players_list.text = ""
		for p in Client.players:
			players_list.text += "[center]" + Client.players[p].name +"[font_size=8](" + p + ")[/font_size][/center]\n"
		old_players = Client.players.duplicate()
		
	if Client.rtc_players != rtc_players:
		rtc_players = Client.rtc_players.duplicate()
		print("rtc playrert: " + str(rtc_players))
		if Client.players.size() == Client.rtc_players.size()+1:
			start_game_button.disabled = false

func _on_timer_timeout():
	if Client.lobby_id:
		timer.stop()
		in_lobby_label.text = "[center]In Lobby: " + Client.lobby_id + "[/center]"


func _on_leave_pressed():
	Client.leave_lobby()

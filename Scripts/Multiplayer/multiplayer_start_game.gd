extends Control

@export var in_lobby_label: RichTextLabel
@export var players_list: RichTextLabel

@export var start_game_button: Button

@export var timer: Timer

var old_players
var rtc_players
var old_votes

func _ready():
	if Client.players.size() <= 1:
		start_game_button.disabled = true
	else:
		start_game_button.disabled = false

func _on_button_pressed():
	if !Client.players_voted_start.has(Client.id):
		Client.start_game.rpc(Client.id)
		start_game_button.disabled = true
		
func _process(delta):
	if Client.players != old_players or Client.players_voted_start != old_votes or Client.players_rtc != rtc_players:
		old_players = Client.players.duplicate()
		old_votes = Client.players_voted_start.duplicate()
		rtc_players = Client.players_rtc.duplicate()

		players_list.text = ""
		for p in Client.players:
			players_list.text += "[center]" + Client.players[p].name + "[font_size=8](" + p + ")[/font_size]" + ("✅" if old_votes.has(p.to_int()) else "") + "[/center]\n"

		var all_connected = Client.players_rtc.size() == Client.players.size() - 1
		var client_has_not_voted = !Client.players_voted_start.has(Client.id)
		if Client.players.size() <= 1:
			start_game_button.disabled = true
			pass
		if all_connected and Client.players.size() > 1:
			start_game_button.disabled = !client_has_not_voted

func _on_timer_timeout():
	if Client.lobby_id:
		timer.stop()
		in_lobby_label.text = '[center]In Lobby: [url={"lobby": "' + Client.lobby_id + '"}]' + Client.lobby_id + '[/url][/center]'


func _on_leave_pressed():
	Client.leave_lobby()


func _on_in_lobby_meta_clicked(meta):
		# Get the current contents of the clipboard
	var li = JSON.parse_string(meta)["lobby"]
	
	var current_clipboard = DisplayServer.clipboard_get()
	DisplayServer.clipboard_set(li)
	
	in_lobby_label.text = '[center][color=c2d64f]Copied to clipboard![/color] [url={"lobby": "' + Client.lobby_id + '"}]' + Client.lobby_id + '[/url][/center]'

extends Control

@export var in_lobby_label: RichTextLabel
@export var players_list: RichTextLabel

@export var start_game_button: Button

@export var timer: Timer

var old_players
var rtc_players
var old_votes


func _on_button_pressed():
	if !Client.players_voted.has(Client.id):
		Client.start_game.rpc(Client.id)
		start_game_button.disabled = true
		
func _process(delta):
	if Client.players != old_players or Client.players_voted != old_votes:
		rtc_players = Client.players_rtc.duplicate()
		old_votes = Client.players_voted.duplicate()
		
		if Client.players.size() != Client.players_rtc.size()+1:
			start_game_button.disabled = true
		players_list.text = ""
		for p in Client.players:
			players_list.text += "[center]" + Client.players[p].name + "[font_size=8](" + p + ")[/font_size]" + ("✅" if old_votes.has(p.to_int())  else "") + "[/center]\n"
		old_players = Client.players.duplicate()
		
	if Client.players_rtc != rtc_players:
		rtc_players = Client.players_rtc.duplicate()
		print("rtc playrert: " + str(rtc_players))
		if Client.players.size() == Client.players_rtc.size()+1 and !Client.players_voted.has(Client.id):
			print(Client.players.size())
			start_game_button.disabled = false

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
	
	in_lobby_label.text = '[center][color=c2d64f]Coppied to clipboard![/color] [url={"lobby": "' + Client.lobby_id + '"}]' + Client.lobby_id + '[/url][/center]'
	print("clicked on: " + li)

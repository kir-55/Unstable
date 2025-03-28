extends Control

@export var nickname_input: LineEdit
@export var lobby_id_input: LineEdit
@export var join_button: Button
@export var log: RichTextLabel

func _ready():
	Client.connect_to_server()
	


func _on_button_pressed():
	Client.active = true
	Client.join_lobby(lobby_id_input.text, nickname_input.text)
	#GlobalFunctions.load_menu("multiplayer_lobby")



func _on_exit_pressed():
	Client.active = false
	GlobalFunctions.load_menu("main")



func _on_create_pressed():
	var l = nickname_input.text.length()
	if l == 0:
		log.text = "[center][shake rate=5 level=10][color=#c33c40]Nickname can't be empty![/color][/shake][/center]"
	elif l > 10:
		log.text = "[center][shake rate=5 level=10][color=#c33c40]Nickname is too long[/color][/shake][/center]"
	else:
		Client.active = true
		Client.join_lobby("", nickname_input.text)
		log.text = "[center][shake rate=5 level=10][font_size=10][color=#c33c40]If nothing dosnt load\nthe menu dos't exist[/color][/font_size][/shake][/center]"


func _on_lobby_id_text_changed(new_text):
	if new_text != "":
		join_button.disabled = false
	else:
		join_button.disabled = true

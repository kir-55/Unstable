extends Control

@export var nickname_input: LineEdit
@export var lobby_id_input: LineEdit


func _ready():
	Client.connect_to_server()
	


func _on_button_pressed():
	Client.active = true
	Client.join_lobby(nickname_input.text, lobby_id_input.text)
	GlobalFunctions.load_menu("multiplayer_lobby")

extends Control

@export var nickname_input: LineEdit
@export var lobby_id_input: LineEdit


func _ready():
	Client.connect_to_server()
	


func _on_button_pressed():
	Client.active = true
	Client.join_lobby(lobby_id_input.text, nickname_input.text)
	#GlobalFunctions.load_menu("multiplayer_lobby")



func _on_exit_pressed():
	GlobalFunctions.load_menu("main")


func _on_create_pressed():
	Client.active = true
	Client.join_lobby("", nickname_input.text)

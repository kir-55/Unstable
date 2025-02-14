extends Node2D

signal player_spawned(player: Player)

@export var player_prefab: String = "res://Scenes/player.tscn"
@export var spawn_point: Node2D
@export var amulets_panel: VBoxContainer

func _ready():
	if Client.active:
		for i in Client.players:
			var player = load(player_prefab).instantiate()
			if int(i) == Client.id:
				player_spawned.emit(player)
			
			player.global_position = spawn_point.global_position
			player.name = "Player" + str(i)
			get_tree().root.get_child(4).add_child(player)
	else:
		var player = load(player_prefab).instantiate()
		player.global_position = spawn_point.global_position
		player_spawned.emit(player)
		get_tree().root.get_child(4).add_child(player)

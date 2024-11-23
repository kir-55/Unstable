extends Node2D

@export var player: CharacterBody2D
@export var spawn_offset_x: float = 300.0  # Jak daleko przed graczem ma spaść strzała
@export var horizontal_speed: float = -GlobalVariables.player_global_speed  # Ruch w lewo, dopasowany do ruchu gracza


@onready var arrow_scene = preload("res://Scenes/arrow.tscn")  # Ładowanie sceny strzały

func _ready():
	# Ustaw Timer jako automatyczny i połącz sygnał timeout
	var timer = $Timer
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	spawn_arrow()

func spawn_arrow():
	# Utwórz nową instancję strzały
	var arrow = arrow_scene.instantiate()
	
	# Ustaw jej pozycję trochę przed graczem
	var spawn_position = player.global_position + Vector2(spawn_offset_x, 0)
	arrow.global_position = spawn_position
	
	# Dodaj strzałę jako dziecko głównej sceny
	get_tree().root.get_child(0).add_child(arrow)

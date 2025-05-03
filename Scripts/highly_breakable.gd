extends Node

@export var area: Area2D
@export var health_system: HealthSystem
@export var damage_by_player: int = 20

func _ready():
	area.body_entered.connect(_on_area_body_entered)

func _on_area_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		health_system.take_damage(damage_by_player)

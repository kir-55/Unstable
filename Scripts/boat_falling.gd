extends Area2D

@export var amount_of_fall: int = 10
@export var fall_duration: float = 0.3
@export var return_delay: float = 0.5
@export var return_duration: float = 0.5

var fallen := false
var original_y := 0.0

func _ready():
	original_y = get_parent().position.y

func _on_body_exited(body):
	if body.is_in_group("Player") and not fallen:
		var parent = get_parent()
		var tween = create_tween()
		tween.tween_property(parent, "position:y", original_y + amount_of_fall, fall_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_interval(return_delay)
		tween.tween_property(parent, "position:y", original_y, return_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tween.tween_callback(Callable(self, "on_return_finished"))
		fallen = true

func on_return_finished():
	fallen = false

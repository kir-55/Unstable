extends Panel


@export_category("Buttons")
@export var play_button: Button
@export var story_play_button: Button
@export var endless_play_button: Button
@export var tutorial_button: Button
@export var cancel_button: Button
@export var multiplayer_button: Button
@export var progress_button: Button
@export var settings_button: Button
@export var exit_button: Button



func _ready():
	GlobalVariables.is_gamepad_controlling = false
	play_button.visible = true
	story_play_button.visible = false
	endless_play_button.visible = false
	cancel_button.visible = false
	tutorial_button.visible = false
	multiplayer_button.visible = true
	progress_button.visible = true
	settings_button.visible = true
	exit_button.visible = true


func _on_play_pressed():
	GlobalVariables.is_gamepad_controlling = false
	play_button.visible = false
	story_play_button.visible = true
	endless_play_button.visible = true
	cancel_button.visible = true
	tutorial_button.visible = true
	multiplayer_button.visible = false
	progress_button.visible = false
	settings_button.visible = false
	exit_button.visible = false


func _on_cancel_pressed():
	GlobalVariables.is_gamepad_controlling = false
	play_button.visible = true
	story_play_button.visible = false
	endless_play_button.visible = false
	cancel_button.visible = false
	tutorial_button.visible = false
	multiplayer_button.visible = true
	progress_button.visible = true
	settings_button.visible = true
	exit_button.visible = true


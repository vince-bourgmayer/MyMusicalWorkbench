# -----------------------------------------------------------------------------
# handplane_game.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends ToolGame
class_name HandPlaneGame

@onready var jackplane = $JackPlane

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	pass

func handle_specific_input(event: InputEvent) -> void:
	if event.is_action("ui_up") || event.is_action("ui_down") || event.is_action("ui_left") || event.is_action("ui_right"):
		if event.is_pressed():
			jackplane.set_rotating(true)
		elif event.is_released():
			jackplane.set_rotating(false)
		
	if event.is_action("ui_accept"):
		if event.is_pressed():
			jackplane.push(true)
		elif event.is_released():
			jackplane.push(false)
			
	if event.is_action_released("trigger_left"):
		jackplane.press_front(event.get_action_strength("trigger_left"))
			
	if event.is_action("trigger_right"):
		jackplane.press_back(event.get_action_strength("trigger_right"))
	
	if event.is_action_released("ui_cancel"):
		cancel_game("Do you want to stop planing ?", "Press A to validate")
	pass

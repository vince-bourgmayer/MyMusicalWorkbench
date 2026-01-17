# -----------------------------------------------------------------------------
# handplane_game.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends ToolGame
class_name HandPlaneGame


func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	pass


func handle_specific_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		cancel_game("Do you want to stop planing ?", "Press A to validate")
	pass

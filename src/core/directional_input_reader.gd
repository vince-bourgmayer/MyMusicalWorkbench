# -----------------------------------------------------------------------------
# direction_input_reader.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node
class_name DirectionalInputReader

var _direction := Vector2.ZERO

signal direction_changed(direction: Vector2)

func _process(_delta: float) -> void:
	var newDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if (newDirection != _direction):
		_direction = newDirection
		direction_changed.emit(_direction)

# -----------------------------------------------------------------------------
# direction_input_reader.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node
class_name DirectionalInputReader

var _left_stick_direction := Vector2.ZERO
var _right_stick_direction := Vector2.ZERO

signal left_stick_direction_changed(direction: Vector2)
signal right_stick_direction_changed(direction: Vector2)

func _process(_delta: float) -> void:
	_read_left_stick_direction()


func _read_left_stick_direction():
	var newLeftStickDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if (newLeftStickDirection != _left_stick_direction):
		_left_stick_direction = newLeftStickDirection
		left_stick_direction_changed.emit(_left_stick_direction)

func _read_right_stick_direction():
	var newRightStickDirection = Input.get_vector("joypad_R_left", "joypad_R_right", "joypad_R_up", "joypad_R_down")
	if (newRightStickDirection != _right_stick_direction):
		_right_stick_direction = newRightStickDirection
		right_stick_direction_changed.emit(_right_stick_direction)

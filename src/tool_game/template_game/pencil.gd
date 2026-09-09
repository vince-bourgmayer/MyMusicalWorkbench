# -----------------------------------------------------------------------------
# pencil.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D
class_name Pencil

@export var move_speed: float = 250.0
var movement_bounds: Rect2 = Rect2()
var _current_direction := Vector2.ZERO

func set_movement_bounds(bounds: Rect2) -> void:
	movement_bounds = bounds

func set_move_direction(direction: Vector2) -> void:
	_current_direction = direction

func _process(delta: float) -> void:
	if _current_direction == Vector2.ZERO:
		return

	var new_position = position + _current_direction * move_speed * delta
	if movement_bounds.has_area():
		new_position.x = clamp(new_position.x, movement_bounds.position.x, movement_bounds.end.x)
		new_position.y = clamp(new_position.y, movement_bounds.position.y, movement_bounds.end.y)
	position = new_position

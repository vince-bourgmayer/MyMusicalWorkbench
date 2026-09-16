# -----------------------------------------------------------------------------
# pencil.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D
class_name Pencil

signal drawing(position: Vector2)

@export var move_speed: float = 250.0
var movement_bounds: Rect2 = Rect2()
var _current_direction := Vector2.ZERO
var _is_drawing := false
var _last_draw_position := Vector2.INF

func set_movement_bounds(bounds: Rect2) -> void:
	movement_bounds = bounds

func set_move_direction(direction: Vector2) -> void:
	_current_direction = direction

func set_drawing(pressure: float):
	#TODO find a way to make visua clue that something happens
	# May be a slight scale up/down ...
	# So... inform pencil to let it give visual output
	# And then...kinda...connect woodPiece to pencil, so
	# pencil position let a mark on the wood..
	_is_drawing = (pressure >= 0.1)

func _process(delta: float) -> void:
	if _current_direction != Vector2.ZERO:
		var new_position = self.position + _current_direction * move_speed * delta
		if movement_bounds.has_area():
			new_position.x = clamp(new_position.x, movement_bounds.position.x, movement_bounds.end.x)
			new_position.y = clamp(new_position.y, movement_bounds.position.y, movement_bounds.end.y)
		self.position = new_position

	if _is_drawing:
		if _last_draw_position != Vector2.INF:
			drawing.emit(_last_draw_position, self.position)
		_last_draw_position = self.position
	else:
		_last_draw_position = Vector2.INF

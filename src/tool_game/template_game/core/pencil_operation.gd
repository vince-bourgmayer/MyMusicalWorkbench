# -----------------------------------------------------------------------------
# wood_operation.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends WoodOperation
class_name PencilOperation

var _pencil_diameter: int
var _from: Vector2
var _to: Vector2
var _toolEffect = func (_old_pixel_color: Color) -> Color:
	return Color.DIM_GRAY

func _init(from: Vector2, to: Vector2, diameter: int):
	_from = from
	_to = to
	_pencil_diameter = diameter

func apply_to_surface(current: WoodSurface) -> bool:
	if _from == _to:
		return false
	return current.get_data().draw_line(_from, _to, _pencil_diameter, _toolEffect)

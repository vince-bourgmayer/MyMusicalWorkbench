# -----------------------------------------------------------------------------
# plane_operation.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends WoodOperation
class_name PlaneOperation

var MOVEMENT_SPEED = 250
var relative_position := 0.0 # used for lerp, it's the position on the current segment
var direction = 0 # -1 backward, 0 idle, +1 forward

var _start_point: Vector2


func apply_to_surface(current: WoodSurface) -> bool:
	return true

func apply_to_thickness(current: WoodThickness) -> bool:
	return true

 
func _init(start_point: Vector2) -> void:
	if start_point == null:
		#TODO throw an error
		pass
	_start_point = start_point

func set_direction(p_direction: int) -> void:
	direction = clamp(p_direction, -1, 1)

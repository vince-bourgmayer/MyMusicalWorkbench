# -----------------------------------------------------------------------------
# plane_operation.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends WoodOperation
class_name PlaneOperation

var MOVEMENT_SPEED = 250
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
	

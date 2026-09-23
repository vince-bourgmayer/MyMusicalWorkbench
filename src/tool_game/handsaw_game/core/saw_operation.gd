# -----------------------------------------------------------------------------
# saw_operation.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends WoodOperation
class_name SawOperation

var _start_point: Vector2
var _end_point: Vector2
var _progression: float

func _init(start_point: Vector2, end_point: Vector2):
	_start_point = start_point
	_end_point = end_point
	_progression = 0.0
	
func update_progression(new_value: float):
	_progression = new_value #todo clamp between 0 & 1
	
func apply_to_geometry(woodGeometry: WoodGeometry) -> bool:
	if _progression == 1.0: #is complete
		return true
	return false

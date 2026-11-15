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
var _increment: float = 0.005

func _init(start_point: Vector2, end_point: Vector2):
	_start_point = start_point
	_end_point = end_point
	_progression = 0.0
	_increment = _compute_increment()

	
func _compute_increment() -> float:
	var line_length = _start_point.distance_to(_end_point)
	return 0.15 / line_length


func update_progression():
	_progression = minf(_progression+_increment, 1.0 )
	
func get_current_position() -> Vector2:
	return _start_point.lerp(_end_point, _progression)

func get_cut_angle() -> float:
	return ((_start_point - _end_point).angle_to(Vector2(0,1)) +3.141593 )* -1

func apply_to_geometry(woodGeometry: WoodGeometry) -> bool:
	if is_complete():
		var slicer = PolygonSlicer.new(woodGeometry.get_center())

		var result = slicer.cut_polygon(woodGeometry.get_points(), _start_point, _end_point)
		woodGeometry.set_points(result)

		return true
	return false

func is_complete() -> bool:
	return _progression == 1.0

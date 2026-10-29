# -----------------------------------------------------------------------------
# segment.gd
# Copyright (c) 2025-2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends RefCounted
class_name Segment

var _start: Vector2
var _end: Vector2

static func from_polygon(polygon: PackedVector2Array) -> Array[Segment]:
	var result : Array[Segment] = []
	var polygon_size = polygon.size()
	for point_index in range(polygon_size):
		var current_point = polygon[point_index]
		var next_point = polygon[point_index+1] if point_index+1 < polygon_size else polygon[0]
		var segment = Segment.new(current_point, next_point)
		result.append(segment)

	return result

func _init(start: Vector2, end: Vector2):
	_start = start
	_end = end

func get_length() -> float:
	return (_end-_start).length()
	
func duplicate() -> Segment:
	return Segment.new(_start, _end)

func print()-> void:
	print("Segment [",_start,";",_end,"]")
	
func get_start_point() -> Vector2:
	return _start
	
func get_end_point() -> Vector2:
	return _end

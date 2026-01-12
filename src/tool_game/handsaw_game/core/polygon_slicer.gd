# -----------------------------------------------------------------------------
# polygon_sclicer.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Object
class_name PolygonSlicer

var center : Vector2 # reference to center of the polygon to cut

func _init(p_center: Vector2):
	center = p_center

func cut_polygon(polygon: PackedVector2Array, cutStart: Vector2, cutEnd: Vector2) -> PackedVector2Array:
	var alreadyAppended = false
	var result: Array[Vector2] = []
	var sorting_by_angle = Callable(self, "_angle_compare")
	
	for i in range(polygon.size()):
		var point = polygon[i]
		var is_point_to_remove = is_point_beyond_cut(point, cutStart, cutEnd)
		if is_point_to_remove:
			if !alreadyAppended:
				result.append(cutStart)
				result.append(cutEnd)
				alreadyAppended = true
		else:
			result.append(point)
	result.sort_custom(sorting_by_angle)
	
	return result

func is_point_beyond_cut(point: Vector2, cutStart: Vector2, cutEnd: Vector2) -> bool:
	return Geometry2D.segment_intersects_segment(cutStart, cutEnd, center, point) != null
	
func _angle_compare(a: Vector2, b: Vector2) -> int:
	var angle_a = atan2(a.y, a.x)
	var angle_b = atan2(b.y, b.x)
	
	return angle_a < angle_b

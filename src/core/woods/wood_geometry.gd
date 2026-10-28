# -----------------------------------------------------------------------------
# wood_geometry.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# Describe externale shape of piece of wood
# -----------------------------------------------------------------------------
extends RefCounted
class_name WoodGeometry

var _points : PackedVector2Array
var _origin_size : Vector2

#TODO for later: doing this way, considers always a wood piece as a rectangle shape at start
func _init(size: Vector2):
	_origin_size = size
	_points = PackedVector2Array()
	_points.append_array([Vector2.ZERO, Vector2(_origin_size.x, 0), _origin_size, Vector2(0, _origin_size.y)])

func get_points() -> PackedVector2Array:
	return _points.duplicate()
	
func set_points(points: PackedVector2Array) -> void:
	#TODO: hande case where points is null or empty
	_points = points

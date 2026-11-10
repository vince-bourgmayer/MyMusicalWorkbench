# -----------------------------------------------------------------------------
# wood_geometry.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# Describe externale shape of piece of wood
# -----------------------------------------------------------------------------
extends RefCounted
class_name WoodGeometry

#TODO find a way to improve/replace below vector
const HORIZONTAL_SYMETRY = Vector2(1, -1)
const VERTICAL_SYMETRY = Vector2(-1, 1)
const DIAGONAL_SYMETRY = Vector2(-1, -1)

var _points : PackedVector2Array
var _origin_size : Vector2

func _init(size: Vector2):
	_origin_size = size
	_points = PackedVector2Array()
	
	var corner = _origin_size/2
	_points.append(corner * DIAGONAL_SYMETRY) #top left 
	_points.append(corner * HORIZONTAL_SYMETRY) #top right
	_points.append(corner) #bottom right
	_points.append(corner * VERTICAL_SYMETRY) # bottom left

func get_points() -> PackedVector2Array:
	return _points.duplicate()
	
func set_points(points: PackedVector2Array) -> void:
	if points == null or points.is_empty():
		#TODO: hande case where points is null or empty
		return
	_points = points

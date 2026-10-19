# -----------------------------------------------------------------------------
# CutStartMarker.gd
# Copyright (c) 2025-2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Marker2D
class_name CutMarker

const MOVEMENT_SPEED = 250

var _path_segments : Array[Segment] = []
var _path_length := 0.0
var _distance_on_path := 0.0
var _direction : float = 0.0 # -1 backward, 0 idle, +1 forward

var _color:Color = Color.RED

func _init(_color:Color = Color.RED) -> void:
	_color = _color
	
func _process(delta: float) -> void:
	_move_along_path(delta)

func set_path(segments: Array[Segment]) -> void:
	_path_segments = segments
	_path_length = 0.0
	_distance_on_path =0.0
	
	for segment in _path_segments:
		_path_length += segment.get_length()
		
	_update_position()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 5, _color)

# --- MOVE Logic ---
# The marker's position is stored as a distance (px) travelled along the whole contour,
# like a tape measure unrolled. update_position() finds which segment that distance falls in.
func _move_along_path(delta: float):
	if _direction == 0.0 or _path_length == 0.0:
		return   # idle, or no usable path (the loops below would never end)

	_distance_on_path += _direction * MOVEMENT_SPEED * delta

	while _distance_on_path > _path_length:
		_distance_on_path -= _path_length
	while _distance_on_path < 0.0:
		_distance_on_path += _path_length

	_update_position()

func _update_position() -> void:
	var remaining := _distance_on_path
	for segment in _path_segments:
		var segment_length = segment.get_length()
		if segment_length == 0.0:
			continue   # skip zero-length segments (avoids dividing by zero)
		if remaining <= segment_length:
			position = segment.start.lerp(segment.end, remaining / segment_length)
			return
		remaining -= segment_length

func set_direction(direction: float)-> void:
	_direction = direction

func get_distance_on_path() -> float:
	return _distance_on_path
	
func set_distance_on_path(distance: float) -> void:
	_distance_on_path = distance

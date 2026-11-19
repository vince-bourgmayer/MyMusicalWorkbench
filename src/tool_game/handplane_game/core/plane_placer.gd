# -----------------------------------------------------------------------------
# plane_placer.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends RefCounted
class_name PlanePlacer

const MOVEMENT_SPEED = 250

var _relative_position := 0.0 # used for lerp, it's the position on the current segment
var _direction = 0 # -1 backward, 0 idle, +1 forward

var _start_line: Segment

func _init(start_line: Segment) -> void:
	if start_line == null:
		#todo throw an error
		pass
	_start_line = start_line
	
func set_direction(p_direction: int) -> void:
	_direction = clamp(p_direction, -1, 1)

func get_start_position() -> Vector2:
	var clamped_relative_position = _clamp_lerp_value(_relative_position)
	return _start_line.get_start_point().lerp(_start_line.get_end_point(), clamped_relative_position)

func update_start_position(delta: float) -> Vector2:
	var edge_length = _start_line.get_length()
	if edge_length > 0:
		var distance_per_frame = (MOVEMENT_SPEED * delta) / edge_length
		var adjustment = _direction * distance_per_frame
		_relative_position = _clamp_lerp_value(_relative_position + adjustment) # double clamp assumed as defensive

	return get_start_position()

func _clamp_lerp_value(value: float) -> float:
	return clamp(value, 0.0, 1.0)

# -----------------------------------------------------------------------------
# plane_operation.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends RefCounted
class_name PlaneOperation

var start_edge: Segment

var MOVEMENT_SPEED = 250
var relative_position := 0.0 # used for lerp, it's the position on the current segment
var direction = 0 # -1 backward, 0 idle, +1 forward

func set_start_edge(edge: Segment) -> void:
	start_edge = edge
	
func set_direction(p_direction: int) -> void:
	direction = clamp(p_direction, -1, 1)

func get_start_position() -> Vector2:
	if start_edge == null:
		return Vector2.ZERO
	else:
		var clamped_relative_position = _clamp_lerp_value(relative_position)
		return start_edge.start.lerp(start_edge.end, clamped_relative_position)

func update_start_position(delta: float) -> Vector2:
	if start_edge != null:
		var edge_length = start_edge.get_length()
		if edge_length > 0:
			var distance_per_frame = (MOVEMENT_SPEED * delta) / edge_length
			var adjustment = direction * distance_per_frame
			relative_position = _clamp_lerp_value(relative_position + adjustment) # double clamp assumed as defensive

	return get_start_position()

func _clamp_lerp_value(value: float) -> float:
	return clamp(value, 0.0, 1.0)

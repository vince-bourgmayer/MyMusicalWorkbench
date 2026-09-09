# -----------------------------------------------------------------------------
# jig.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Sprite2D
class_name Jig

@export var move_speed: float = 200.0
@export var rotation_speed := 2.0

var movement_bounds: Rect2 = Rect2()
var _current_direction := Vector2.ZERO
var _current_rotation_direction := Vector2.ZERO

func set_movement_bounds(bounds: Rect2) -> void:
	movement_bounds = bounds

func set_move_direction(direction: Vector2) -> void:
	_current_direction = direction

func set_rotation_direction(direction : Vector2) -> void:
	_current_rotation_direction = direction

func _process(delta: float) -> void:
	_move(delta)
	_rotate(delta)

func _move(delta):
	if _current_direction == Vector2.ZERO:
		return

	var new_position = position + _current_direction * move_speed * delta
	if movement_bounds.has_area():
		new_position.x = clamp(new_position.x, movement_bounds.position.x, movement_bounds.end.x)
		new_position.y = clamp(new_position.y, movement_bounds.position.y, movement_bounds.end.y)
	position = new_position


func _rotate(delta):
	if _current_rotation_direction == Vector2.ZERO:
		return
	self.rotation += _current_rotation_direction.x * rotation_speed * delta

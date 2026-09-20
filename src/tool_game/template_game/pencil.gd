# -----------------------------------------------------------------------------
# pencil.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends CharacterBody2D
class_name Pencil

signal drawing(position: Vector2)

@export var move_speed: float = 200.0
var _movement_bounds: Rect2 = Rect2()
var _current_direction := Vector2.ZERO
var _is_drawing := false
var _last_draw_position := Vector2.INF
@onready var _overlap_detector: Area2D = $Area2D

func set_movement_bounds(bounds: Rect2) -> void:
	_movement_bounds = bounds

func set_move_direction(direction: Vector2) -> void:
	_current_direction = direction

func set_drawing(pressure: float):	
	var wants_to_draw = pressure >= 0.1
	if wants_to_draw and not _is_drawing and _overlap_detector.has_overlapping_bodies():
		return 
	_is_drawing = wants_to_draw

func _process(_delta: float) -> void:
	if _is_drawing:
		self.collision_mask = 1
	else:
		self.collision_mask = 0
	pass

func _physics_process(_delta: float) -> void:
	if _current_direction != Vector2.ZERO:
		velocity = _current_direction * move_speed
		move_and_slide()

	if _is_drawing:
		if _last_draw_position != Vector2.INF:
			$Visual.scale = Vector2.ONE
			drawing.emit(_last_draw_position, self.position)
		_last_draw_position = self.position
	else:
		$Visual.scale = Vector2(1.1, 1.1)
		_last_draw_position = Vector2.INF

# -----------------------------------------------------------------------------
# jack_plane.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D
class_name JackPlane

signal nose_area_exited
signal back_area_exited
signal blade_area_entered

@onready var visual = $Visual
@onready var shaving = $Visual/Shaving

var _is_pushing := false
var _is_rotating := false
var _is_stroking := false

var _relative_speed := 0.0
var _rotation_input = Vector2.ZERO

var rotation_speed := 7.5
const max_speed:= 1000.0

func _process(delta: float) -> void:
	if _is_rotating:
		if _rotation_input.length_squared() > 0:
			rotation = lerp_angle(rotation, _rotation_input.angle(), rotation_speed * delta)
		
	if _is_pushing:
		var final_speed = _relative_speed * max_speed

		position -= transform.x * delta * final_speed # -= because I forced visual rotation to -90°
		if _is_stroking:
			shaving.update(delta, _relative_speed)		

func push(value: bool) -> void:
	_is_pushing = value

func _on_nose_collision_box_area_exited(_area: Area2D) -> void:
	nose_area_exited.emit()

func _on_blade_collision_box_area_exited(_area: Area2D) -> void:
	shaving.end()
	_is_stroking = false

func _on_blade_collision_box_area_entered(_area: Area2D) -> void:
	if _is_stroking == false:
		shaving.start()
		_is_stroking = true
		blade_area_entered.emit()

func _on_back_collision_box_area_exited(_area: Area2D) -> void:
	back_area_exited.emit()

func update_relative_speed(total_pressure: float, pressures_balance_factor: float) -> void:
	var base_speed = total_pressure* 0.5
	var friction = pow(base_speed, 2.0)
	var friction_factor = lerp(1.0, 0.15, friction) # never 0
	
	var speed = base_speed * friction_factor * pressures_balance_factor
	_relative_speed =  clamp(speed, 0.0, 1.0)
	
func set_rotation_input(input: Vector2) -> void:
	if input == null:
		input = Vector2.ZERO
	input *= -1
	_is_rotating = _rotation_input != input
	_rotation_input = input if input.length_squared() > 0.01 else Vector2.ZERO

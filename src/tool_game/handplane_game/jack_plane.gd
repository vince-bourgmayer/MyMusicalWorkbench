# -----------------------------------------------------------------------------
# jack_plane.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D
class_name JackPlane

signal nose_area_exited
signal back_area_exited

@onready var visual = $Visual
@onready var shaving = $Visual/Shaving

var hands_pressure := Vector2.ZERO
var is_pushing := false
var is_rotating := false
var is_stroking := false

var rotation_speed := 7.5

const max_speed:= 1000.0


func _process(delta: float) -> void:
	if is_rotating:
		var input := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		)

		if input.length_squared() > 0:
			rotation = lerp_angle(rotation, input.angle(), rotation_speed * delta)
		
	if is_pushing:
		var relative_speed = _get_relative_speed()
		var final_speed = relative_speed * max_speed

		position -= transform.x * delta * final_speed # -= because I forced visual rotation to -90°
		if is_stroking:
			shaving.update(delta, relative_speed)

func set_hands_pressure(value: Vector2):
	hands_pressure = value
	if hands_pressure.x > 0.005 && hands_pressure.y > 0.005:
		push(true)
	else:
		push (false)
		

func push(b: bool) -> void:
	is_pushing = b
	
func set_rotating(b:bool) -> void:
	is_rotating = b

func _on_nose_collision_box_area_exited(_area: Area2D) -> void:
	nose_area_exited.emit()

func _on_blade_collision_box_area_exited(_area: Area2D) -> void:
	shaving.end()
	is_stroking = false


func _on_blade_collision_box_area_entered(_area: Area2D) -> void:
	if is_stroking == false:
		shaving.start()
		is_stroking = true

func _on_back_collision_box_area_exited(_area: Area2D) -> void:
	back_area_exited.emit()
	
func _get_total_pressure() -> float:
	return hands_pressure.x + hands_pressure.y

func _get_pressure_balance() -> float:
	# 0 => both hand put have same pressure ; 
	# 1 => only one hand take the pressure and it is at full level
	return abs(hands_pressure.x - hands_pressure.y)
	

# Computes how fast the plane can move based on:
# - how much both hands push
# - how far the pressure balance is from what feels right
# Speed is reduced when balance is bad, while damage can still increase.
func _get_pressure_balance_factor() -> float:
	var balance_raw = _get_pressure_balance() 
	
	var ideal_balance = 0.5
	
	# 0: perfect match, higher value, higher distance
	var distance_to_idal = abs(balance_raw-ideal_balance)
	
	# From which distance it starts to be bad
	# Higher value, easier process
	var tolerance = 0.45

	# How many times, It was a bad value
	var error_ratio = distance_to_idal / tolerance
	
	# Worst value => worst punition
	var penalty = error_ratio * error_ratio

	# whatever the value of the error, when it's wrong, it's wrong.
	# so we clamp
	var balance_score = clamp(1.0 - penalty, 0.0, 1.0) 

	#Avoid 0 which would block plane
	var balance_factor = lerp(0.2, 1.0, balance_score)
	
	return balance_factor

func _get_relative_speed() -> float:
	var base_speed = _get_total_pressure() * 0.5
	var friction = pow(base_speed, 2.0)
	var friction_factor = lerp(1.0, 0.15, friction) # never 0
	var balance_factor = _get_pressure_balance_factor()
	
	var speed01 = base_speed * friction_factor * balance_factor
	return clamp(speed01, 0.0, 1.0)

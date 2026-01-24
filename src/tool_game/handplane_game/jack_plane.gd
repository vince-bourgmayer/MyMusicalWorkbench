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

var front_pressure:= 0.0
var back_pressure:= 0.0
var is_pushing := false
var is_rotating := false
var is_stroking := false

var rotation_speed := 7.5

const start_speed := 100.0
const start_speed_increase_step := 10.0
const max_speed:= 1000.0

var speed := start_speed
var speed_increase_step := start_speed_increase_step

func _process(delta: float) -> void:
	if is_rotating:
		var input := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
		)

		if input.length_squared() > 0:
			rotation = lerp_angle(rotation, input.angle(), rotation_speed * delta)
		
	if is_pushing:
		if speed < max_speed:
			speed += speed_increase_step
			
		position -= transform.x * delta * speed # -= because I forced visual rotation to -90°
		if is_stroking:
			shaving.update(delta, front_pressure)

func press_front(value:float) -> void:
	front_pressure = value
	
func press_back(value:float) -> void:
	back_pressure = value

func push(b: bool) -> void:
	is_pushing = b
	if !b:
		speed = start_speed
	
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

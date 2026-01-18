# -----------------------------------------------------------------------------
# jack_plane.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D
class_name JackPlane

@onready var visual = $Visual

var front_pressure:= 0.0
var back_pressure:= 0.0
var is_pushing := false
var is_rotating := false

var rotation_speed := 7.5

const start_speed := 100.0
const start_speed_increase_step := 10.0
const max_speed:= 1000.0

var speed := start_speed
var speed_increase_step := start_speed_increase_step

func _ready() -> void:
	pass 

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
			
		position += transform.x * delta * speed

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


#I think it will need a collision box to detect when it is in the wood area
#And then I'll get something like:
	#if in collision with wood and pressure is applied
		#then planing.emit()
		#& sound.emit

#Or I can have two collision box, one at nose of the plane, which would tell when front pressure is required
#and then another one for the end of the plane to tell when back pressure is required

# -----------------------------------------------------------------------------
# template_selector.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D
class_name TemplateSelector

@onready var previousShapeSprite = $PreviousShape
@onready var currentShapeSprite = $CurrentShape
@onready var nextShapeSprite = $NextShape

const center_position = Vector2(480,360)
var shapes := []
var currentShapeIndex: int

func _ready() -> void:
	shapes = _load_shapes()
	currentShapeIndex = 0

func handle_input(event: InputEvent) -> void:
	if event.is_action_released("left_stick_to_left"):
		_previous_shape()
	elif event.is_action_released("left_stick_to_right"):
		_next_shape()
	else:
		pass
	pass

func _load_shapes() -> Array:
	var result = [1,2,3]
	return result

func _previous_shape() -> void:
	# add a tween animation that move current shape to left and fade
	# on the tween end, reset the position of currentShape to center
	# and change the shape with the previous one
	# I want a kind of carroussel behaviour

	
	var tw := create_tween()
	tw.tween_property(currentShapeSprite, "position", nextShapeSprite.position, 0.5)
	tw.tween_property(currentShapeSprite, "modulate:a", 0.0, 0.5)
	await tw.finished
	#_change_shape()
	
	currentShapeSprite.position = center_position
	currentShapeSprite.self_modulate.a = 1.0
	
func _next_shape() -> void:
	# add a tween animation that move current shape to right and fade
	# on the tween end, reset the position of currentShape to center
	# and change the shape with the next one
	# I want a kind of carroussel behaviour
	# Also need to change previous and next shape
	_change_shape()

func _change_shape() -> void:
	previousShapeSprite.texture = shapes.get(_compute_previous_index()) # need a modulo to loop
	currentShapeSprite.texture = shapes.get(currentShapeIndex)
	nextShapeSprite.texture = shapes.get(_compute_next_index()) # need a modulo to loop

func _compute_previous_index() -> int:
	var shapesSize = shapes.size()
	return (currentShapeIndex -1 + shapesSize) % shapesSize
	
func _compute_next_index() -> int:
	var shapesSize = shapes.size()
	return (currentShapeIndex +1) % shapesSize

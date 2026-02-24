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
const previous_position = Vector2(0, 360)
const next_position = Vector2(960, 360)
var shapes := []
var currentShapeIndex: int

func _ready() -> void:
	shapes = _load_shapes()
	currentShapeIndex = 0
	previousShapeSprite.modulate.a = 0.5

func handle_input(event: InputEvent) -> void:
	if event.is_action_released("left_stick_to_left") && not event.is_action_pressed("left_stick_to_right"):
		_previous_shape()
	elif event.is_action_released("left_stick_to_right"):
		_next_shape()
	else:
		pass
		
func get_selected_shape() -> Node2D:
	return currentShapeSprite

func _load_shapes() -> Array:
	var result = [1,2,3]
	return result

func _previous_shape() -> void:
	# add a tween animation that move current shape to left and fade
	# on the tween end, reset the position of currentShape to center
	# and change the shape with the previous one
	# I want a kind of carroussel behaviour

	
	var tw := create_tween()
	tw.parallel().tween_property(currentShapeSprite, "position", next_position, 0.5)
	tw.parallel().tween_property(currentShapeSprite, "modulate:a", 0.5, 0.5)
	tw.parallel().tween_property(previousShapeSprite, "position", center_position, 0.5)
	tw.parallel().tween_property(previousShapeSprite, "modulate:a", 1.0, 0.3)
	tw.parallel().tween_property(nextShapeSprite, "modulate:a", 0.0, 0.1)
	await tw.finished
	
	#_change_shape()
	var prev_texture = previousShapeSprite.texture
	var current_texture = currentShapeSprite.texture
	var next_texture = nextShapeSprite.texture
	
	currentShapeSprite.texture = prev_texture
	previousShapeSprite.texture = next_texture
	nextShapeSprite.texture = current_texture
	
	# Reset position & modulate.a
	currentShapeSprite.position = center_position
	currentShapeSprite.modulate.a = 1.0
	nextShapeSprite.modulate.a = 0.5
	previousShapeSprite.position = previous_position
	previousShapeSprite.modulate.a = 0.5
	
func _next_shape() -> void:
	# add a tween animation that move current shape to right and fade
	# on the tween end, reset the position of currentShape to center
	# and change the shape with the next one
	# I want a kind of carroussel behaviour
	# Also need to change previous and next shape

		
	var tw := create_tween()
	tw.parallel().tween_property(currentShapeSprite, "position", previous_position, 0.5)
	tw.parallel().tween_property(currentShapeSprite, "modulate:a", 0.5, 0.5)
	tw.parallel().tween_property(nextShapeSprite, "position", center_position, 0.5)
	tw.parallel().tween_property(nextShapeSprite, "modulate:a", 1.0, 0.3)
	tw.parallel().tween_property(previousShapeSprite, "modulate:a", 0.0, 0.1)
	await tw.finished
	
	#_change_shape()
	
	var prev_texture = previousShapeSprite.texture
	var current_texture = currentShapeSprite.texture
	var next_texture = nextShapeSprite.texture
	
	#_change_shape()
	currentShapeSprite.texture = next_texture
	previousShapeSprite.texture = current_texture
	nextShapeSprite.texture = prev_texture
	
	# Reset position & modulate.a
	currentShapeSprite.position = center_position
	currentShapeSprite.modulate.a = 1.0
	previousShapeSprite.modulate.a = 0.5
	nextShapeSprite.position = next_position
	nextShapeSprite.modulate.a = 0.5

#func _change_shape() -> void:
	#previousShapeSprite.texture = shapes.get(_compute_previous_index()) # need a modulo to loop
	#currentShapeSprite.texture = shapes.get(currentShapeIndex)
	#nextShapeSprite.texture = shapes.get(_compute_next_index()) # need a modulo to loop

func _compute_previous_index() -> int:
	var shapesSize = shapes.size()
	return (currentShapeIndex -1 + shapesSize) % shapesSize
	
func _compute_next_index() -> int:
	var shapesSize = shapes.size()
	return (currentShapeIndex +1) % shapesSize

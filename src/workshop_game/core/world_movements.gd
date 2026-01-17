# -----------------------------------------------------------------------------
# world_movements.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node

@export var speed := 100

var velocity := Vector2.ZERO
var player: Player

func set_character(p_character: Player):
	player = p_character
	
func move_character():
	velocity = Vector2.ZERO
	var isWalking = true
	if Input.is_action_pressed("move_right"):
		velocity = Vector2.RIGHT
		player.set_direction(Vector2.RIGHT)
	elif Input.is_action_pressed("move_left"):
		velocity = Vector2.LEFT
		player.set_direction(Vector2.LEFT)
	elif Input.is_action_pressed("move_down"):
		velocity = Vector2.DOWN
		player.set_direction(Vector2.DOWN)
	elif Input.is_action_pressed("move_up"):
		velocity = Vector2.UP
		player.set_direction(Vector2.UP)
	else:
		isWalking = false
		
	player.play_animation(isWalking)

	# --- Déplacement ---
	velocity = velocity.normalized() * speed
	player.velocity = velocity
	player.move_and_slide()

# should be moved elsewhere. not a part of this class task
func unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("try_place_tool"):
		player.get_parent().toggle_placeholder()

	if event.is_action_released("place_tool"):
		player.get_parent().try_to_place_tool()
		
	if event.is_action_released("interact_with_tool"):
		if player.raycast.is_colliding():
			print("We got a collision sir")
			player.get_parent().interact_with_tool()

# -----------------------------------------------------------------------------
# world_movements.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node

@export var speed := 100

var velocity := Vector2.ZERO
var isWalking:= false

func move_character(character: CharacterBody2D):
	velocity = Vector2.ZERO
	isWalking = true
	if Input.is_action_pressed("move_right"):
		velocity = Vector2.RIGHT
		character.set_direction(Vector2.RIGHT)
	elif Input.is_action_pressed("move_left"):
		velocity = Vector2.LEFT
		character.set_direction(Vector2.LEFT)
	elif Input.is_action_pressed("move_down"):
		velocity = Vector2.DOWN
		character.set_direction(Vector2.DOWN)
	elif Input.is_action_pressed("move_up"):
		velocity = Vector2.UP
		character.set_direction(Vector2.UP)
	else:
		isWalking = false
		
	character.play_animation(isWalking)

	# --- Déplacement ---
	velocity = velocity.normalized() * speed
	character.velocity = velocity
	character.move_and_slide()

# -----------------------------------------------------------------------------
# world_movements.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node

@export var speed := 100

var velocity := Vector2.ZERO
var direction := "down"
var current_anim := ""
var is_idle := true

func move(character: CharacterBody2D, animated_sprite: AnimatedSprite2D):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		handle_walk(animated_sprite, "walk_right")
		direction = "right"
		is_idle = false
	elif Input.is_action_pressed("move_left"):
		velocity.x -= 1
		handle_walk(animated_sprite, "walk_right", true)
		direction = "left"
		is_idle = false
	elif Input.is_action_pressed("move_down"):
		velocity.y += 1
		handle_walk(animated_sprite, "walk_down")
		direction = "down"
		is_idle = false
	elif Input.is_action_pressed("move_up"):
		velocity.y -= 1
		handle_walk(animated_sprite, "walk_up")
		direction = "up"
		is_idle = false
	else:
		is_idle = true

	if is_idle:
		play_idle(animated_sprite)

	# --- Déplacement ---
	velocity = velocity.normalized() * speed
	character.velocity = velocity
	character.move_and_slide()

func handle_walk(animated_sprite: AnimatedSprite2D, anim_name: String, flip: bool = false):
	if current_anim != anim_name:
		animated_sprite.flip_h = flip
		animated_sprite.play(anim_name)
		current_anim = anim_name

func play_idle(animated_sprite: AnimatedSprite2D):
	var idle_anim := "idle_"+direction 
	if (direction == "left"):
		idle_anim = "idle_right"

	if current_anim != idle_anim:
		animated_sprite.play(idle_anim)
		current_anim = idle_anim

func get_direction():
	return direction

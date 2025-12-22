# -----------------------------------------------------------------------------
# player.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends CharacterBody2D

const idle_animation = "idle_"
const walk_animation = "walk_"

var direction := Vector2.DOWN
var animation := ""
var movement_system

func _ready() -> void:
	movement_system = preload("res://src/scripts/systems/world_movements.gd").new()
	add_child(movement_system)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("try_place_tool"):
		get_parent().toggle_placeholder()
		
	if event.is_action_released("place_tool"):
		get_parent().try_to_place_tool()
		
	if event.is_action_released("interact_with_tool"):
		if $Raycast.is_colliding():
			print("We got a collision sir")

func set_direction(p_direction: Vector2):
	direction = p_direction

func change_raycast_direction():
	$Raycast.target_position = direction.normalized() * 16
	
func _process(_delta: float) -> void:
	movement_system.move_character(self)
	change_raycast_direction()
	
func get_direction()->Vector2:
	return direction
	
func play_animation(isWalking: bool):
	var anim_name = getAnimationName(isWalking)
	if animation != anim_name:
		animation = anim_name
		$Sprite.flip_h = (direction == Vector2.LEFT)
		$Sprite.play(anim_name)
		
func getAnimationName(isWalking: bool) ->String: 
	var string_direction = ""
	# need to extract this if elif else block into dedicated method
	if direction == Vector2.DOWN:
		string_direction = "down"
	elif direction == Vector2.UP:
		string_direction = "up"
	else:
		string_direction ="right"
		
	if isWalking:
		return walk_animation+string_direction
	else:
		return idle_animation+string_direction

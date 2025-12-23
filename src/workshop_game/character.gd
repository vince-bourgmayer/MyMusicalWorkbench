# -----------------------------------------------------------------------------
# character.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends CharacterBody2D
class_name Player

const idle_animation = "idle_"
const walk_animation = "walk_"

var direction := Vector2.DOWN
var animation := ""
@onready var movement_system = preload("res://src/workshop_game/core/world_movements.gd").new()
@onready var raycast = $Raycast

func _ready() -> void:

	movement_system.set_character(self)
	add_child(movement_system)

## should be moved elsewhere. not a part of this class task
func _unhandled_input(event: InputEvent) -> void:
	movement_system.unhandled_input(event)

func set_direction(p_direction: Vector2):
	direction = p_direction

func change_raycast_direction():
	$Raycast.target_position = direction.normalized() * 16
	
func _process(_delta: float) -> void:
	movement_system.move_character()
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

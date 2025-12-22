# -----------------------------------------------------------------------------
# tool_placement_manager.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D

class_name PlacementManager

var placeholder: Node2D
var player: Node2D

var placeholder_offset = Vector2(0,66)

func init(playerScene: Node2D, placeHolderScene: Node2D):
	placeholder = placeHolderScene
	player = playerScene

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if placeholder.visible:
		placeholder.global_position = player.global_position + compute_offset()
		
func checkPlace() -> bool:
	return placeholder.is_position_valid

func compute_offset():
	var direction = player.get_direction()
	if direction == "up":
		placeholder_offset.x = 0
		placeholder_offset.y = -66
	elif direction == "down":
		placeholder_offset.x = 0
		placeholder_offset.y = 66 
	return placeholder_offset

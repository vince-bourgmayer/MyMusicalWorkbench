# -----------------------------------------------------------------------------
# player.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends CharacterBody2D

var movement_system

func _ready() -> void:
	movement_system = preload("res://src/scripts/systems/world_movements.gd").new()
	add_child(movement_system)

func _unhandled_input(_event: InputEvent) -> void:
	if _event.is_action_released("try_place_tool"):
		get_parent().toggle_placeholder()
		
	if Input.is_action_just_released("place_tool"):
		get_parent().try_to_place_tool()

func _process(_delta: float) -> void:
	movement_system.move(self, $AnimatedSprite2D)
	
func get_direction()->String:
	return movement_system.get_direction()

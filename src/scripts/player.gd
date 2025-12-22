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
	pass # Replace with function body.


func _process(_delta: float) -> void:
	movement_system.move(self, $AnimatedSprite2D)
	
	if Input.is_action_just_released("place_tool"):
		get_parent().toggle_placeholder()
		

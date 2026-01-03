# -----------------------------------------------------------------------------
# tool_game.gd
# Copyright (c) 2025-2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D
class_name ToolGame

signal popup_requested(text1: String, text2:String)

func _ready() -> void:
	pass 


func _process(_delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	else:
		handle_specific_input(event)
		
		
func handle_specific_input(event: InputEvent) -> void:
	pass # Overide in child

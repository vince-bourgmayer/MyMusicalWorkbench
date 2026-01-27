# -----------------------------------------------------------------------------
# tool_game.gd
# Copyright (c) 2025-2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D
class_name ToolGame

signal popup_requested(text1: String, text2:String)

func _unhandled_input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	else:
		handle_specific_input(event)

func handle_specific_input(_event: InputEvent) -> void:
	pass # Overide in child

func cancel_game(txt1: String, text2: String) -> void: # user leaves the handsaw game and get back to world
	popup_requested.emit(txt1, text2, Globals.game_mode.WORKSHOP)

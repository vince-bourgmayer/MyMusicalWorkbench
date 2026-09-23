# -----------------------------------------------------------------------------
# tool_game.gd
# Copyright (c) 2025-2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node2D
class_name ToolGame

signal popup_requested(text1: String, text2:String)

var _current_state : int # will match enum in child class

func _change_state(new_state: int) -> void:
	_exit_state(_current_state)
	_current_state = new_state
	_enter_state(new_state)
	
func _exit_state(state: int) -> void:
	pass # Overide in child
	
func _enter_state(new_state: int) -> void:
	pass # Overide in child
	
func _get_final_state() -> int:
	return 0 # Overide in child.  Must return the highest game_state's value
	
func _on_accept_pressed() -> void:
	var next_step = _current_state + 1
	if next_step <= _get_final_state():
		_change_state(next_step)

func _on_cancel_pressed() -> void:
	var previous_step = _current_state -1
	if previous_step >= 0:
		_change_state(previous_step)
	else:
		_on_game_cancelled()

func _on_game_cancelled() -> void:
	pass # Overide in child

func _unhandled_input(event: InputEvent) -> void:
	if not is_visible_in_tree():
		return
	else:
		_handle_specific_input(event)

func _handle_specific_input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		_on_accept_pressed()
	elif event.is_action_released("ui_cancel"):
		_on_cancel_pressed()

func cancel_game(txt1: String, text2: String) -> void: # user leaves the handsaw game and get back to world
	popup_requested.emit(txt1, text2, Globals.game_mode.WORKSHOP)

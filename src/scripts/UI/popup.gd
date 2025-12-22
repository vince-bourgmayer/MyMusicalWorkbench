# -----------------------------------------------------------------------------
# popup.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Control

signal _popup_closed

func _ready() -> void:
	pass 

func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept") && visible:
		hide()
		get_viewport().set_input_as_handled()
		_popup_closed.emit()

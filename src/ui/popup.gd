# -----------------------------------------------------------------------------
# popup.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Control

signal _popup_closed(code: int)

var popup_code = -1

func _ready() -> void:
	pass 

func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept") && visible:
		hide()
		get_viewport().set_input_as_handled()
		_popup_closed.emit(popup_code)

func setCode(code: int):
	popup_code = code

func updateText(text1:String, text2: String):
	$Panel/MarginContainer/VBoxContainer/Label.text = text1
	$Panel/MarginContainer/VBoxContainer/Label2.text = text2
	$Panel.reset_size()

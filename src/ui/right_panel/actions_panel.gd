# -----------------------------------------------------------------------------
# actions_panel.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Control

@onready var actionHintsContainer = $VBoxContainer/ActionHintsContainer

var action_hint_view_scene = preload("res://src/ui/right_panel/core/ActionHintView.tscn")

func _ready() -> void:
	_load_inputs()

func _load_inputs() -> void:
	add_action_hint(0, 3, "Accept")
	
	add_action_hint(3, 3, "cancel")
	
	add_action_hint(1, 3, "Place workbench")

	add_action_hint(2, 3, "Use workbench")

	add_action_hint(0, 5, "Move")

	add_action_hint(2, 4, "Switch tool")
	
func add_action_hint(x: int, y: int, text: String) -> void:
	var action_hint_view = action_hint_view_scene.instantiate()
	actionHintsContainer.add_child(action_hint_view)
	action_hint_view.set_input(x, y, text)

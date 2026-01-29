# -----------------------------------------------------------------------------
# actions_panel.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Control

@onready var actionHintsContainer = $VBoxContainer/ActionHintsContainer

var action_hint_view_scene = preload("res://src/ui/right_panel/core/ActionHintView.tscn")
var action_hints_by_mode: Dictionary = {} # String ->  Array[ActionHintData]

func _ready() -> void:
	_load_inputs()
	Signals.switch_game_mode.connect(display_hints_for_mode)

func _load_inputs() -> void:
	action_hints_by_mode = ActionHintsLoader.load_from_file("res://data/right_panel_action_hints.json")

func display_hints_for_mode(mode: int) -> void:
	print("display hint for mode: ", mode)
	if action_hints_by_mode == null or action_hints_by_mode.is_empty():
		push_error("No action_hints loaded: can't display in right panel")
	
	clear_action_hint_container()
	
	match mode:
		Globals.game_mode.WORKSHOP:
			for actionHint in action_hints_by_mode.get("workshop"):
				add_action_hint(actionHint)
		Globals.game_mode.HANDSAW:
			for actionHint in action_hints_by_mode.get("handsaw"):
				add_action_hint(actionHint)
		Globals.game_mode.HANDPLANE:
			for actionHint in action_hints_by_mode.get("handplane"):
				add_action_hint(actionHint)
		_: push_error("Invalid game mode: no action hints to display in right panel")

func add_action_hint(actionHint: ActionHint) -> void:
	var action_hint_view = action_hint_view_scene.instantiate()
	actionHintsContainer.add_child(action_hint_view)
	action_hint_view.set_input(actionHint.atlas_x, actionHint.atlas_y, actionHint.text)

func clear_action_hint_container():
	for child in actionHintsContainer.get_children():
		child.queue_free()

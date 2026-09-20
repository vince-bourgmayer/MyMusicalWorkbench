# -----------------------------------------------------------------------------
# tool_game_slot.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends Node
class_name ToolGameSlot

signal popup_requested(text1: String, text2: String, code: Globals.game_mode)

var current_game: Node = null

func open_game(code: Globals.game_mode) -> void:
	var scene_to_load: String = "res://src/tool_game/handsaw_game/HandsawGame.tscn"

	if code == Globals.game_mode.HANDSAW:
		scene_to_load = "res://src/tool_game/handsaw_game/HandsawGame.tscn"
	elif code == Globals.game_mode.HANDPLANE:
		scene_to_load = "res://src/tool_game/handplane_game/Handplane_game.tscn"
	elif code == Globals.game_mode.TEMPLATE:
		scene_to_load = "res://src/tool_game/template_game/TemplateGame.tscn"
	else:
		push_error("Unknown tool game code: %s" % code)
		return

	_clear_current_game()

	var scene = load(scene_to_load)
	current_game = scene.instantiate()
	add_child(current_game)
	
	if current_game.has_signal("popup_requested"):
		current_game.connect("popup_requested", Callable(self, "_forward_popup"))

func _clear_current_game() -> void:
	if current_game == null:
		return

	if current_game.has_signal("popup_requested"):
		var callable := Callable(self, "_forward_popup")
		if current_game.is_connected("popup_requested", callable):
			current_game.disconnect("popup_requested", callable)

	current_game.queue_free()
	current_game = null

func _forward_popup(text1: String, text2: String, code: Globals.game_mode) -> void:
	popup_requested.emit(text1, text2, code)

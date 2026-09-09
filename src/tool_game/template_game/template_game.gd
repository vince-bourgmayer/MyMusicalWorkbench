# -----------------------------------------------------------------------------
# template_game.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends ToolGame
class_name TemplateGame

enum gameState { SELECT_JIG, PLACE_JIG, DRAW_SHAPE }
var currentState : gameState
var directionalInputReader = DirectionalInputReader.new()

@onready var templateSelector = $TemplateSelector
var pencil : Pencil
var pencil_scene: PackedScene = preload("res://src/tool_game/template_game/Pencil.tscn")
var jig : Jig

# The game will let the player:
# 1. Choose a template/jig
# 2. Move the template over the wood
# 3. use a pen to trace shape on the wood 
	
func _ready() -> void:
	currentState = gameState.SELECT_JIG

func handle_specific_input(_event: InputEvent) -> void:
	match currentState:
		gameState.SELECT_JIG:
			handle_select_jig_input(_event)
		gameState.PLACE_JIG:
			handle_place_jig_input(_event)
		gameState.DRAW_SHAPE:
			handle_draw_shape_input(_event)
		_:
			print("TemplateGame.handle_specific_input: Invalid gameState")

func handle_select_jig_input(event: InputEvent) -> void:
	# B button: leave template game
	# A button: validate jig selected
	# left stick left/right: change template
	# Later: left stick up/down: change template type (body, neck, head, ...)
	if event.is_action_released("ui_accept"):
		_set_place_jig_state()
	elif event.is_action_released("ui_cancel"):
		cancel_game("Do you want to stop templating ?", "Press A to validate")
	else:
		templateSelector.handle_input(event)
	
func handle_place_jig_input(event: InputEvent) -> void:
	#B button: back to previous gamemode
	#A validate go to next step
	if event.is_action_released("ui_accept"):
		_set_draw_shape_state()
		print("check")
	elif event.is_action_released("ui_cancel"):
		self.remove_child(jig)
		_set_select_jig_state()

func handle_draw_shape_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		self.remove_child(pencil)
		_set_place_jig_state()

func _set_select_jig_state():
	currentState = gameState.SELECT_JIG
	templateSelector.visible = true

func _set_place_jig_state():
	templateSelector.visible = false
	self.add_child(directionalInputReader)
	
	if (!self.get_children().has(jig)):
		jig = templateSelector.get_selected_shape().duplicate()
		jig.set_movement_bounds(self.get_viewport_rect()) 

	directionalInputReader.left_stick_direction_changed.connect(jig.set_move_direction)
	directionalInputReader.right_stick_direction_changed.connect(jig.set_rotation_direction)

	self.add_child(jig)
	currentState = gameState.PLACE_JIG

func _set_draw_shape_state():
	pencil = pencil_scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	directionalInputReader.right_stick_direction_changed.disconnect(jig.set_rotation_direction)

	pencil.set_movement_bounds(self.get_viewport_rect())
	directionalInputReader.right_stick_direction_changed.connect(pencil.set_move_direction)

	self.add_child(pencil)

	currentState = gameState.DRAW_SHAPE

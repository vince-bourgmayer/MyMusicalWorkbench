# -----------------------------------------------------------------------------
# template_game.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends ToolGame
class_name TemplateGame

enum gameState { SELECT_JIG, PLACE_JIG, DRAW_SHAPE }
const JIG_PATHS: Array[String] = [
	"res://assets/shapes/black_boden.png",
	"res://assets/shapes/black_machine.png",
	"res://assets/shapes/strandberg_boden.png",
]

var _currentState : gameState
var directionalInputReader = DirectionalInputReader.new()
var triggersInputReader = TriggersInputReader.new()

var woodPiece : WoodPiece

@onready var woodRenderer = $WoodRenderer
@onready var carousel = $Carousel

var pencil : Pencil
var pencil_scene: PackedScene = preload("res://src/tool_game/template_game/Pencil.tscn")
var jig_scene : PackedScene = preload("res://src/tool_game/template_game/Jig.tscn")
var jig : Jig

# The game will let the player:
# 1. Choose a template/jig
# 2. Move the template over the wood
# 3. use a pen to trace shape on the wood 
	
func _ready() -> void:
	var woodTexture = woodRenderer.texture
	var woodPieceSize = Vector2(woodTexture.get_width(), woodTexture.get_height())
	woodPiece = WoodPiece.new("Ash", woodPieceSize)
	pencil = pencil_scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	pencil.set_movement_bounds(self.get_viewport_rect())
	jig = jig_scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	
	_set_select_jig_state()
	directionalInputReader.left_stick_direction_changed.connect(_on_left_stick_changed)
	directionalInputReader.right_stick_direction_changed.connect(_on_right_stick_changed)
	pencil.drawing.connect(func(from, to):
		woodPiece.apply(PencilOperation.new(woodRenderer.to_local(from), woodRenderer.to_local(to), 5))
	)

	woodRenderer.bind(woodPiece)

	self.add_child(directionalInputReader)
	self.add_child(triggersInputReader)
	
	carousel.setup(JIG_PATHS)


func _on_left_stick_changed(direction: Vector2) -> void:
	match _currentState:
		gameState.SELECT_JIG:
			carousel.on_input_received(direction)
		gameState.PLACE_JIG:
			jig.set_move_direction(direction)
		gameState.DRAW_SHAPE:
			pass  # le pencil écoute right_stick, pas left_stick ici

func _on_right_stick_changed(direction: Vector2) -> void:
	match _currentState:
		gameState.SELECT_JIG:
			pass
		gameState.PLACE_JIG:
			jig.set_rotation_direction(direction)
		gameState.DRAW_SHAPE:
			pencil.set_move_direction(direction)
			
func handle_specific_input(_event: InputEvent) -> void:
	match _currentState:
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
	if event.is_action_released("ui_accept"):
		_set_place_jig_state()
	elif event.is_action_released("ui_cancel"):
		cancel_game("Do you want to stop templating ?", "Press A to validate")
	
func handle_place_jig_input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		_set_draw_shape_state()
	elif event.is_action_released("ui_cancel"):
		self.remove_child(jig)
		_set_select_jig_state()

func handle_draw_shape_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		self.remove_child(pencil)
		_set_place_jig_state()
	#elif event.is_action_pressed("trigger_right"):
	#	print("Pencil is marking")
	#	pass

func _set_select_jig_state():
	_currentState = gameState.SELECT_JIG
	carousel.visible = true

func _set_place_jig_state():
	carousel.visible = false

	if (!self.get_children().has(jig)):
		self.add_child(jig)

	jig.set_shape(carousel.get_selected_path())
	_currentState = gameState.PLACE_JIG

func _set_draw_shape_state():
	self.add_child(pencil)
	triggersInputReader.right_trigger_pressure_changed.connect(pencil.set_drawing)
	

	
	_currentState = gameState.DRAW_SHAPE

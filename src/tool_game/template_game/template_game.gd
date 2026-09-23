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

var directionalInputReader = DirectionalInputReader.new()
var triggersInputReader = TriggersInputReader.new()

var woodPiece : WoodPiece

@onready var woodRenderer = $WoodRenderer
@onready var _carousel : Carousel = $Carousel

var _pencil : Pencil
var _pencil_scene: PackedScene = preload("res://src/tool_game/template_game/Pencil.tscn")
var _jig_scene : PackedScene = preload("res://src/tool_game/template_game/Jig.tscn")
var _jig : Jig

func _ready() -> void:
	_current_state = 0
	_carousel.setup(JIG_PATHS)
	
	var woodTexture = woodRenderer.texture
	var woodPieceSize = Vector2(woodTexture.get_width(), woodTexture.get_height())
	woodPiece = WoodPiece.new("Ash", woodPieceSize)
	
	_pencil = _pencil_scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	_pencil.set_movement_bounds(self.get_viewport_rect())
	_pencil.drawing.connect(func(from, to):
		woodPiece.apply(PencilOperation.new(woodRenderer.to_local(from), woodRenderer.to_local(to), 1))
	)

	_jig = _jig_scene.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)

	_change_state(gameState.SELECT_JIG)
	
	directionalInputReader.left_stick_direction_changed.connect(_on_left_stick_changed)
	directionalInputReader.right_stick_direction_changed.connect(_on_right_stick_changed)
	self.add_child(directionalInputReader)
	self.add_child(triggersInputReader)

	woodRenderer.bind(woodPiece)

func _exit_tree() -> void:
	_jig.queue_free()
	_pencil.queue_free()
	_carousel.queue_free()
	directionalInputReader.left_stick_direction_changed.disconnect(_on_left_stick_changed)
	directionalInputReader.right_stick_direction_changed.disconnect(_on_right_stick_changed)

func _on_left_stick_changed(direction: Vector2) -> void:
	match _current_state:
		gameState.SELECT_JIG:
			_carousel.on_input_received(direction)
		gameState.PLACE_JIG:
			_jig.set_move_direction(direction)
		gameState.DRAW_SHAPE:
			_jig.set_move_direction(direction)

func _on_right_stick_changed(direction: Vector2) -> void:
	match _current_state:
		gameState.SELECT_JIG:
			pass
		gameState.PLACE_JIG:
			_jig.set_rotation_direction(direction)
		gameState.DRAW_SHAPE:
			_pencil.set_move_direction(direction)

func _enter_state(state: int) -> void:
	match state:
		gameState.SELECT_JIG:
			self.add_child(_carousel)
		gameState.PLACE_JIG:
			if (not self.get_children().has(_jig)):
				_jig.position = _carousel.currentSlot
				self.add_child(_jig)
			_jig.set_shape(_carousel.get_selected_path())
		gameState.DRAW_SHAPE:
			if (not self.get_children().has(_jig)):
				self.add_child(_jig)
			triggersInputReader.right_trigger_pressure_changed.connect(_pencil.set_drawing)
			self.add_child(_pencil)

func _exit_state(state: int) -> void:
	match state:
		gameState.SELECT_JIG:
			if (self.get_children().has(_carousel)):
				self.remove_child(_carousel)
		gameState.PLACE_JIG:
			if (self.get_children().has(_jig)):
				self.remove_child(_jig)
		gameState.DRAW_SHAPE:
			if (self.get_children().has(_pencil)):
				self.remove_child(_pencil)
			triggersInputReader.right_trigger_pressure_changed.disconnect(_pencil.set_drawing)


func _on_game_cancelled() -> void:
	cancel_game("Do you want to stop templating ?", "Press A to validate")

func _get_final_state() -> int:
	return gameState.DRAW_SHAPE

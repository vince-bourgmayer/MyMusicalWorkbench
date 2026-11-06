# -----------------------------------------------------------------------------
# handsaw_game2.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends ToolGame
class_name HandsawGameV2

enum gameState { START_POINT, END_POINT, SAW_ACTION }

@onready var _handsaw : Handsaw = $Handsaw
@onready var _cutLine := $VisualMarkers/CutLines
@onready var _woodRenderer := $WoodRenderer

var _directional_input_reader = DirectionalInputReader.new()
var _woodPiece : WoodPiece #need to be passed to parent when exiting
var _saw_operation : SawOperation

func _ready() -> void:
	_directional_input_reader.right_stick_direction_changed.connect(_on_right_stick_direction_changed)
	_directional_input_reader.left_stick_direction_changed.connect(_on_left_stick_direction_changed)
	self.add_child(_directional_input_reader)
	
	#TODO how to get the wood piece ? I'm not happy with current implementation
	_woodPiece = WoodPiece.new("Alder", _woodRenderer.get_wood_size())
	_woodRenderer.bind(_woodPiece)
	
	_cutLine.on_wood_geometry_changed(_woodPiece.get_geometry_polygon())
	_woodPiece.geometry_changed.connect(_cutLine.on_wood_geometry_changed)
	
	_handsaw.in_action.connect(_on_saw_action)
	_start_state(gameState.START_POINT)

func _exit_tree() -> void:
	_directional_input_reader.right_stick_direction_changed.disconnect(_on_right_stick_direction_changed)
	_directional_input_reader.left_stick_direction_changed.disconnect(_on_left_stick_direction_changed)
	_woodPiece.geometry_changed.disconnect(_cutLine.on_wood_geometry_changed)
	_handsaw.in_action.disconnect(_on_saw_action)
	
	_woodRenderer.unbind(_woodPiece)
	_directional_input_reader.queue_free()
	_handsaw.queue_free()
	_cutLine.queue_free()

func _on_right_stick_direction_changed(direction: Vector2) -> void:
	if not _current_state == gameState.SAW_ACTION:
		return
	match direction :
		Vector2.RIGHT:
			_handsaw.push()
		Vector2.LEFT:
			_handsaw.pull()
		_:
			pass

func _on_left_stick_direction_changed(direction: Vector2) -> void:
	match _current_state:
		gameState.START_POINT:
			_cutLine.move_marker(true, direction)
		gameState.END_POINT:
			_cutLine.move_marker(false, direction)
		_: 
			pass

func _exit_state(state: int) -> void:
	match state:
		gameState.START_POINT:
			pass
		gameState.END_POINT:
			_cutLine.hide_marker(false)
			_cutLine.hide_marker(true)
		gameState.SAW_ACTION:
			self.remove_child(_handsaw)
	
func _enter_state(new_state: int) -> void:
	match new_state:
		gameState.START_POINT:
			_cutLine.show_marker(true)
			_cutLine.hide_marker(false)
		gameState.END_POINT:
			_cutLine.show_marker(true)
			_cutLine.show_marker(false)
		gameState.SAW_ACTION:
			var cut_start_position = _cutLine.get_cut_start_position()
			var cut_end_position = _cutLine.get_cut_end_position()
			_saw_operation = SawOperation.new(cut_start_position, cut_end_position)
			self.add_child(_handsaw)

func _get_final_state() -> int:
	return gameState.SAW_ACTION # Overide in child.  Must return the highest game_state's value
	
func _on_game_cancelled() -> void:
	cancel_game("Do you want to stop sawing ?", "Press A to validate")

func _on_saw_action() -> void:
	if _saw_operation == null or not get_children().has(_handsaw):
		#error to handle
		return
	_saw_operation.update_progression()
	var new_saw_position = _saw_operation.get_current_position()
	_handsaw.move_to(new_saw_position)

# -----------------------------------------------------------------------------
# handsaw_game2.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------

extends ToolGame
class_name HandsawGameV2

enum gameState { START_POINT, END_POINT, SAW_ACTION }

@onready var _handsaw : Handsaw = $Handsaw
@onready var _visualMarkers = $VisualMarkers
@onready var _cutLine := $VisualMarkers/CutLines

var _directional_input_reader = DirectionalInputReader.new()
var _woodPiece: WoodPiece


func _ready() -> void:
	_directional_input_reader.right_stick_direction_changed.connect(_on_right_stick_direction_changed)
	_directional_input_reader.left_stick_direction_changed.connect(_on_left_stick_direction_changed)
	self.add_child(_directional_input_reader)
	
	#TODO how to get the wood piece ?
	_woodPiece = WoodPiece.new("Alder", $WoodPiece._size)
	
	_cutLine.on_wood_geometry_changed(_woodPiece.get_geometry_polygon())
	_woodPiece.geometry_changed.connect(_cutLine.on_wood_geometry_changed)
	
	_start_state(gameState.START_POINT)

func _exit_tree() -> void:
	_directional_input_reader.right_stick_direction_changed.disconnect(_on_right_stick_direction_changed)
	_directional_input_reader.left_stick_direction_changed.disconnect(_on_left_stick_direction_changed)
	_woodPiece.geometry_changed.disconnect(_cutLine.on_wood_geometry_changed)
	
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
			return

func _exit_state(state: int) -> void:
	match state:
		gameState.START_POINT:
			_cutLine.hideMarker(false)
		gameState.END_POINT:
			_cutLine.hideMarker(false)
		gameState.SAW_ACTION:
			self.remove_child(_handsaw)
	
func _enter_state(new_state: int) -> void:
	match new_state:
		gameState.START_POINT:
			if (not self.get_children().has(_cutLine)):
					self.add_child(_cutLine)
			_cutLine.start_new_cut()
			_cutLine.showMarker(true)
		gameState.END_POINT:
			_cutLine.showMarker(false)
		gameState.SAW_ACTION:
			_visualMarkers.remove_child(_cutLine)
			self.add_child(_handsaw)

	
func _get_final_state() -> int:
	return gameState.SAW_ACTION # Overide in child.  Must return the highest game_state's value
	
func _on_game_cancelled() -> void:
	cancel_game("Do you want to stop sawing ?", "Press A to validate")

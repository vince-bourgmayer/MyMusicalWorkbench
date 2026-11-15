# -----------------------------------------------------------------------------
# handplane_game2.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends ToolGame
class_name HandPlaneGame2

@onready var _jackplane = $JackPlane
@onready var _woodRenderer := $WoodRenderer

enum gameState { PLACE, PLANE, RESTART}

var _plane_operation : PlaneOperation
var _triggerInputReader := TriggersInputReader.new()
var _woodPiece : WoodPiece #need to be passed to parent when exiting


func _ready() -> void:
	_plane_operation = PlaneOperation.new()
	self.add_child(_triggerInputReader)
	
	_woodPiece = WoodPiece.new("Alder", _woodRenderer.get_wood_size())
	_woodRenderer.bind(_woodPiece)
	
	_start_state(gameState.PLACE)
	
func _exit_tree():
	_jackplane.queue_free()
	_woodRenderer.queue_free()
	_triggerInputReader.queue_free()
	

func _exit_state(state: int) -> void:
	match state:
		gameState.PLACE:
			pass
		gameState.PLANE:
			pass
		gameState.RESTART:
			pass
		_: pass

	
func _enter_state(new_state: int) -> void:
	match new_state:
		gameState.PLACE:
			pass
		gameState.PLANE:
			pass
		gameState.RESTART:
			pass
		_: pass

func _get_final_state() -> int:
	return gameState.RESTART
	
func _on_game_cancelled() -> void:
	cancel_game("Do you want to stop planing ?", "Press A to validate")

# -----------------------------------------------------------------------------
# handsaw_game.gd
# Copyright (c) 2025-2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends ToolGame
class_name HandsawGame

enum gameState { SET_START_POINT, SET_END_POINT, SET_CUT }

@onready var handsaw = $Handsaw
@onready var woodboard = $Woodboard
@onready var visualMarkers = $VisualMarkers
const sawing_progress_step = 0.005

var currentState: gameState = gameState.SET_START_POINT

var cutLine: CutLines
var cut_increment := 0.0 # step of the cut progress

func _ready() -> void:
	cutLine = CutLines.new()
	visualMarkers.add_child(cutLine)
	start_new_cut()
	
func start_new_cut():
	handsaw.rotate(handsaw.rotation*-1)
	handsaw.hide()
	cut_increment = 0.0
	cutLine.start_new_cut(woodboard.get_remaining_wood_border())
	#debug
	for segment in woodboard.get_remaining_wood_border():
		segment._print()
		
	currentState = gameState.SET_START_POINT
	
func set_start_point(): # user validates the start point
	cutLine._on_start_point_confirmed()
	currentState = gameState.SET_END_POINT

func set_end_point(): # user validates end Point
	cutLine._on_end_point_confirmed()
	var cut_start_position = cutLine.get_cut_start_position()
	
	handsaw.prepare_for_cut(cut_start_position, cutLine.get_cutline_angle())
	currentState = gameState.SET_CUT
		
func cancel_set_end_point(): # user cancelled the set_end_point action
	cutLine._on_start_point_reverted()
	currentState = gameState.SET_START_POINT

func handle_specific_input(event: InputEvent) -> void:
	if currentState == gameState.SET_START_POINT:
		handleStartInputs(event)
	elif currentState == gameState.SET_END_POINT:
		handleStartInputs(event)
	elif currentState == gameState.SET_CUT:
		handleCutInputs(event)

func handleStartInputs(event: InputEvent) -> void:
	cutLine.handle_inputs_for_marker(event, currentState == gameState.SET_START_POINT)
	if event.is_action_released("place_tool"):
		if currentState == gameState.SET_START_POINT:
			set_start_point()
		elif currentState == gameState.SET_END_POINT:
			set_end_point()
			
	if event.is_action_released("ui_cancel"):
		match currentState:
			gameState.SET_END_POINT:
				cancel_set_end_point()
			gameState.SET_START_POINT:
				cancel_game("Do you want to stop sawing ?", "Press A to validate")
			gameState.SET_CUT:
				# Will need extra work, to use the current position of the saw 
				# as the end point of a new cutline. Except if equal to start point
				pass

func handleCutInputs(event: InputEvent) -> void:
	if event.is_action_pressed("push_saw"):
		handsaw.push()
	elif event.is_action_pressed("pull_saw"):
		handsaw.pull()
	elif event.is_action_released("push_saw") || event.is_action_released("pull_saw"):
		handsaw.idle()

func make_progress():
	if cut_increment < 1.0:
		cut_increment+= sawing_progress_step
		var cut_start_position = cutLine.get_cut_start_position()
		var cut_end_position = cutLine.get_cut_end_position()
		handsaw.position = cut_start_position.lerp(cut_end_position, cut_increment) #NC
	else: #cut is finished
		#cutLine._on_cut_achieved()
		woodboard.add_new_cut(cutLine.startMarker.position, cutLine.endMarker.position)
		start_new_cut()

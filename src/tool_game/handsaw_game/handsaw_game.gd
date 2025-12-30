# -----------------------------------------------------------------------------
# handsaw_game.gd
# Copyright (c) 2025 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends ToolGame
class_name HandsawGame

enum gameState { SET_START_POINT, SET_END_POINT, SET_CUT }

@onready var handsaw = $Handsaw
@onready var woodboard = $Woodboard
@onready var visualMarkers = $VisualMarkers
const sawing_progress_step = 0.01

var currentState: gameState = gameState.SET_START_POINT
var cutStartMarker: CutMarker
var cutEndMarker: CutMarker
var cutlines: Array[Line2D]= []
var current_cutline_index := -1
var cut_increment := 0.0 # step of the cut progress

func _ready() -> void:
	cutStartMarker = CutMarker.new()
	cutStartMarker.set_path(woodboard.get_remaining_wood_border())
	visualMarkers.add_child(cutStartMarker)
	
	cutEndMarker = CutMarker.new(Color.BLUE)
	cutEndMarker.set_path(woodboard.get_remaining_wood_border())
	cutEndMarker.visible = false
	visualMarkers.add_child(cutEndMarker)	
	handsaw.top_level = true
	
func start_new_cut():
	handsaw.rotate(handsaw.rotation*-1)
	cut_increment = 0.0
	cutStartMarker.set_path(woodboard.get_remaining_wood_border())
	cutStartMarker.set_direction(0)
	cutEndMarker.set_path(woodboard.get_remaining_wood_border())
	cutEndMarker.set_direction(0)
	
	cutStartMarker.visible = true
	cutEndMarker.visible = false
	handsaw.visible = false
	
	currentState = gameState.SET_START_POINT
	

func set_start_point():
	cutStartMarker.split_current_segment()
	currentState = gameState.SET_END_POINT
	cutEndMarker.visible = true
	
	var cutline : Line2D = Line2D.new()
	cutline.default_color = Color.BLUE
	cutline.width = 4
	cutline.add_point(cutStartMarker.position)
	cutline.add_point(cutEndMarker.position)
	
	cutlines.append(cutline)
	current_cutline_index += 1
	
	visualMarkers.add_child(cutlines[current_cutline_index])
	
func set_end_point():
	cutEndMarker.split_current_segment()
	cutStartMarker.visible = false
	cutEndMarker.visible = false
	place_saw_for_action()
	currentState = gameState.SET_CUT
		
func place_saw_for_action():
	handsaw.position = cutStartMarker.global_position
	handsaw.rotate(get_cutline_angle())
	handsaw.visible = true

func _process(_delta: float) -> void:
	if currentState == gameState.SET_END_POINT:
		cutlines[current_cutline_index].set_point_position(0, cutStartMarker.position)
		cutlines[current_cutline_index].set_point_position(1, cutEndMarker.position)

func handle_specific_input(event: InputEvent) -> void:
	if currentState == gameState.SET_START_POINT:
		handleStartInputs(event, cutStartMarker)
	elif currentState == gameState.SET_END_POINT:
		handleStartInputs(event, cutEndMarker)
	elif currentState == gameState.SET_CUT:
		handleCutInputs(event)

func handleStartInputs(event: InputEvent, marker: CutMarker) -> void:
	if event.is_action_pressed("move_up"):
		marker.set_direction(-1)
	elif event.is_action_pressed("move_down"):
		marker.set_direction(1)
	elif event.is_action_released("move_up") || event.is_action_released("move_down"):
		marker.set_direction(0)
	
	if event.is_action_released("place_tool"):
		marker.set_direction(0)
		if currentState == gameState.SET_START_POINT:
			set_start_point()
		elif currentState == gameState.SET_END_POINT:
			set_end_point()


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
		handsaw.position = cutStartMarker.global_position.lerp(cutEndMarker.global_position, cut_increment)
	else: #cut is finished
		cutlines[current_cutline_index].default_color = Color.BLACK
		woodboard.add_new_cut(cutStartMarker.position, cutEndMarker.position)
		start_new_cut()

func get_cutline_angle() -> float:
	return ((cutStartMarker.position - cutEndMarker.position).angle_to(Vector2(0,1)) +3.141593 )* -1

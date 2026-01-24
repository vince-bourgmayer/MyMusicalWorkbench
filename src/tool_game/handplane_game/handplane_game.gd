# -----------------------------------------------------------------------------
# handplane_game.gd
# Copyright (c) 2026 Vincent Bourgmayer
# License: MIT
# -----------------------------------------------------------------------------
extends ToolGame
class_name HandPlaneGame

@onready var jackplane = $JackPlane
@onready var woodboard = $WoodboardToPlane

enum gameState { PLACE=0, PLANE=1, RESTART=2 }

var state : gameState
var plane_operation : PlaneOperation
var is_planing := false


func _ready() -> void:
	plane_operation = PlaneOperation.new()
	plane_operation.set_start_edge(get_start_line())
	set_plane_on_start_line()

func get_start_line() -> Segment:
	return woodboard.get_wood_edges()[2]
	
func set_plane_on_start_line() -> void:
	state = gameState.RESTART
	var start_point = plane_operation.get_start_position()
	var tw := create_tween()
	tw.tween_property(jackplane, "position", start_point, 0.5)
	await tw.finished
	state = gameState.PLACE


func _process(_delta: float) -> void:
	match state:
		gameState.PLACE:
			jackplane.position = plane_operation.update_start_position(_delta)
		gameState.PLANE:
			jackplane.set_hands_pressure(_read_hands_pressure())
	

func handle_specific_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		cancel_game("Do you want to stop planing ?", "Press A to validate")
		return
		
	match state:
		gameState.PLACE:
			handle_place_input(event)
		gameState.PLANE:
			handle_planing_input(event)
			if is_planing:
				woodboard.plane_at(jackplane.position, jackplane._get_total_pressure())
		_: pass


func handle_place_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		state = gameState.PLANE
		jackplane.back_area_exited.connect(_on_stroke_finished)	
		jackplane.blade_area_entered.connect(_on_stroke_started)
		return

	var direction = sign(Input.get_axis("ui_up", "ui_down"))
	plane_operation.set_direction(direction)

func handle_planing_input(event: InputEvent) -> void:
	if event.is_action_released("trigger_left"):
		jackplane.press_front(event.get_action_strength("trigger_left"))
			
	if event.is_action("trigger_right"):
		jackplane.press_back(event.get_action_strength("trigger_right"))

func _on_stroke_finished() -> void:
	is_planing = false
	woodboard.plane_at(jackplane.position, jackplane._get_total_pressure())
	woodboard._reset_last_plane_pos()
	jackplane.push(false)
	if jackplane.is_connected("back_area_exited", _on_stroke_finished):
		jackplane.disconnect("back_area_exited", _on_stroke_finished)
	set_plane_on_start_line()
	
func _on_stroke_started() -> void:
	is_planing = true

	
func _read_hands_pressure() -> Vector2:
	var left_hand_pressure = Input.get_action_strength("ui_left")
	var right_hand_pressure = Input.get_action_strength("plane_right_hand")
	
	return Vector2(left_hand_pressure, right_hand_pressure)
